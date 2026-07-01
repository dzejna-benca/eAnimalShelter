using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Responses{
public class VolunteerActivityDetailsResponse
{
    public int ActivityId { get; set; }

    public string Title { get; set; } = "";

    public string Description { get; set; } = "";

    public string LocationName { get; set; } = "";

    public DateTime StartDateTime { get; set; }

    public DateTime EndDateTime { get; set; }

    public int MaxVolunteers { get; set; }

    public ActivityStatus Status { get; set; }

    public string CreatedByUserName { get; set; } = "";

    public List<VolunteerAssignmentResponse> Assignments { get; set; }
        = new();
    
    public bool IsApplied { get; set; }
}
}