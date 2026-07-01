using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.SearchObjects
{
    public class AdoptionRequestSearchObject : BaseSearchObject
    {
        public int? AnimalId { get; set; }

        public int? UserId { get; set; }

        public AdoptionRequestStatus? Status { get; set; }

        public DateTime? RequestDateFrom { get; set; }

        public DateTime? RequestDateTo { get; set; } 
        public string? FTS { get; set; }
    }
}
