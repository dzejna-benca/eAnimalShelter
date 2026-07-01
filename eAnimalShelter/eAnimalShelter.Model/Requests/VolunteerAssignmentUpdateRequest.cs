using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Requests
{
    public class VolunteerAssignmentUpdateRequest
    {
        public string? ApplicationNote { get; set; }
        public decimal HoursWorked { get; set; }
    }
}
