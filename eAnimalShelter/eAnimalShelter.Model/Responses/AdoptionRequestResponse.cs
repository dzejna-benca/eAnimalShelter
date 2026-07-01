using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Responses
{
    public class AdoptionRequestResponse
    {
        public int AdoptionRequestId { get; set; }

        public int UserId { get; set; }

        public string? UserName { get; set; }

        public int AnimalId { get; set; }

        public string? AnimalName { get; set; }

        public DateTime RequestDate { get; set; }

        public string HousingType { get; set; } = string.Empty;

        public string ExperienceWithPets { get; set; } = string.Empty;

        public int HouseholdMembers { get; set; }

        public string? AdditionalNotes { get; set; }

        public AdoptionRequestStatus Status { get; set; }

        public int? ReviewedBy { get; set; }

        public string? ReviewedByUserName { get; set; }

        public DateTime? ReviewDate { get; set; }

        public string? AdminComment { get; set; } 
        public UserResponse? User { get; set; }
        public AnimalResponse? Animal { get; set; }
    }
}
