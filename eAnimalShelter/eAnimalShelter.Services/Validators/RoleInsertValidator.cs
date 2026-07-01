using eAnimalShelter.Model.Requests;
using eAnimalShelter.Services.Database;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class RoleInsertValidator
        : AbstractValidator<RoleInsertRequest>
    {
        public RoleInsertValidator(eAnimalShelterDbContext db)
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

            RuleFor(x => x.Name)
            .Must((request, roleName) =>
                !db.Roles.Any(x =>
                    x.Name.ToLower().Trim() ==
                    roleName.ToLower().Trim()))
            .WithMessage("Role already exists.");
        }
    }
}
