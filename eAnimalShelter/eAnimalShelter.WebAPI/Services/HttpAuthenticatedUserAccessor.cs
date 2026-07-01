using System.Security.Claims;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Services.AccessManager;

namespace eAnimalShelter.WebAPI.Services
{
    public class HttpAuthenticatedUserAccessor : IAuthenticatedUserAccessor
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public HttpAuthenticatedUserAccessor(
            IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public int? GetUserId()
        {
            var user = _httpContextAccessor.HttpContext?.User;

            if (user?.Identity?.IsAuthenticated != true)
            {
                return null;
            }

            var id =
                user.FindFirstValue(ClaimNames.UserId)
                ?? user.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrWhiteSpace(id))
            {
                return null;
            }

            if (!int.TryParse(id, out int userId))
            {
                return null;
            }

            return userId;
        }

        public bool IsInRole(string role)
        {
            var user = _httpContextAccessor.HttpContext?.User;

            if (user?.Identity?.IsAuthenticated != true)
            {
                return false;
            }

            var userRole =
                user.FindFirstValue(ClaimNames.Role)
                ?? user.FindFirstValue(ClaimTypes.Role);

            return userRole == role;
        }
    }
}