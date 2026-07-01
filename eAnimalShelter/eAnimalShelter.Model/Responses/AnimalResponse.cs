using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Responses
{
    public class AnimalResponse
    {
        public int AnimalId { get; set; }

        public string Name { get; set; } = string.Empty;

        public int SpeciesId { get; set; }

        public string? SpeciesName { get; set; }

        public int BreedId { get; set; }

        public string? BreedName { get; set; }

        public AnimalGender Gender { get; set; } 

        public DateTime BirthDate { get; set; }

        public string Description { get; set; } = string.Empty;

        public string PersonalityDescription { get; set; } = string.Empty;

        public string HealthStatus { get; set; } = string.Empty;

        public bool IsVaccinated { get; set; }

        public string? MedicalNotes { get; set; }

        public DateTime? ArrivalDate { get; set; }

        public AnimalStatus AdoptionStatus { get; set; }

        public int CreatedBy { get; set; }

        public string? CreatedByUserName { get; set; }

        public List<AnimalImageResponse> Images { get; set; } = new();
       
    }
}