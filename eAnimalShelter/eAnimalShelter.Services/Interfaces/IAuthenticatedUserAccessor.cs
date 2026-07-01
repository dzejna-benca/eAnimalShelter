namespace eAnimalShelter.Services.Interfaces
{
    public interface IAuthenticatedUserAccessor
    {
        int? GetUserId();

        bool IsInRole(string role);
    }
}