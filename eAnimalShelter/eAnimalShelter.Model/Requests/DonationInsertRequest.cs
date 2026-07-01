namespace eAnimalShelter.Model.Requests
{
    public class DonationInsertRequest
{
    public decimal Amount { get; set; }

    public string PaymentMethod { get; set; } = "Credit Card";

    public string? Note { get; set; }

    public bool GenerateReceiptPdf { get; set; }
}
}
