namespace Assessment.Api.Services;

public static class BalancingService
{
    public static IReadOnlyList<decimal> Balance(
        IReadOnlyList<decimal> input)
    {
        if (input is null || input.Count == 0)
        {
            throw new ArgumentException(
                "Input must contain at least one slot.",
                nameof(input));
        }

        // Validasi seluruh input
        foreach (var quantity in input)
        {
            if (quantity < 0)
            {
                throw new ArgumentException(
                    "Input quantity cannot be negative.");
            }

            if (quantity != decimal.Truncate(quantity))
            {
                throw new ArgumentException(
                    "Input quantity must be a whole number.");
            }
        }

        // SSlot dengan value 0 dianggap inactive.
        var activeSlots = input
            .Select((quantity, index) => new
            {
                Quantity = quantity,
                Index = index
            })
            .Where(x => x.Quantity > 0)
            .ToList();

        // Jika tidak ada slot aktif, maka semua slot harus tetap 0.
        if (activeSlots.Count == 0)
        {
            return input
                .Select(_ => 0m)
                .ToList();
        }

        var total = activeSlots.Sum(
            x => x.Quantity);

        var activeSlotCount =
            activeSlots.Count;

        // Minimum quantity per active slot setelah balancing.
        var baseQuantity =
            decimal.Floor(
                total / activeSlotCount);

        // Menghitung sisa jumlah yang tidak dapat dibagi rata.
        var remainder =
            (int)(total % activeSlotCount);

        /*
         * Mekanisme prioritas untuk slot yang akan menerima tambahan 1 unit dari sisa.
         * Prioritas ditentukan oleh:
         * 1. Quantity terbesar.
         * 2. Slot yang lebih awal ketika quantity asli sama.
         */
        var prioritySlots = activeSlots
            .OrderByDescending(
                x => x.Quantity)
            .ThenBy(
                x => x.Index)
            .Take(remainder)
            .Select(
                x => x.Index)
            .ToHashSet();

        return input
            .Select((quantity, index) =>
            {
                // Slot dengan value 0 dianggap inactive dan harus tetap 0.
                if (quantity == 0)
                {
                    return 0m;
                }

                return baseQuantity +
                       (
                           prioritySlots.Contains(index)
                               ? 1m
                               : 0m
                       );
            })
            .ToList();
    }
}