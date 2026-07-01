using eAnimalShelter.Model.Exceptions;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class ProfileController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;

        public ProfileController(
            IUserService userService,
            IAuthenticatedUserAccessor authenticatedUserAccessor)
        {
            _userService = userService;
            _authenticatedUserAccessor = authenticatedUserAccessor;
        }

        [HttpGet]
        public async Task<ActionResult<UserResponse>> GetProfile()
        {
            var userId = _authenticatedUserAccessor.GetUserId();

            if (!userId.HasValue)
                return Unauthorized();

            var user = await _userService.GetWithRoleByIdAsync(userId.Value);

            if (user == null)
                return NotFound();

            return Ok(user);
        }

        [HttpPut]
        public async Task<ActionResult<UserResponse>> UpdateProfile(
            [FromBody] UserUpdateRequest request)
        {
            var userId = _authenticatedUserAccessor.GetUserId();

            if (!userId.HasValue)
            {
                throw new ClientException("User is not authenticated.");
            }

            var result = await _userService.UpdateAsync(
                userId.Value,
                request);

            return Ok(result);
        }
        [HttpPut("ChangePassword")]
        public async Task<IActionResult> ChangePassword(
            [FromBody] UserPasswordChangeRequest request)
        {
            var userId = _authenticatedUserAccessor.GetUserId();

            if (!userId.HasValue)
            {
                return Unauthorized();
            }

            await _userService.ChangePasswordAsync(
                userId.Value,
                request);

            return Ok();
        }
    }
}