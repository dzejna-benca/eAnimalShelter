using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Enums;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class DonationUpdateValidator
        : AbstractValidator<DonationUpdateRequest>
    {
        public DonationUpdateValidator()
        {
            RuleFor(x => x.Amount)
                .NotEmpty()
                .WithMessage("Amount is required.")
                .GreaterThan(0)
                .WithMessage("Amount must be greater than 0.");

            RuleFor(x => x.DonationDate)
                .NotEmpty()
                .WithMessage("Donation date is required.")
                .LessThanOrEqualTo(DateTime.UtcNow)
                .WithMessage("Donation date cannot be in the future.");

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

            RuleFor(x => x.ReceiptPdfPath)
                .Must(url => string.IsNullOrEmpty(url) || Uri.IsWellFormedUriString(url, UriKind.Absolute))
                .WithMessage("Receipt PDF path must be a valid URL.")
                .When(x => !string.IsNullOrEmpty(x.ReceiptPdfPath));

            ;
        }
    }
}
