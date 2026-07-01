using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Services.Database
{
    public class Donation
    {
        [Key]
        public int DonationId { get; set; }
        public int UserId { get; set; }
         [ForeignKey("UserId")]
        public User User { get; set; } = null!;
        public decimal Amount { get; set; }
        public DateTime? DonationDate { get; set; }
        public string PaymentMethod { get; set; } = string.Empty;
        public string? StripePaymentIntentId { get; set; }
        public DonationStatus TransactionStatus { get; set; }
        public string? Note { get; set; }
        public string? ReceiptPdfPath { get; set; }
    }

    
}