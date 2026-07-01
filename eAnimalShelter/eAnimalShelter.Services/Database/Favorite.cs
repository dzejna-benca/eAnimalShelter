using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eAnimalShelter.Services.Database
{
    public class Favorite
    {
        [Key]
        public int FavoriteId { get; set; }
        public int AnimalId { get; set; }
        [ForeignKey("AnimalId")]
        public Animal Animal { get; set; } = null!;
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; } = null!;
        public DateTime DateAdded { get; set; }
    }
}