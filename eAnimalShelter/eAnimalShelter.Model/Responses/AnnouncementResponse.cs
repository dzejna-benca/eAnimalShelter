namespace eAnimalShelter.Model.Responses
{
    public class AnnouncementResponse
    {
        public int AnnouncementId { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Content { get; set; } = string.Empty;

        public string? ImageUrl { get; set; }

        public DateTime PublishedDate { get; set; }

        public bool IsActive { get; set; }

        public int CreatedBy { get; set; }

        public string? CreatedByUserName { get; set; }
    }
}
