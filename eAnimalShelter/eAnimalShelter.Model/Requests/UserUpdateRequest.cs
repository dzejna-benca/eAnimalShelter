namespace eAnimalShelter.Model.Requests
{
    public class UserUpdateRequest
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;

        public string? PhoneNumber { get; set; }
        public string? Address { get; set; }

        public bool IsActive { get; set; }
        public int RoleId { get; set; }
    }
}