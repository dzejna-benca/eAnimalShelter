using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class update_seed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "VolunteerActivities",
                columns: new[] { "ActivityId", "CreatedBy", "Description", "EndDateTime", "LocationId", "MaxVolunteers", "StartDateTime", "Status", "Title" },
                values: new object[,]
                {
                    { 6, 1, "Helping care for cats.", new DateTime(2026, 1, 18, 13, 0, 0, 0, DateTimeKind.Unspecified), 3, 8, new DateTime(2026, 1, 18, 9, 0, 0, 0, DateTimeKind.Unspecified), 1, "Cat Care Day" },
                    { 7, 1, "Playing with puppies.", new DateTime(2026, 3, 20, 14, 0, 0, 0, DateTimeKind.Unspecified), 5, 10, new DateTime(2026, 3, 20, 9, 0, 0, 0, DateTimeKind.Unspecified), 1, "Puppy Socialization" }
                });

            migrationBuilder.InsertData(
                table: "VolunteerAssignments",
                columns: new[] { "AssignmentId", "ActivityId", "AdminResponseReason", "ApplicationNote", "AppliedAt", "HoursWorked", "Status", "UserId" },
                values: new object[,]
                {
                    { 9, 6, "Completed successfully.", "Happy to help.", new DateTime(2026, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 5m, 4, 4 },
                    { 10, 7, "Completed successfully.", "Love puppies.", new DateTime(2026, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 6m, 4, 4 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 7);
        }
    }
}
