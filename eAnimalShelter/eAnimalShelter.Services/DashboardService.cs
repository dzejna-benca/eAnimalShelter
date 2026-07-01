using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class DashboardService
        : IDashboardService
    {
        private readonly eAnimalShelterDbContext _context;
         private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;

        public DashboardService(
            eAnimalShelterDbContext context,
            IAuthenticatedUserAccessor authenticatedUserAccessor)
        {
            _context = context;
            _authenticatedUserAccessor = authenticatedUserAccessor;
        }

        public async Task<DashboardResponse>
            GetStatsAsync()
        {
            return new DashboardResponse
            {
                TotalAnimals =
                    await _context.Animals.CountAsync(),

                 ApprovedAdoptions =
                    await _context
                        .AdoptionRequests
                        .CountAsync(x =>
                            x.Status ==
                            Model.Enums
                            .AdoptionRequestStatus
                            .Approved),

                TotalVolunteers =
                    await _context.UserRoles
                        .Include(x => x.Role)
                        .CountAsync(x =>
                            x.Role.Name ==
                            "Volunteer"),

                TotalDonations =
                    await _context.Donations
                        .SumAsync(x =>
                            (decimal?)x.Amount)
                    ?? 0,

                AnimalsBySpecies = await _context.Animals
                    .Include(x => x.Species)
                    .GroupBy(x => x.Species.SpeciesName)
                    .ToDictionaryAsync(
                        x => x.Key,
                        x => x.Count()),
                        
                 AdoptedAnimalsBySpecies =
                    await _context.AdoptionRequests
                        .Include(x => x.Animal)
                        .ThenInclude(x => x.Species)
                        .Where(x =>
                            x.Status ==
                            AdoptionRequestStatus.Approved)
                        .GroupBy(x => x.Animal.Species.SpeciesName)
                        .ToDictionaryAsync(
                            x => x.Key,
                            x => x.Count())
                            };
               
        }
        public async Task<MobileDashboardResponse> GetMobileDashboardAsync()
        {
            var userId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException();

            var totalVolunteerHours = await _context.VolunteerAssignments
                .Where(x =>
                    x.UserId == userId &&
                    x.Status == AssignmentStatus.Completed)
                .SumAsync(x => (int?)x.HoursWorked) ?? 0;

            var now = DateTime.UtcNow;

            var monthStart = new DateTime(
                now.Year,
                now.Month,
                1);

            var monthEnd = monthStart.AddMonths(1);

            var hoursThisMonth = (int)(
                await _context.VolunteerAssignments
                    .Where(x =>
                        x.UserId == userId &&
                        x.Status == AssignmentStatus.Completed &&
                        x.Activity.EndDateTime >= monthStart &&
                        x.Activity.EndDateTime < monthEnd)
                    .SumAsync(x => (decimal?)x.HoursWorked)
                ?? 0);

            var monthlyHours = (await _context.VolunteerAssignments
                .Where(x =>
                    x.UserId == userId &&
                    x.Status == AssignmentStatus.Completed)
                .GroupBy(x => new
                {
                    x.Activity.EndDateTime.Year,
                    x.Activity.EndDateTime.Month
                })
                .Select(x => new
                {
                    x.Key.Year,
                    x.Key.Month,
                    Hours = x.Sum(a => a.HoursWorked)
                })
                .OrderBy(x => x.Year)
                .ThenBy(x => x.Month)
                .ToListAsync())
                .Select(x => new MonthlyVolunteerHoursResponse
                {
                    Month = new DateTime(
                        x.Year,
                        x.Month,
                        1).ToString("MMM"),
                    Hours = (int)x.Hours
                })
                .ToList();

            var recentNews = await _context.Announcements
                .Where(x => x.IsActive)
                .OrderByDescending(x => x.PublishedDate)
                .Take(3)
                .Select(x => new AnnouncementResponse
                {
                    AnnouncementId = x.AnnouncementId,
                    Title = x.Title,
                    Content = x.Content,
                    PublishedDate = x.PublishedDate,
                    ImageUrl = x.ImageUrl
                })
                .ToListAsync();

            return new MobileDashboardResponse
            {
                TotalVolunteerHours = totalVolunteerHours,
                HoursThisMonth = hoursThisMonth,
                MonthlyHours = monthlyHours,
                RecentNews = recentNews
            };
        }
    }
}