using Assessment.Api.Contracts;
using Assessment.Api.Data;
using Assessment.Api.Models;
using Assessment.Api.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
{
    var connectionString =
        builder.Configuration.GetConnectionString(
            "DefaultConnection");

    options.UseSqlite(connectionString);
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapPost(
    "/api/plannings",
    async (
        CreatePlanningRequest request,
        AppDbContext db,
        CancellationToken cancellationToken) =>
    {
        // =========================================
        // 1. VALIDATION
        // =========================================

        var validationError =
            ValidateRequest(request);

        if (validationError != null)
        {
            return Results.BadRequest(
                new
                {
                    error = validationError
                });
        }

        // =========================================
        // 2. IDEMPOTENCY
        // =========================================

        var existing =
            await db.Plannings
                .Include(x => x.Slots)
                .AsNoTracking()
                .FirstOrDefaultAsync(
                    x =>
                        x.RequestCode ==
                        request.RequestCode,
                    cancellationToken);

        if (existing != null)
        {
            return Results.Ok(
                ToResponse(existing));
        }

        // =========================================
        // 3. BALANCING
        // =========================================

        var input =
            request.Slots
                .OrderBy(x => x.SlotOrder)
                .Select(x =>
                    x.OriginalQuantity)
                .Select(x =>
                    (decimal)x)
                .ToList();

        IReadOnlyList<decimal> balanced;

        try
        {
            balanced =
                BalancingService.Balance(input);
        }
        catch (ArgumentException ex)
        {
            return Results.BadRequest(
                new
                {
                    error = ex.Message
                });
        }

        // =========================================
        // 4. ATOMIC TRANSACTION
        // =========================================

        await using var transaction =
            await db.Database.BeginTransactionAsync(
                cancellationToken);

        try
        {
            // Check again to handle concurrent requests.
            var duplicate =
                await db.Plannings
                    .Include(x => x.Slots)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(
                        x =>
                            x.RequestCode ==
                            request.RequestCode,
                        cancellationToken);

            if (duplicate != null)
            {
                await transaction.CommitAsync(
                    cancellationToken);

                return Results.Ok(
                    ToResponse(duplicate));
            }

            var planning = new Planning
            {
                RequestCode =
                    request.RequestCode.Trim(),

                CandidateToken =
                    request.CandidateToken.Trim(),

                CreatedAt =
                    DateTime.UtcNow,

                Status = "PROCESSED"
            };

            for (var i = 0;
                 i < request.Slots.Count;
                 i++)
            {
                var slot =
                    request.Slots[i];

                planning.Slots.Add(
                    new PlanningSlot
                    {
                        SlotOrder =
                            slot.SlotOrder,

                        SlotName =
                            slot.SlotName.Trim(),

                        OriginalQuantity =
                            slot.OriginalQuantity,

                        BalancedQuantity =
                            (long)balanced[i],

                        IsActive =
                            slot.IsActive
                    });
            }

            db.Plannings.Add(planning);

            await db.SaveChangesAsync(
                cancellationToken);

            await transaction.CommitAsync(
                cancellationToken);

            return Results.Created(
                $"/api/plannings/{planning.PlanningId}",
                ToResponse(planning));
        }
        catch
        {
            await transaction.RollbackAsync(
                cancellationToken);

            throw;
        }
    });


// =========================================
// GET HISTORY
// =========================================

app.MapGet(
    "/api/plannings",
    async (
        int? limit,
        AppDbContext db,
        CancellationToken cancellationToken) =>
    {
        var take =
            Math.Clamp(
                limit ?? 20,
                1,
                100);

        var result =
            await db.Plannings
                .Include(x => x.Slots)
                .AsNoTracking()
                .OrderByDescending(
                    x => x.CreatedAt)
                .Take(take)
                .ToListAsync(
                    cancellationToken);

        return Results.Ok(
            result.Select(ToResponse));
    });


// =========================================
// GET DETAIL
// =========================================

app.MapGet(
    "/api/plannings/{id:long}",
    async (
        long id,
        AppDbContext db,
        CancellationToken cancellationToken) =>
    {
        var planning =
            await db.Plannings
                .Include(x => x.Slots)
                .AsNoTracking()
                .FirstOrDefaultAsync(
                    x =>
                        x.PlanningId == id,
                    cancellationToken);

        if (planning == null)
        {
            return Results.NotFound(
                new
                {
                    error = "Planning not found."
                });
        }

        return Results.Ok(
            ToResponse(planning));
    });


app.Run();


// =========================================
// VALIDATION
// =========================================

static string? ValidateRequest(
    CreatePlanningRequest request)
{
    if (string.IsNullOrWhiteSpace(
            request.RequestCode))
    {
        return "RequestCode is required.";
    }

    if (string.IsNullOrWhiteSpace(
            request.CandidateToken))
    {
        return "CandidateToken is required.";
    }

    if (!request.CandidateToken
        .StartsWith("VEH-",
            StringComparison.Ordinal))
    {
        return
            "CandidateToken must start with VEH-.";
    }

    if (request.Slots == null ||
        request.Slots.Count != 7)
    {
        return
            "Exactly 7 slots are required.";
    }

    var orderedSlots =
        request.Slots
            .OrderBy(x => x.SlotOrder)
            .ToList();

    var expectedOrders =
        Enumerable.Range(1, 7)
            .ToArray();

    var actualOrders =
        orderedSlots
            .Select(x => x.SlotOrder)
            .ToArray();

    if (!actualOrders.SequenceEqual(
            expectedOrders))
    {
        return
            "SlotOrder must contain 1 through 7.";
    }

    foreach (var slot in orderedSlots)
    {
        if (string.IsNullOrWhiteSpace(
                slot.SlotName))
        {
            return
                $"Slot {slot.SlotOrder}: SlotName is required.";
        }

        if (slot.OriginalQuantity < 0)
        {
            return
                $"Slot {slot.SlotOrder}: quantity cannot be negative.";
        }

        if (!slot.IsActive &&
            slot.OriginalQuantity != 0)
        {
            return
                $"Slot {slot.SlotOrder}: inactive slot must have quantity 0.";
        }
    }

    return null;
}


// =========================================
// RESPONSE MAPPER
// =========================================

static PlanningResponse ToResponse(
    Planning planning)
{
    return new PlanningResponse(
        planning.PlanningId,
        planning.RequestCode,
        planning.CandidateToken,
        planning.CreatedAt,
        planning.Status,
        planning.Slots.Sum(
            x => x.OriginalQuantity),
        planning.Slots.Sum(
            x => x.BalancedQuantity),
        planning.Slots
            .OrderBy(x => x.SlotOrder)
            .Select(x =>
                new PlanningSlotResponse(
                    x.SlotOrder,
                    x.SlotName,
                    x.OriginalQuantity,
                    x.BalancedQuantity,
                    x.IsActive))
            .ToList());
}