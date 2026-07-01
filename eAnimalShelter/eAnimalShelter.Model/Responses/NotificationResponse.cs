using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Responses
{
    public class NotificationResponse
    {
        public int NotificationId { get; set; }

        public int? UserId { get; set; }

        public string? UserName { get; set; }

        public int? TargetRoleId { get; set; }

        public string? TargetRoleName { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;

        public NotificationType Type { get; set; }

        public bool IsRead { get; set; }

        public DateTime DateSent { get; set; }

        public DateTime? ReadAt { get; set; }
    }
}
