namespace eAnimalShelter.Model.Requests
{
    public class AnimalBreedInsertRequest
    {
        public string BreedName { get; set; } = string.Empty;

        public int SpeciesId { get; set; }
    }
}