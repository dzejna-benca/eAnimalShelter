namespace eAnimalShelter.Services.Database
{
    public class NotificationDeliveryLog
    {
        public int NotificationDeliveryLogId { get; set; }

        public int NotificationId { get; set; }

        public int? UserId { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;

        public DateTime DeliveredAt { get; set; }

        public bool Success { get; set; }
    }
}