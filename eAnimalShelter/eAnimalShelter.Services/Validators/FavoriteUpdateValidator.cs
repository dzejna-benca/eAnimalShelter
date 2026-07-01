using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class FavoriteUpdateValidator
        : AbstractValidator<FavoriteUpdateRequest>
    {
        public FavoriteUpdateValidator()
        {
            RuleFor(x => x.AnimalId)
                .GreaterThan(0)
                .WithMessage("AnimalId is required and must be greater than 0.");
        }
    }
}
