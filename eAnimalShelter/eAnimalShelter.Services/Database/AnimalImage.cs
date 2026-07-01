using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eAnimalShelter.Services.Database
{
    public class AnimalImage
    {
        [Key]
        public int ImageId { get; set; }
        public int AnimalId { get; set; }
         [ForeignKey("AnimalId")]
        public Animal Animal { get; set; } = null!;
        [Required]
        [MaxLength(100)]
        public string FileName { get; set; } = string.Empty;
        [Required]
        [MaxLength(500)]
        public string ImagePath { get; set; } = string.Empty;
        public DateTime DateAdded { get; set; } = DateTime.UtcNow;
    }
}