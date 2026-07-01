using eAnimalShelter.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class AnimalViewHistoryController : ControllerBase
    {
        private readonly IAnimalViewHistoryService _service;

        public AnimalViewHistoryController(
            IAnimalViewHistoryService service)
        {
            _service = service;
        }

        [HttpPost("{animalId}")]
        public async Task<IActionResult> AddView(int animalId)
        {
            await _service.AddViewAsync(animalId);

            return Ok();
        }
        [HttpPost("{animalId}/view")]
        public async Task<IActionResult> RecordView(int animalId)
        {
            await _service.RecordViewAsync(animalId);
            return Ok();
        }
    }
}