using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services;
using eAnimalShelter.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers;

    [ApiController]
    [Route("[controller]")]
    public abstract class BaseCRUDController
        <TResponse, TSearch, TInsert, TUpdate, TService>
        : BaseReadController<TResponse, TSearch, TService>
        where TSearch : BaseSearchObject
        where TService : IBaseCRUDService<
            TResponse,
            TSearch,
            TInsert,
            TUpdate>
    {
        protected BaseCRUDController(TService service)
            : base(service)
        {
        }

        [HttpPost]
        public virtual async Task<TResponse> Insert(
            [FromBody] TInsert request)
        {
            return await _service.InsertAsync(request);
        }

        [HttpPut("{id}")]
        public virtual async Task<TResponse> Update(
            int id,
            [FromBody] TUpdate request)
        {
            return await _service.UpdateAsync(id, request);
        }

        [HttpDelete("{id}")]
        public virtual async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteAsync(id);

            return NoContent();
        }
    }
