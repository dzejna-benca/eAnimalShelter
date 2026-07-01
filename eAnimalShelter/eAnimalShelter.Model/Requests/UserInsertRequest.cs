using System.ComponentModel.DataAnnotations;

namespace eAnimalShelter.Model.Requests
{
    public class UserInsertRequest
{
    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Username { get; set; } = string.Empty;

    public string Password { get; set; } = string.Empty;

    public string? PhoneNumber { get; set; }

    public string Address { get; set; } = string.Empty;

    public bool IsActive { get; set; } = true;

    public int RoleId { get; set; } 
}
}
