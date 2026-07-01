using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using eAnimalShelter.Model.Enums;

namespace eAnimalShelter.Services.Database
{
    public class VolunteerAssignment
    {
        [Key]
        public int AssignmentId { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; }  = null!;
        public int ActivityId { get; set; }
        [ForeignKey("ActivityId")]
        public VolunteerActivity Activity { get; set; } = null!;
        public DateTime AppliedAt { get; set; }
        public string? ApplicationNote { get; set; }
        public AssignmentStatus Status { get; set; }
        public string? AdminResponseReason { get; set; }
        public decimal HoursWorked { get; set; }
    }


}