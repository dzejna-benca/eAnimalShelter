using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Model.SearchObjects
{
    public class AnnouncementSearchObject : BaseSearchObject
    {
        public string? Title { get; set; }

        public bool? IsActive { get; set; }
    }
}
