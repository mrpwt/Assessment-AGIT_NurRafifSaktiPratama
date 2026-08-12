using Assessment.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Assessment.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(
        DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Planning> Plannings => Set<Planning>();

    public DbSet<PlanningSlot> PlanningSlots =>
        Set<PlanningSlot>();

    protected override void OnModelCreating(
        ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Planning>(entity =>
        {
            entity.HasKey(x => x.PlanningId);

            entity.Property(x => x.RequestCode)
                .IsRequired();

            entity.HasIndex(x => x.RequestCode)
                .IsUnique();

            entity.Property(x => x.CandidateToken)
                .IsRequired();

            entity.Property(x => x.Status)
                .IsRequired();

            entity.Property(x => x.CreatedAt)
                .IsRequired();
        });

        modelBuilder.Entity<PlanningSlot>(entity =>
        {
            entity.HasKey(x =>
                new
                {
                    x.PlanningId,
                    x.SlotOrder
                });

            entity.Property(x => x.SlotName)
                .IsRequired();

            entity.Property(x => x.OriginalQuantity)
                .IsRequired();

            entity.Property(x => x.BalancedQuantity)
                .IsRequired();

            entity.ToTable(
                "PlanningSlot",
                table =>
                {
                    table.HasCheckConstraint("CK_PlanningSlot_OriginalQuantity_NonNegative", "OriginalQuantity >= 0");

                    table.HasCheckConstraint("CK_PlanningSlot_BalancedQuantity_NonNegative", "BalancedQuantity >= 0");
            });

            entity.HasOne(x => x.Planning)
                .WithMany(x => x.Slots)
                .HasForeignKey(x => x.PlanningId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}