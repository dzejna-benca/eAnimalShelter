using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eAnimalShelter.Services.Database
{
    public class Announcement
    {
        [Key]
        public int AnnouncementId { get; set; }
        [Required]
        [MaxLength(200)]
        public string Title { get; set; } = string.Empty;
        [Required]
        public string Content { get; set; } = string.Empty;
        public string? ImageUrl { get; set; }
        public DateTime PublishedDate { get; set; }
            = DateTime.UtcNow;
        public bool IsActive { get; set; } = true;
        public int CreatedBy { get; set; }
        [ForeignKey("CreatedBy")]
        public User CreatedByUser { get; set; } = null!;
    }
}