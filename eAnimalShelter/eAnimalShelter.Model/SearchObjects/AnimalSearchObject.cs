using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.SearchObjects
{
    public class AnimalSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }

        public int? SpeciesId { get; set; }

        public int? BreedId { get; set; }

        public AnimalGender? Gender { get; set; }

        public AnimalStatus? AdoptionStatus { get; set; }

        public bool? IsVaccinated { get; set; }

        public int? CreatedBy { get; set; }

        public DateTime? ArrivalDateFrom { get; set; }

        public DateTime? ArrivalDateTo { get; set; }
    }
}