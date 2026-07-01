using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class seed_updated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "AdoptionRequests",
                columns: new[] { "AdoptionRequestId", "AdditionalNotes", "AdminComment", "AnimalId", "ExperienceWithPets", "HouseholdMembers", "HousingType", "RequestDate", "ReviewDate", "ReviewedBy", "Status", "UserId" },
                values: new object[] { 10, null, null, 11, "Previously owned pets", 5, "House with garden", new DateTime(2026, 3, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, 1, 13 });

            migrationBuilder.UpdateData(
                table: "Animals",
                keyColumn: "AnimalId",
                keyValue: 11,
                column: "AdoptionStatus",
                value: 2);

            migrationBuilder.InsertData(
                table: "Donations",
                columns: new[] { "DonationId", "Amount", "DonationDate", "Note", "PaymentMethod", "ReceiptPdfPath", "TransactionId", "TransactionStatus", "UserId" },
                values: new object[] { 7, 50.00m, new DateTime(2026, 3, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "For feeding animals", "Credit Card", null, "DON-2026-007", 0, 10 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AdoptionRequests",
                keyColumn: "AdoptionRequestId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Donations",
                keyColumn: "DonationId",
                keyValue: 7);

            migrationBuilder.UpdateData(
                table: "Animals",
                keyColumn: "AnimalId",
                keyValue: 11,
                column: "AdoptionStatus",
                value: 0);
        }
    }
}
