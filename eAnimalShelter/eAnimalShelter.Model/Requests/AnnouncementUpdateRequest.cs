namespace eAnimalShelter.Model.Requests
{
    public class AnnouncementUpdateRequest
    {
        public string Title { get; set; } = string.Empty;

        public string Content { get; set; } = string.Empty;

        public string? ImageUrl { get; set; }

        public bool IsActive { get; set; }
    }
}
