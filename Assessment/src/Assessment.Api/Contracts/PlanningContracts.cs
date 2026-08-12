namespace Assessment.Api.Contracts;

public sealed record CreatePlanningRequest(
    string RequestCode,
    string CandidateToken,
    IReadOnlyList<PlanningSlotRequest> Slots
);

public sealed record PlanningSlotRequest(
    int SlotOrder,
    string SlotName,
    long OriginalQuantity,
    bool IsActive
);

public sealed record PlanningResponse(
    long PlanningId,
    string RequestCode,
    string CandidateToken,
    DateTime CreatedAt,
    string Status,
    long OriginalTotal,
    long BalancedTotal,
    IReadOnlyList<PlanningSlotResponse> Slots
);

public sealed record PlanningSlotResponse(
    int SlotOrder,
    string SlotName,
    long OriginalQuantity,
    long BalancedQuantity,
    bool IsActive
);