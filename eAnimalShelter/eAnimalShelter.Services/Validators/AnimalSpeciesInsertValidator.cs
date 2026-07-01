using eAnimalShelter.Model.Requests;
using eAnimalShelter.Services.Database;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnimalSpeciesInsertValidator
        : AbstractValidator<AnimalSpeciesInsertRequest>
    {
        public AnimalSpeciesInsertValidator()
        {
            RuleFor(x => x.SpeciesName)
                .NotEmpty()
                .WithMessage("Species name is required.")
                .MinimumLength(2)
                .MaximumLength(50);

        }
    }
}
