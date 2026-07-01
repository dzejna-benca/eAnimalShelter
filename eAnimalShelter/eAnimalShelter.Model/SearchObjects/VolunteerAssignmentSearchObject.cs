using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.SearchObjects
{
    public class VolunteerAssignmentSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }

        public int? ActivityId { get; set; }

        public AssignmentStatus? Status { get; set; }
    }
}
