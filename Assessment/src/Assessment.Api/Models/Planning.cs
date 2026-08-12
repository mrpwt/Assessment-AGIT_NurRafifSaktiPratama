namespace Assessment.Api.Models;

public class Planning
{
    public long PlanningId { get; set; }

    public string RequestCode { get; set; } = string.Empty;

    public string CandidateToken { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; }

    public string Status { get; set; } = string.Empty;

    public List<PlanningSlot> Slots { get; set; } = [];
}

public class PlanningSlot
{
    public long PlanningId { get; set; }

    public int SlotOrder { get; set; }

    public string SlotName { get; set; } = string.Empty;

    public long OriginalQuantity { get; set; }

    public long BalancedQuantity { get; set; }

    public bool IsActive { get; set; }

    public Planning Planning { get; set; } = null!;
}