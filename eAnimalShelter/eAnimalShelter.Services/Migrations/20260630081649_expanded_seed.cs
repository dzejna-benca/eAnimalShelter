using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class expanded_seed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ProfileImageBase64",
                table: "Users");

            migrationBuilder.InsertData(
                table: "AnimalViewHistories",
                columns: new[] { "AnimalViewHistoryId", "AnimalId", "UserId", "ViewedAt" },
                values: new object[,]
                {
                    { 1, 1, 8, new DateTime(2026, 6, 20, 10, 15, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 2, 8, new DateTime(2026, 6, 20, 10, 20, 0, 0, DateTimeKind.Unspecified) },
                    { 3, 4, 8, new DateTime(2026, 6, 21, 9, 30, 0, 0, DateTimeKind.Unspecified) },
                    { 4, 5, 8, new DateTime(2026, 6, 21, 9, 35, 0, 0, DateTimeKind.Unspecified) },
                    { 5, 6, 8, new DateTime(2026, 6, 22, 14, 10, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "VolunteerActivities",
                columns: new[] { "ActivityId", "CreatedBy", "Description", "EndDateTime", "LocationId", "MaxVolunteers", "StartDateTime", "Status", "Title" },
                values: new object[,]
                {
                    { 8, 1, "Morning walk with shelter dogs during the summer season.", new DateTime(2026, 7, 24, 12, 0, 0, 0, DateTimeKind.Unspecified), 7, 8, new DateTime(2026, 7, 24, 8, 0, 0, 0, DateTimeKind.Unspecified), 0, "Summer Dog Walking" },
                    { 9, 2, "Preparing toys and enrichment activities for shelter animals.", new DateTime(2026, 7, 30, 15, 0, 0, 0, DateTimeKind.Unspecified), 3, 10, new DateTime(2026, 7, 30, 10, 0, 0, 0, DateTimeKind.Unspecified), 0, "Animal Enrichment Workshop" }
                });

            migrationBuilder.InsertData(
                table: "VolunteerAssignments",
                columns: new[] { "AssignmentId", "ActivityId", "AdminResponseReason", "ApplicationNote", "AppliedAt", "HoursWorked", "Status", "UserId" },
                values: new object[,]
                {
                    { 11, 8, null, "Available during summer break.", new DateTime(2026, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 0m, 0, 4 },
                    { 12, 9, "Application approved.", "I'd like to help with enrichment activities.", new DateTime(2026, 7, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 0m, 1, 6 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AnimalViewHistories",
                keyColumn: "AnimalViewHistoryId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "AnimalViewHistories",
                keyColumn: "AnimalViewHistoryId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "AnimalViewHistories",
                keyColumn: "AnimalViewHistoryId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "AnimalViewHistories",
                keyColumn: "AnimalViewHistoryId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "AnimalViewHistories",
                keyColumn: "AnimalViewHistoryId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 9);

            migrationBuilder.AddColumn<string>(
                name: "ProfileImageBase64",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 1,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 2,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 3,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 4,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 5,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 6,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 7,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 8,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 9,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 10,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 11,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 12,
                column: "ProfileImageBase64",
                value: null);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "UserId",
                keyValue: 13,
                column: "ProfileImageBase64",
                value: null);
        }
    }
}
