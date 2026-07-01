using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Services.Database
{
    public class Notification
    {
        [Key]
        public int NotificationId { get; set; }
        public int? UserId { get; set; }
        [ForeignKey("UserId")]
        public User? User { get; set; }

        // ciljna rola (Client / Volunteer / Admin)
        public int? TargetRoleId { get; set; }
        [ForeignKey("TargetRoleId")]
        public Role? TargetRole { get; set; }

        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public NotificationType Type { get; set; }
        public bool IsRead { get; set; }
        public DateTime DateSent { get; set; }
        public DateTime? ReadAt { get; set; }
    }

    
}