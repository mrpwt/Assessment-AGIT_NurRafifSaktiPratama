using Assessment.Api.Services;

namespace Assessment.Tests;

public class BalancingServiceTests
{
    // =====================================================
    // 1. SAMPLE TEST
    // Requirement:
    // [4, 5, 1, 7, 6, 4, 0]
    // must become
    // [4, 5, 4, 5, 5, 4, 0]
    // =====================================================

    [Fact]
    public void Sample_ShouldReturnExpectedResult()
    {
        var input = new decimal[]
        {
            4,
            5,
            1,
            7,
            6,
            4,
            0
        };

        var result =
            BalancingService.Balance(input);

        var expected = new decimal[]
        {
            4,
            5,
            4,
            5,
            5,
            4,
            0
        };

        Assert.Equal(
            expected,
            result);
    }


    // =====================================================
    // 2. TOTAL HABIS DIBAGI
    // =====================================================

    [Fact]
    public void TotalDivisible_ShouldDistributeEqually()
    {
        var input = new decimal[]
        {
            1,
            2,
            3
        };

        var result =
            BalancingService.Balance(input);

        var expected = new decimal[]
        {
            2,
            2,
            2
        };

        Assert.Equal(
            expected,
            result);
    }


    // =====================================================
    // 3. TOTAL BERSISA
    // =====================================================

    [Fact]
    public void TotalWithRemainder_ShouldPrioritizeLargestOriginal()
    {
        var input = new decimal[]
        {
            1,
            8,
            1
        };

        var result =
            BalancingService.Balance(input);

        var expected = new decimal[]
        {
            3,
            4,
            3
        };

        Assert.Equal(
            expected,
            result);
    }


    // =====================================================
    // 4. SEMUA 0
    // =====================================================

    [Fact]
    public void AllZero_ShouldRemainZero()
    {
        var input = new decimal[]
        {
            0,
            0,
            0,
            0,
            0,
            0,
            0
        };

        var result =
            BalancingService.Balance(input);

        var expected = new decimal[]
        {
            0,
            0,
            0,
            0,
            0,
            0,
            0
        };

        Assert.Equal(
            expected,
            result);
    }


    // =====================================================
    // 5. HANYA SATU SLOT AKTIF
    // =====================================================

    [Fact]
    public void OneActiveSlot_ShouldKeepEntireQuantity()
    {
        var input = new decimal[]
        {
            0,
            0,
            15,
            0
        };

        var result =
            BalancingService.Balance(input);

        var expected = new decimal[]
        {
            0,
            0,
            15,
            0
        };

        Assert.Equal(
            expected,
            result);
    }


    // =====================================================
    // 6. TIE
    // =====================================================

    [Fact]
    public void Tie_ShouldPrioritizeEarlierSlot()
    {
        var input = new decimal[]
        {
            5,
            5,
            1
        };

        var result =
            BalancingService.Balance(input);

        var expected = new decimal[]
        {
            4,
            4,
            3
        };

        Assert.Equal(
            expected,
            result);
    }


    // =====================================================
    // 7. NEGATIVE INPUT
    // =====================================================

    [Fact]
    public void NegativeInput_ShouldBeRejected()
    {
        var input = new decimal[]
        {
            4,
            -1,
            5
        };

        Assert.Throws<ArgumentException>(
            () =>
                BalancingService.Balance(input));
    }


    // =====================================================
    // 8. PECAHAN
    // Requirement:
    // Input pecahan tidak valid.
    // =====================================================

    [Fact]
    public void FractionalInput_ShouldBeRejected()
    {
        var input = new decimal[]
        {
            4,
            2.5m,
            5
        };

        Assert.Throws<ArgumentException>(
            () =>
                BalancingService.Balance(input));
    }


    // =====================================================
    // 9. EDGE CASE:
    // Total invariant
    //
    // Bug yang dicegah:
    // algoritma mengubah total produksi.
    // =====================================================

    [Fact]
    public void Total_ShouldRemainUnchanged()
    {
        var input = new decimal[]
        {
            10,
            3,
            7,
            2,
            0
        };

        var result =
            BalancingService.Balance(input);

        var originalTotal =
            input.Sum();

        var balancedTotal =
            result.Sum();

        Assert.Equal(
            originalTotal,
            balancedTotal);
    }


    // =====================================================
    // 10. EDGE CASE:
    // Inactive slot tetap 0
    //
    // Bug yang dicegah:
    // proses balancing memberikan quantity
    // ke slot yang seharusnya tidak beroperasi.
    // =====================================================

    [Fact]
    public void InactiveSlot_ShouldRemainZero()
    {
        var input = new decimal[]
        {
            10,
            8,
            0,
            5,
            0
        };

        var result =
            BalancingService.Balance(input);

        Assert.Equal(
            0,
            result[2]);

        Assert.Equal(
            0,
            result[4]);
    }


    // =====================================================
    // 11. EDGE CASE:
    // Active spread maksimal 1
    //
    // Bug yang dicegah:
    // hasil balancing masih terlalu tidak merata.
    // =====================================================

    [Fact]
    public void ActiveSlots_ShouldHaveMaximumDifferenceOfOne()
    {
        var input = new decimal[]
        {
            100,
            1,
            20,
            7,
            0
        };

        var result =
            BalancingService.Balance(input);

        var activeResults =
            result
                .Where((value, index) =>
                    input[index] > 0)
                .ToList();

        var max =
            activeResults.Max();

        var min =
            activeResults.Min();

        Assert.True(
            max - min <= 1);
    }


    // =====================================================
    // 12. EDGE CASE:
    // Input hanya satu slot
    //
    // Bug yang dicegah:
    // division by zero / logic khusus untuk
    // satu slot tidak ditangani.
    // =====================================================

    [Fact]
    public void SingleSlot_ShouldRemainUnchanged()
    {
        var input = new decimal[]
        {
            27
        };

        var result =
            BalancingService.Balance(input);

        Assert.Equal(
            new decimal[] { 27 },
            result);
    }
}