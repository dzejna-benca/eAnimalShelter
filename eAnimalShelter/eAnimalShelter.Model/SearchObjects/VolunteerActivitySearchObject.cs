using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.SearchObjects
{
    public class VolunteerActivitySearchObject : BaseSearchObject
    {
        public string? Title { get; set; }

        public int? LocationId { get; set; }

        public ActivityStatus? Status { get; set; }

        public DateTime? StartDateTimeFrom { get; set; }

        public DateTime? StartDateTimeTo { get; set; }
    }
}
