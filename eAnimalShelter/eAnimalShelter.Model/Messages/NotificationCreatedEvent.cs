namespace eAnimalShelter.Model.Messages
{
    public class NotificationCreatedEvent
    {
        public int? UserId { get; set; }

        public int? TargetRoleId { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;
    }
}