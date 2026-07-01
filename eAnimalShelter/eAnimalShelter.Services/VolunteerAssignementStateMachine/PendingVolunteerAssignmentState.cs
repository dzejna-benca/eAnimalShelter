using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Exceptions;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services.VolunteerAssignmentStateMachine
{
    public class PendingVolunteerAssignmentState
        : BaseVolunteerAssignmentState
    {
        public PendingVolunteerAssignmentState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }


        public override async Task<VolunteerAssignmentResponse> ApproveAsync(
            int id,
            string? reason = null)
        {
            if (string.IsNullOrWhiteSpace(reason))
            {
                throw new Exception(
                    "Approval reason is required.");
            }

            var assignment = await DbContext.VolunteerAssignments
                .Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException();

            var approvedCount = await DbContext.VolunteerAssignments
                .CountAsync(x =>
                    x.ActivityId == assignment.ActivityId &&
                    x.Status == AssignmentStatus.Approved);

            if (approvedCount >= assignment.Activity.MaxVolunteers)
            {
                throw new ClientException(
                    "Maximum number of volunteers reached.");
            }

            assignment.Status = AssignmentStatus.Approved;

            assignment.AdminResponseReason = reason;

            DbContext.Notifications.Add(
                new Notification
                {
                    UserId = assignment.UserId,
                    Title = "Application Approved",
                    Message =
                        $"Your application for activity '{assignment.Activity.Title}' has been approved.\nReason: {reason}",
                    Type = NotificationType.Volunteer,
                    DateSent = DateTime.UtcNow,
                    IsRead = false
                });

            await DbContext.SaveChangesAsync();

            return Mapper.Map<VolunteerAssignmentResponse>(
                assignment);
        }

        public override async Task<VolunteerAssignmentResponse> RejectAsync(
            int id,
            string? reason = null)
        {
            if (string.IsNullOrWhiteSpace(reason))
            {
                throw new ClientException(
                    "Reason is required when rejecting application.");
            }

            var assignment = await DbContext.VolunteerAssignments
                .Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException();

            assignment.Status = AssignmentStatus.Rejected;
            assignment.AdminResponseReason = reason;

            DbContext.Notifications.Add(
                new Notification
                {
                    UserId = assignment.UserId,
                    Title = "Application Rejected",
                    Message =
                        $"Your application for activity '{assignment.Activity.Title}' was rejected.\nReason: {reason}",
                    Type = NotificationType.Volunteer,
                    DateSent = DateTime.UtcNow,
                    IsRead = false
                });

            await DbContext.SaveChangesAsync();

            return Mapper.Map<VolunteerAssignmentResponse>(assignment);
        }

        public override async Task<VolunteerAssignmentResponse> CancelAsync(int id)
        {
            var entity = await DbContext.VolunteerAssignments
                .Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (entity == null)
                throw new KeyNotFoundException();

            if (entity.Activity.StartDateTime <= DateTime.UtcNow.AddDays(2))
            {
                throw new ClientException(
                    "Applications cannot be cancelled less than 2 days before the activity starts.");
            }

            entity.Status = AssignmentStatus.Cancelled;
            entity.AdminResponseReason ="Cancelled by volunteer.";

            await DbContext.SaveChangesAsync();

            return Mapper.Map<VolunteerAssignmentResponse>(entity);
        }
    }
}