using eAnimalShelter.Model.Requests;
using eAnimalShelter.Services.Database;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class LocationUpdateValidator
        : AbstractValidator<LocationUpdateRequest>
    {
        public LocationUpdateValidator(eAnimalShelterDbContext db)
        {
            RuleFor(x => x.Name)
                .NotEmpty()
                .WithMessage("Name is required.")
                .MinimumLength(2)
                .MaximumLength(100)
                .WithMessage("Name must be between 2 and 100 characters.");

        }
    }
}
