using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Model.SearchObjects
{
    public class DonationSearchObject : BaseSearchObject
    {
        public string? UserFullName { get; set; }
        public int? UserId { get; set; }

        public DonationStatus? TransactionStatus { get; set; }

        public DateTime? FromDate { get; set; }

        public DateTime? ToDate { get; set; }

        public decimal? MinAmount { get; set; }

        public decimal? MaxAmount { get; set; }
    }
}
