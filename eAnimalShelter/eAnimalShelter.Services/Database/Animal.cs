using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using eAnimalShelter.Model.Enums;


namespace eAnimalShelter.Services.Database
{
    public class Animal
    {
        [Key]
        public int AnimalId { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;
        public int SpeciesId { get; set; }
        [ForeignKey("SpeciesId")]
        public AnimalSpecies Species { get; set; } = null!;
        public int BreedId { get; set; }
         [ForeignKey("BreedId")]
        public AnimalBreed Breed { get; set; } = null!;
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
         [ForeignKey("CreatedBy")]
        public User CreatedByUser { get; set; } = null!;

        public ICollection<AnimalImage> Images { get; set; } = new List<AnimalImage>();
        public ICollection<AdoptionRequest> AdoptionRequests { get; set; } = new List<AdoptionRequest>();
        
    }


}