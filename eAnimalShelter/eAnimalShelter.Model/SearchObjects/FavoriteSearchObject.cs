using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Model.SearchObjects
{
    public class FavoriteSearchObject : BaseSearchObject
    {
        public int? AnimalId { get; set; }

        public int? UserId { get; set; }
    }
}
