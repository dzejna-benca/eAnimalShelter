using eAnimalShelter.Model.Access;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Services.AccessManager;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("[controller]")]
public class AccessController : ControllerBase
{
    private readonly IAccessManager _accessManager;
    private readonly IUserService _userService;

    public AccessController(
        IAccessManager accessManager,
        IUserService userService)
    {
        _accessManager = accessManager;
        _userService = userService;
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login(
        UserLoginRequest request)
    {
        var result =
            await _accessManager.LoginAsync(request);

        return Ok(result);
    }

    [HttpPost("LoginWithRefreshToken")]
    public async Task<IActionResult> LoginWithRefreshToken(
        RefreshAccessTokenRequest request)
    {
        var result =
            await _accessManager.LoginWithRefreshTokenAsync(request);

        return Ok(result);
    }

    [HttpPost("Register")]
    public async Task<IActionResult> Register(
        UserInsertRequest request)
    {
        await _userService.InsertAsync(request);

        return Ok();
    }
}