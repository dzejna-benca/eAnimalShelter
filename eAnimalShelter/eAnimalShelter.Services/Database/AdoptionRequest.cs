using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Services.Database
{
    public class AdoptionRequest
    {
        [Key]
        public int AdoptionRequestId { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; } = null!;
        public int AnimalId { get; set; }
        [ForeignKey("AnimalId")]
        public Animal Animal { get; set; } = null!;

        public DateTime RequestDate { get; set; }
        
        public string HousingType { get; set; } = string.Empty;

        public string ExperienceWithPets { get; set; } = string.Empty;

        public int HouseholdMembers { get; set; }

        public string? AdditionalNotes { get; set; }

        public AdoptionRequestStatus Status { get; set; }
            = AdoptionRequestStatus.Pending;
        public int? ReviewedBy { get; set; }
        [ForeignKey("ReviewedBy")]
        public User? Reviewer { get; set; }
        public DateTime? ReviewDate { get; set; }
        public string? AdminComment { get; set; }
    }

}