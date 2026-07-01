using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;


namespace eAnimalShelter.Services.AdoptionRequestStateMachine
{
    public class PendingAdoptionRequestState
    : BaseAdoptionRequestState
{
        public PendingAdoptionRequestState(eAnimalShelterDbContext dbContext, IMapper mapper, IServiceProvider serviceProvider) : base(dbContext, mapper, serviceProvider)
        {
        }

        public override List<string> AllowedActions()
        {
            return new()
            {
                nameof(ApproveAsync),
                nameof(RejectAsync),
                nameof(CancelAsync)
            };
        }
        public override async Task<AdoptionRequestResponse>
            ApproveAsync(int id)
        {
            var entity = await DbContext.AdoptionRequests
                .FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption request with id {id} not found.");
            }

            entity.Status = AdoptionRequestStatus.Approved;
            await CreateNotification(
                entity.UserId,
                "Adoption request approved",
                "Congratulations! Your adoption request has been approved."
            );

            var animal = await DbContext.Animals
                .FirstOrDefaultAsync(x => x.AnimalId == entity.AnimalId);

            if (animal != null)
            {
                animal.AdoptionStatus = AnimalStatus.Adopted;
            }

            var otherRequests = await DbContext.AdoptionRequests
                .Where(x =>
                    x.AnimalId == entity.AnimalId &&
                    x.AdoptionRequestId != entity.AdoptionRequestId &&
                    x.Status == AdoptionRequestStatus.Pending)
                .ToListAsync();

            foreach (var requestToReject in otherRequests)
            {
                requestToReject.Status = AdoptionRequestStatus.Rejected;

                requestToReject.AdminComment =
                    "Animal has already been adopted.";
                await CreateNotification(
                    requestToReject.UserId,
                    "Adoption request rejected",
                    "Unfortunately, another applicant has already adopted this animal."
                );
            }

            await DbContext.SaveChangesAsync();

            return Mapper.Map<AdoptionRequestResponse>(entity);
        }
        public override async Task<AdoptionRequestResponse>
    RejectAsync(int id)
    {
        var entity = await DbContext.AdoptionRequests
            .FindAsync(id);

        if (entity == null)
        {
            throw new KeyNotFoundException(
                $"Adoption request with id {id} not found.");
        }

        entity.Status = AdoptionRequestStatus.Rejected;
        await CreateNotification(
            entity.UserId,
            "Adoption request rejected",
            entity.AdminComment ??
                "Unfortunately, your adoption request has been rejected."
        );

        if (string.IsNullOrWhiteSpace(entity.AdminComment))
        {
            entity.AdminComment =
                "Your adoption request has been rejected.";
    
        }

        await DbContext.SaveChangesAsync();

        return Mapper.Map<AdoptionRequestResponse>(entity);
    }
       public override async Task<AdoptionRequestResponse>
        CancelAsync(int id)
    {
        var entity = await DbContext.AdoptionRequests
            .FindAsync(id);

        if (entity == null)
        {
            throw new KeyNotFoundException(
                $"Adoption request with id {id} not found.");
        }

        entity.Status = AdoptionRequestStatus.Cancelled;

        await DbContext.SaveChangesAsync();

        return Mapper.Map<AdoptionRequestResponse>(entity);
    }
    }
}