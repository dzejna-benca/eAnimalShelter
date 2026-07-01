using eAnimalShelter.Common.Services.CryptoService;
using eAnimalShelter.Model.Access;
using eAnimalShelter.Model.Exceptions;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using static Azure.Core.HttpHeader;

namespace eAnimalShelter.WebAPI.Services.AccessManager
{
    public class AccessManager : IAccessManager
    {
        private readonly IUserService _userService;
        private readonly IConfiguration _configuration;
        private readonly ICryptoService _cryptoService;
        private readonly IRefreshTokenService _refreshTokenService;

        public AccessManager(IUserService userService, IConfiguration configuration, ICryptoService cryptoService, IRefreshTokenService refreshTokenService)
        {
            _userService = userService;
            _configuration = configuration;
            _cryptoService = cryptoService;
            _refreshTokenService = refreshTokenService;
        }

        public async Task<UserLoginResponse> LoginAsync(UserLoginRequest request)
        {
            var user = await _userService.GetByUsernameAsync(request.Username);


            if (user == null)
                {
                    throw new ClientException("Invalid username or password.");
                }

                var validPassword = _cryptoService.Verify(
                    user.PasswordHash,
                    user.PasswordSalt,
                    request.Password);

                if (!validPassword)
                {
                    throw new ClientException("Invalid username or password.");
                }

                if (!user.IsActive)
                {
                    throw new ClientException("Your account is inactive.");
                }

            var accessToken = GenerateToken(user);
            var refreshTokenValue = GenerateRefreshToken();

            var refreshToken = new RefreshToken
            {
                UserId = user.UserId,
                Token = refreshTokenValue,
                ExpiresAt = DateTime.UtcNow.AddDays(7)
            };

            await _refreshTokenService.InsertAsync(refreshToken);

            return new UserLoginResponse
            {
                AccessToken = accessToken,
                RefreshToken = refreshTokenValue,
                Role = user.Role ?? string.Empty,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber
            };
        }

        public async Task<UserLoginResponse> LoginWithRefreshTokenAsync(RefreshAccessTokenRequest request)
        {
            if (string.IsNullOrEmpty(request.RefreshToken))
            {
                throw new ClientException("Refresh token is required");
            }

            var refreshToken = await _refreshTokenService.GetStoredTokenAsync(request.RefreshToken);

            if (refreshToken == null)
            {
                throw new ClientException("Invalid refresh token");
            }

            if (refreshToken.ExpiresAt < DateTime.UtcNow)
            {
                throw new ClientException("Refresh token has expired");
            }

            var user = await _userService.GetWithRoleByIdAsync(refreshToken.UserId);

            if (user == null)
            {
                throw new ClientException("User not found");
            }

            if (!user.IsActive)
            {
                throw new ClientException("User is not active");
            }

            await _refreshTokenService.DeleteAllUserRefreshTokensAsync(user.UserId);

            var accessToken = GenerateToken(user);
            var refreshTokenValue = GenerateRefreshToken();

            var token = new RefreshToken
            {
                UserId = user.UserId,
                Token = refreshTokenValue,
                ExpiresAt = DateTime.UtcNow.AddDays(7)
            };

            await _refreshTokenService.InsertAsync(token);

            return new UserLoginResponse
            {
                AccessToken = accessToken,
                RefreshToken = refreshTokenValue,
                Role = user.Role ?? string.Empty,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber
            };

        }

        private string GenerateToken(UserResponse user)
        {
            string secretKeyString =
                Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? string.Empty;

            var issuer =
                Environment.GetEnvironmentVariable("JWT_ISSUER");

            var audience =
                Environment.GetEnvironmentVariable("JWT_AUDIENCE");

            var durationInMinutes = int.Parse(
                Environment.GetEnvironmentVariable("JWT_DURATION") ?? "60");

            var secretKey = Encoding.ASCII.GetBytes(secretKeyString);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(ClaimNames.UserId, user.UserId.ToString()),
                    new Claim(ClaimNames.FirstName, user.FirstName ?? string.Empty),
                    new Claim(ClaimNames.LastName, user.LastName ?? string.Empty),
                    new Claim(ClaimNames.Email, user.Email ?? string.Empty),
                    new Claim(ClaimTypes.Role, user.Role ?? "Client"),
                    new Claim(ClaimNames.IsActive, user.IsActive.ToString())
                }),
                Expires = DateTime.UtcNow.AddMinutes(durationInMinutes),
                Issuer = issuer,
                Audience = audience,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(secretKey), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        private static string GenerateRefreshToken()
        {
            var randombytes = RandomNumberGenerator.GetBytes(64);
            return Convert.ToBase64String(randombytes);
        }

       
    }
}
