using System.ComponentModel.DataAnnotations;

namespace eAnimalShelter.Services.Database

{
    public class Location
{
    [Key]
    public int LocationId { get; set; }

    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;
}
}
