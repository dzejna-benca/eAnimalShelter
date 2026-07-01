namespace eAnimalShelter.Model.SearchObjects
{
    public class AnimalImageSearchObject : BaseSearchObject
    {
        public int? AnimalId { get; set; }

        public DateTime? DateAddedFrom { get; set; }

        public DateTime? DateAddedTo { get; set; }
    }
}