namespace eAnimalShelter.Model.Responses{

public class DonationReportResponse
{
    public decimal TotalDonations { get; set; }

    public decimal AverageDonation { get; set; }

    public string? TopDonor { get; set; }

    public Dictionary<string, decimal> DonationsByMonth { get; set; }
        = new();
}
}