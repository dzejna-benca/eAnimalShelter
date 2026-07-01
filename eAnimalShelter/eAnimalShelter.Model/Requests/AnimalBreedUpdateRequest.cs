namespace eAnimalShelter.Model.Requests
{
    public class AnimalBreedUpdateRequest
    {
        public string BreedName { get; set; } = string.Empty;

        public int SpeciesId { get; set; }
    }
}