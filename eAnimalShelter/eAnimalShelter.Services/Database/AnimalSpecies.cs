using System.ComponentModel.DataAnnotations;

namespace eAnimalShelter.Services.Database
{
    public class AnimalSpecies
    {
        [Key]
        public int SpeciesId { get; set; }
        public string SpeciesName { get; set; } = string.Empty;
        
    }
}