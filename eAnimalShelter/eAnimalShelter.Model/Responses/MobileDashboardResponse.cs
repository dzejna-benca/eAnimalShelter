namespace eAnimalShelter.Model.Responses
{
    public class MobileDashboardResponse
    {
        public int TotalVolunteerHours { get; set; }

        public int HoursThisMonth  { get; set; }

        public List<MonthlyVolunteerHoursResponse> MonthlyHours { get; set; }
            = new();

        public List<AnnouncementResponse> RecentNews { get; set; }
            = new();
    }

    public class MonthlyVolunteerHoursResponse
    {
        public string Month { get; set; } = "";

        public int Hours { get; set; }
    }
}