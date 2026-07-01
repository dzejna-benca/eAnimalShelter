using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Services.AccessManager;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [Authorize]
    public class DonationController : BaseCRUDController<
        DonationResponse,
        DonationSearchObject,
        DonationInsertRequest,
        DonationUpdateRequest,
        IDonationService>
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;

        public DonationController(IDonationService service, IAuthenticatedUserAccessor authenticatedUserAccessor)
            : base(service)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
        }

        [HttpGet]
        public override async Task<PageResult<DonationResponse>> Get(
            [FromQuery] DonationSearchObject search)
        {
            bool isAdmin = User.IsInRole("Admin");

            if (!isAdmin)
            {
                var userId = _authenticatedUserAccessor.GetUserId()
                    ?? throw new UnauthorizedAccessException(
                        "Authenticated user not found.");

                search.UserId = userId;
            }

            return await _service.GetAllAsync(search);
        }

        [HttpGet("{id}")]
        public override async Task<ActionResult<DonationResponse>> GetById(int id)
        {
            try
            {
                var donation = await _service.GetByIdAsync(id);

                bool isAdmin = User.IsInRole("Admin");

                if (!isAdmin)
                {
                    var userId = _authenticatedUserAccessor.GetUserId()
                        ?? throw new UnauthorizedAccessException(
                            "Authenticated user not found.");

                    if (donation.UserId != userId)
                    {
                        return Forbid();
                    }
                }

                return Ok(donation);
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
        }

        [Authorize(Roles = "Admin")]
        public override async Task<DonationResponse> Update(
            int id,
            [FromBody] DonationUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("report")]
        public async Task<ActionResult<DonationReportResponse>> GetReport()
        {
            return Ok(await _service.GetReportAsync());
        }
        [HttpPost("create-payment-intent")]
        public async Task<ActionResult<CreatePaymentIntentResponse>>
            CreatePaymentIntent(
                CreatePaymentIntentRequest request)
        {
            return Ok(await _service.CreatePaymentIntentAsync(request));
        }
        [HttpGet("{id}/receipt")]
        public async Task<IActionResult> GetReceipt(int id)
        {
            try
            {
                var result = await _service.GetReceiptAsync(id);

                return File(
                    result.Content,
                    "application/pdf",
                    result.FileName);
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
            catch (FileNotFoundException)
            {
                return NotFound();
            }
            catch (UnauthorizedAccessException)
            {
                return Forbid();
            }
        }
        [HttpPost("{id}/confirm-payment")]
        public async Task<IActionResult> ConfirmPayment(int id)
        {
            try
            {
                await _service.ConfirmPaymentAsync(id);
                return Ok();
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
            catch (UnauthorizedAccessException)
            {
                return Forbid();
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    message = ex.Message
                });
            }
        }
     }
}
