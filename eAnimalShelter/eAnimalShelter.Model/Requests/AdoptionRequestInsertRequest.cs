namespace eAnimalShelter.Model.Requests
{
    public class AdoptionRequestInsertRequest
    {
        public int AnimalId { get; set; }

        public string HousingType { get; set; } = string.Empty;

        public string ExperienceWithPets { get; set; } = string.Empty;

        public int HouseholdMembers { get; set; }

        public string? AdditionalNotes { get; set; }
    }
}
