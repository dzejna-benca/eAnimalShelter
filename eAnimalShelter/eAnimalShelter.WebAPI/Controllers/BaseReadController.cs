using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services;
using eAnimalShelter.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public abstract class BaseReadController
        <TResponse, TSearch, TService> : ControllerBase
        where TSearch : BaseSearchObject
        where TService : IBaseReadService<TResponse, TSearch>
    {
        protected readonly TService _service;

        protected BaseReadController(TService service)
        {
            _service = service;
        }

        [HttpGet]
        public virtual async Task<PageResult<TResponse>> Get(
            [FromQuery] TSearch search)
        {
            return await _service.GetAllAsync(search);
        }

        [HttpGet("{id}")]
        public virtual async Task<ActionResult<TResponse>> GetById(int id)
        {
            try
            {
                return Ok(await _service.GetByIdAsync(id));
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
        }
    }
}