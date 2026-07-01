using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class AnimalViewHistoryService
        : IAnimalViewHistoryService
    {
        private readonly eAnimalShelterDbContext _dbContext;
        private readonly IAuthenticatedUserAccessor _userAccessor;

        public AnimalViewHistoryService(
            eAnimalShelterDbContext dbContext,
            IAuthenticatedUserAccessor userAccessor)
        {
            _dbContext = dbContext;
            _userAccessor = userAccessor;
        }

        public async Task AddViewAsync(int animalId)
        {
            var userId = _userAccessor.GetUserId();

            if (!userId.HasValue)
                return;

            _dbContext.AnimalViewHistories.Add(
                new AnimalViewHistory
                {
                    AnimalId = animalId,
                    UserId = userId.Value,
                    ViewedAt = DateTime.UtcNow
                });

            await _dbContext.SaveChangesAsync();
        }
        public async Task RecordViewAsync(int animalId)
        {
            var userId = _userAccessor.GetUserId();

            if (!userId.HasValue)
                return;

            var existing = await _dbContext.AnimalViewHistories
                .FirstOrDefaultAsync(x =>
                    x.UserId == userId &&
                    x.AnimalId == animalId);

            if (existing == null)
            {
                _dbContext.AnimalViewHistories.Add(new AnimalViewHistory
                {
                    UserId = userId.Value,
                    AnimalId = animalId,
                    ViewedAt = DateTime.UtcNow
                });
            }
            else
            {
                existing.ViewedAt = DateTime.UtcNow;
            }

            await _dbContext.SaveChangesAsync();
        }
    }
}