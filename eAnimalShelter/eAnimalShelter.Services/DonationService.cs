using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Stripe;
using System.IO;

namespace eAnimalShelter.Services
{
    public class DonationService : BaseCRUDService<
        Donation,
        DonationResponse,
        DonationSearchObject,
        DonationInsertRequest,
        DonationUpdateRequest>,
        IDonationService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;
        private readonly IConfiguration _configuration;
        private readonly IWebHostEnvironment _env;
        private readonly IPdfService _pdfService;

        public DonationService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<DonationInsertRequest> insertValidator,
            IValidator<DonationUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor,
            IConfiguration configuration,
            IWebHostEnvironment env,
            IPdfService pdfService)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
            _configuration = configuration;
            _env = env;
            _pdfService = pdfService;
        }

        protected override IQueryable<Donation> ApplyFilters(
            IQueryable<Donation> query,
            DonationSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.UserFullName))
            {
                var searchTerm = search.UserFullName.ToLower();

                query = query.Where(x =>
                    (x.User.FirstName + " " + x.User.LastName)
                        .ToLower()
                        .Contains(searchTerm));
            }
            if (search?.UserId.HasValue == true)
            {
                query = query.Where(x =>
                    x.UserId == search.UserId.Value);
            }

            if (search?.TransactionStatus.HasValue == true)
            {
                query = query.Where(x =>
                    x.TransactionStatus == search.TransactionStatus.Value);
            }

            if (search?.FromDate.HasValue == true)
            {
                query = query.Where(x =>
                    x.DonationDate >= search.FromDate.Value);
            }

            if (search?.ToDate.HasValue == true)
            {
                query = query.Where(x =>
                    x.DonationDate <= search.ToDate.Value);
            }

            if (search?.MinAmount.HasValue == true)
            {
                query = query.Where(x =>
                    x.Amount >= search.MinAmount.Value);
            }

            if (search?.MaxAmount.HasValue == true)
            {
                query = query.Where(x =>
                    x.Amount <= search.MaxAmount.Value);
            }

            return query;
        }
        protected override IQueryable<Donation> ApplySorting(
            IQueryable<Donation> query,
            DonationSearchObject search)
        {
            switch (search.SortBy)
            {
                case "date_desc":
                    return query.OrderByDescending(x => x.DonationDate);

                case "date_asc":
                    return query.OrderBy(x => x.DonationDate);

                case "amount_desc":
                    return query.OrderByDescending(x => x.Amount);

                case "amount_asc":
                    return query.OrderBy(x => x.Amount);

                default:
                    return query.OrderByDescending(x => x.DonationDate);
            }
        }

        protected override IQueryable<Donation> Include(
            IQueryable<Donation> query,
            DonationSearchObject? search)
        {
            return query.Include(x => x.User);
        }

        public override async Task<DonationResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<Donation>()
                .Include(x => x.User)
                .FirstOrDefaultAsync(x => x.DonationId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Donation with id {id} not found.");
            }

            return _mapper.Map<DonationResponse>(entity);
        }

        public override async Task<DonationResponse> InsertAsync(
            DonationInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<Donation>(request);

            entity.UserId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            entity.TransactionStatus = DonationStatus.Pending;

            entity.DonationDate = null;

            entity.StripePaymentIntentId = null;

            _dbContext.Set<Donation>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<DonationResponse>(entity);
        }

        public override async Task<DonationResponse> UpdateAsync(
            int id,
            DonationUpdateRequest request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            var entity = await _dbContext.Set<Donation>()
                .FirstOrDefaultAsync(x => x.DonationId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Donation with id {id} not found.");
            }

            _mapper.Map(request, entity);

            _dbContext.Set<Donation>().Update(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<DonationResponse>(entity);
        }
        public async Task<DonationReportResponse> GetReportAsync()
        {
            var successfulDonations = await _dbContext.Donations
                .Include(x => x.User)
                .Where(x => x.TransactionStatus == DonationStatus.Successful)
                .ToListAsync();

            var report = new DonationReportResponse();

            report.TotalDonations = successfulDonations.Sum(x => x.Amount);

            report.AverageDonation = successfulDonations.Any()
                ? successfulDonations.Average(x => x.Amount)
                : 0;

            var topDonor = successfulDonations
                .GroupBy(x => new
                {
                    x.UserId,
                    x.User.FirstName,
                    x.User.LastName
                })
                .Select(x => new
                {
                    FullName = x.Key.FirstName + " " + x.Key.LastName,
                    TotalAmount = x.Sum(d => d.Amount)
                })
                .OrderByDescending(x => x.TotalAmount)
                .FirstOrDefault();

            report.TopDonor = topDonor == null
                ? "N/A"
                : $"{topDonor.FullName} - {topDonor.TotalAmount} €";

           report.DonationsByMonth = successfulDonations
            .Where(x => x.DonationDate != null)
            .GroupBy(x => x.DonationDate!.Value.ToString("MMM"))
            .ToDictionary(
                g => g.Key,
                g => g.Sum(x => x.Amount));

            return report;
        }
        public async Task<CreatePaymentIntentResponse> CreatePaymentIntentAsync(
            CreatePaymentIntentRequest request)
        {
            Stripe.StripeConfiguration.ApiKey =
                _configuration["Stripe:SecretKey"];

            var paymentIntentService =
                new Stripe.PaymentIntentService();

            var options = new Stripe.PaymentIntentCreateOptions
            {
                Amount = (long)(request.Amount * 100),
                Currency = "eur",
                AutomaticPaymentMethods =
                    new Stripe.PaymentIntentAutomaticPaymentMethodsOptions
                    {
                        Enabled = true
                    }
            };

            var paymentIntent =
                await paymentIntentService.CreateAsync(options);

            var donation = new Donation
            {
                UserId = _authenticatedUserAccessor.GetUserId()
                    ?? throw new UnauthorizedAccessException(),

                Amount = request.Amount,

                Note = request.Note,

                PaymentMethod = "Credit Card",

                TransactionStatus = DonationStatus.Pending,

                StripePaymentIntentId = paymentIntent.Id
            };

            _dbContext.Donations.Add(donation);

            await _dbContext.SaveChangesAsync();

            return new CreatePaymentIntentResponse
            {
                ClientSecret = paymentIntent.ClientSecret,

                DonationId = donation.DonationId,

                PaymentIntentId = paymentIntent.Id
            };
        }
        public async Task<(byte[] Content, string FileName)> GetReceiptAsync(int donationId)
        {
            var donation = await _dbContext.Donations
                .FirstOrDefaultAsync(x => x.DonationId == donationId);

            if (donation == null)
                throw new KeyNotFoundException("Donation not found.");

            if (string.IsNullOrWhiteSpace(donation.ReceiptPdfPath))
                throw new FileNotFoundException("Receipt not found.");

            var userId = _authenticatedUserAccessor.GetUserId();

            if (!userId.HasValue)
                throw new UnauthorizedAccessException();

            var isAdmin = _authenticatedUserAccessor.IsInRole("Admin");

            if (!isAdmin && donation.UserId != userId.Value)
                throw new UnauthorizedAccessException();

            var relativePath = donation.ReceiptPdfPath.TrimStart('/');

            var fullPath = Path.Combine(
                _env.WebRootPath,
                relativePath.Replace('/', Path.DirectorySeparatorChar));

            if (!System.IO.File.Exists(fullPath))
                throw new FileNotFoundException();

            return (
                await System.IO.File.ReadAllBytesAsync(fullPath),
                Path.GetFileName(fullPath)
            );
        }
        public async Task ConfirmPaymentAsync(int donationId)
        {
            StripeConfiguration.ApiKey =
                _configuration["Stripe:SecretKey"];

            var donation = await _dbContext.Donations
                .FirstOrDefaultAsync(x => x.DonationId == donationId);

            if (donation == null)
                throw new KeyNotFoundException();

            var paymentIntentService = new PaymentIntentService();

            var paymentIntent = await paymentIntentService.GetAsync(
                donation.StripePaymentIntentId);

            if (paymentIntent.Status != "succeeded")
                throw new Exception("Payment has not been completed.");

            if (donation.TransactionStatus == DonationStatus.Successful)
                return;

            donation.TransactionStatus = DonationStatus.Successful;
            donation.DonationDate = DateTime.UtcNow;
            donation.PaymentMethod = "Credit Card";

            donation.ReceiptPdfPath =
                await _pdfService.GenerateDonationReceiptAsync(donation);

            await _dbContext.SaveChangesAsync();
        }
    }
}
