using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Model.SearchObjects
{
    public class AnimalBreedSearchObject : BaseSearchObject
    {
        public string? BreedName { get; set; }

        public int? SpeciesId { get; set; }

    }
}