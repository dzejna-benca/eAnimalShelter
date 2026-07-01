using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.Requests
{
    public class NotificationUpdateRequest
    {
        public int? UserId { get; set; }

        public int? TargetRoleId { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;

        public NotificationType Type { get; set; }

        public bool IsRead { get; set; }
    }
}
