using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class RoleUpdateValidator
        : AbstractValidator<RoleUpdateRequest>
    {
        public RoleUpdateValidator()
        {
            RuleFor(x => x.Name)
                .NotEmpty()
                .WithMessage("Name is required.")
                .MinimumLength(2)
                .MaximumLength(50)
                .WithMessage("Name must be between 2 and 50 characters.");

            RuleFor(x => x.Description)
                .NotEmpty()
                .WithMessage("Description is required.")
                .MinimumLength(5)
                .MaximumLength(200)
                .WithMessage("Description must be between 5 and 200 characters.");

            RuleFor(x => x.IsActive)
                .NotNull()
                .WithMessage("IsActive is required.");
        }
    }
}
