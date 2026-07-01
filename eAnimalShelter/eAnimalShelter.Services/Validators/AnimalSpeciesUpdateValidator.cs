using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnimalSpeciesUpdateValidator
        : AbstractValidator<AnimalSpeciesUpdateRequest>
    {
        public AnimalSpeciesUpdateValidator()
        {
            RuleFor(x => x.SpeciesName)
                .NotEmpty()
                .WithMessage("Species name is required.")
                .MinimumLength(2)
                .MaximumLength(50);
        }
    }
}
