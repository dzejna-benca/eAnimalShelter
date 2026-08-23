namespace eAnimalShelter.Model.Responses
{
    public class AdoptionReportResponse
    {
        public int TotalRequests { get; set; }

        public int PendingRequests { get; set; }

        public int ApprovedRequests { get; set; }

        public int RejectedRequests { get; set; }

        public int CancelledRequests { get; set; }

        public Dictionary<string, int> RequestsByMonth { get; set; }
            = new();
    }
}