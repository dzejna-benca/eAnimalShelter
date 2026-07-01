using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Requests
{
    public class VolunteerActivityUpdateRequest
    {
        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public int LocationId { get; set; }

        public DateTime StartDateTime { get; set; }

        public DateTime EndDateTime { get; set; }

        public int MaxVolunteers { get; set; }

    }
}
