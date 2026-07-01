using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.SearchObjects
{
    public class NotificationSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }

        public int? TargetRoleId { get; set; }

        public NotificationType? Type { get; set; }

        public bool? IsRead { get; set; }

        public DateTime? DateSentFrom { get; set; }

        public DateTime? DateSentTo { get; set; }
        public string? FTS { get; set; }
    }
}
