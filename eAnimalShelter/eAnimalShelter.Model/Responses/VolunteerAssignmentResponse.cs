using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Responses
{
    public class VolunteerAssignmentResponse
    {
        public int AssignmentId { get; set; }

        public int UserId { get; set; }

        public string? UserName { get; set; }

        public int ActivityId { get; set; }

        public string? ActivityTitle { get; set; }

        public DateTime AppliedAt { get; set; }

        public string? ApplicationNote { get; set; }

        public AssignmentStatus Status { get; set; }

        public decimal HoursWorked { get; set; }
        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }
        public string? AdminResponseReason { get; set; }
        public DateTime ActivityStartDateTime { get; set; }
    }
}
