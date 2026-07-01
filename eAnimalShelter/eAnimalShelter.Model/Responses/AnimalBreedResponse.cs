namespace eAnimalShelter.Model.Responses
{
    public class AnimalBreedResponse
    {
        public int BreedId { get; set; }

        public string BreedName { get; set; } = string.Empty;

        public int SpeciesId { get; set; }

        public string? SpeciesName { get; set; }
    }
}