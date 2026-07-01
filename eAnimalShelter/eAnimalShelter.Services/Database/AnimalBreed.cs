using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eAnimalShelter.Services.Database
{
    public class AnimalBreed
    {
        [Key]
        public int BreedId { get; set; }
        public string BreedName { get; set; } = string.Empty;
        public int SpeciesId { get; set; }

        [ForeignKey(nameof(SpeciesId))]
        public AnimalSpecies Species { get; set; } = null!;

    
        
    }
}