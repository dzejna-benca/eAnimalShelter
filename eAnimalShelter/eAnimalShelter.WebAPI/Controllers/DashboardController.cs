using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DashboardController
        : ControllerBase
    {
        private readonly IDashboardService
            _dashboardService;

        public DashboardController(
            IDashboardService dashboardService)
        {
            _dashboardService =
                dashboardService;
        }

        [HttpGet]
        public async Task<IActionResult>
            GetStats()
        {
            var result =
                await _dashboardService
                    .GetStatsAsync();

            return Ok(result);
        }
      
        [Authorize]
        [HttpGet("mobile")]
        public async Task<IActionResult> GetMobileDashboard()
        {
            var result = await _dashboardService.GetMobileDashboardAsync();
            return Ok(result);
        }
    }
}