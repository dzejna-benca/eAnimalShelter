using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Requests
{
    public class AdoptionRequestUpdateRequest
    {
        public string HousingType { get; set; } = string.Empty;

        public string ExperienceWithPets { get; set; } = string.Empty;

        public int HouseholdMembers { get; set; }

        public string? AdditionalNotes { get; set; }
        public string? AdminComment { get; set; }

    }
    

}
