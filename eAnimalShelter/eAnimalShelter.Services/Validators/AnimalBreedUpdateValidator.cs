using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnimalBreedUpdateValidator
        : AbstractValidator<AnimalBreedUpdateRequest>
    {
        public AnimalBreedUpdateValidator()
        {
            RuleFor(x => x.BreedName)
                .NotEmpty()
                .WithMessage("Breed name is required.")
                .MinimumLength(2)
                .MaximumLength(50);

            RuleFor(x => x.SpeciesId)
                .GreaterThan(0)
                .WithMessage("Species is required.");
        }
    }
}