using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class NotificationUpdateValidator
        : AbstractValidator<NotificationUpdateRequest>
    {
        public NotificationUpdateValidator()
        {
            RuleFor(x => x)
                .Custom((request, context) =>
                {
                    if (!request.UserId.HasValue && !request.TargetRoleId.HasValue)
                    {
                        context.AddFailure("Either UserId or TargetRoleId must be provided.");
                    }
                });

            RuleFor(x => x.Title)
                .NotEmpty()
                .WithMessage("Title is required.")
                .MinimumLength(3)
                .MaximumLength(200)
                .WithMessage("Title must be between 3 and 200 characters.");

            RuleFor(x => x.Message)
                .NotEmpty()
                .WithMessage("Message is required.")
                .MinimumLength(5)
                .WithMessage("Message must be at least 5 characters.");

            RuleFor(x => x.Type)
                .IsInEnum()
                .WithMessage("Type must be a valid NotificationType.");
        }
    }
}
