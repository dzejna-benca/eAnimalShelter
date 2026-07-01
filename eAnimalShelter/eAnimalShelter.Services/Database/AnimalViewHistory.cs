using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eAnimalShelter.Services.Database
{
    public class AnimalViewHistory
    {
        [Key]
        public int AnimalViewHistoryId { get; set; }

        public int UserId { get; set; }

        [ForeignKey(nameof(UserId))]
        public User User { get; set; } = null!;

        public int AnimalId { get; set; }

        [ForeignKey(nameof(AnimalId))]
        public Animal Animal { get; set; } = null!;

        public DateTime ViewedAt { get; set; }
    }
}