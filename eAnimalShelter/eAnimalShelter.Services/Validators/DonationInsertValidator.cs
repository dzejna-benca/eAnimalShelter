using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class DonationInsertValidator
        : AbstractValidator<DonationInsertRequest>
    {
        public DonationInsertValidator()
        {
            RuleFor(x => x.Amount)
                .NotEmpty()
                .WithMessage("Amount is required.")
                .GreaterThan(0)
                .WithMessage("Amount must be greater than 0.");

            RuleFor(x => x.PaymentMethod)
                .NotEmpty()
                .WithMessage("Payment method is required.")
                .MinimumLength(3)
                .MaximumLength(50)
                .WithMessage("Payment method must be between 3 and 50 characters.");

            RuleFor(x => x.Note)
                .MaximumLength(500)
                .WithMessage("Note must not exceed 500 characters.")
                .When(x => !string.IsNullOrEmpty(x.Note));

        }
    }
}
