using PdfSharpCore.Drawing;
using PdfSharpCore.Pdf;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using Microsoft.AspNetCore.Hosting;
using PdfSharpCore.Pdf.Filters;

namespace eAnimalShelter.Services
{
    public class PdfService : IPdfService
    {
        private readonly IWebHostEnvironment _env;

        public PdfService(IWebHostEnvironment environment)
        {
            _env = environment;
        }

        public async Task<string> GenerateDonationReceiptAsync(Donation donation)
        {
            var receiptsFolder = Path.Combine(
            _env.WebRootPath,
            "receipts",
            "donations");

            if (!Directory.Exists(receiptsFolder))
                Directory.CreateDirectory(receiptsFolder);

            var fileName =
                $"donation_{donation.DonationId}.pdf";

            var filePath =
                Path.Combine(receiptsFolder, fileName);

            var document = new PdfDocument();

            var page = document.AddPage();

            var graphics = XGraphics.FromPdfPage(page);

            var titleFont =
                new XFont("Arial", 20, XFontStyle.Bold);

            var font =
                new XFont("Arial", 12);

            double y = 50;

            graphics.DrawString(
                "Donation Receipt",
                titleFont,
                XBrushes.Black,
                new XPoint(50, y));

            y += 40;

            graphics.DrawString(
                $"Receipt #: {donation.DonationId}",
                font,
                XBrushes.Black,
                new XPoint(50, y));

            y += 25;

            graphics.DrawString(
                $"Date: {donation.DonationDate:dd.MM.yyyy HH:mm}",
                font,
                XBrushes.Black,
                new XPoint(50, y));

            y += 25;

            graphics.DrawString(
                $"Amount: {donation.Amount:F2} €",
                font,
                XBrushes.Black,
                new XPoint(50, y));

            y += 25;

            graphics.DrawString(
                $"Payment: Stripe",
                font,
                XBrushes.Black,
                new XPoint(50, y));

            y += 25;

            graphics.DrawString(
                $"Status: Successful",
                font,
                XBrushes.Black,
                new XPoint(50, y));

            if (!string.IsNullOrWhiteSpace(donation.Note))
            {
                y += 35;

                graphics.DrawString(
                    "Note:",
                    font,
                    XBrushes.Black,
                    new XPoint(50, y));

                y += 20;

                graphics.DrawString(
                    donation.Note,
                    font,
                    XBrushes.Black,
                    new XRect(50, y, 450, 200),
                    XStringFormats.TopLeft);
            }

            document.Save(filePath);

            return "/receipts/donations/" + fileName;
        }
    }
}