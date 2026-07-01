using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Responses
{
    public class VolunteerActivityResponse
    {
        public int ActivityId { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public int LocationId { get; set; }

        public string? LocationName { get; set; }

        public DateTime StartDateTime { get; set; }

        public DateTime EndDateTime { get; set; }

        public int MaxVolunteers { get; set; }

        public ActivityStatus Status { get; set; }

        public int CreatedBy { get; set; }

        public string? CreatedByUserName { get; set; }
        public int CurrentVolunteers { get; set; }
        public int ApplicationsCount { get; set; }
    }
}
