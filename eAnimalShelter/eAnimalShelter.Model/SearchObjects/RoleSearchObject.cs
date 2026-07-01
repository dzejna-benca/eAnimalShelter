using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Model.SearchObjects
{
    public class RoleSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }

        public bool? IsActive { get; set; }
    }
}
