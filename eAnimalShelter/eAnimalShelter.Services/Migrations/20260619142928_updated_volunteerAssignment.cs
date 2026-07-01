using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class updated_volunteerAssignment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "AdminResponseReason",
                table: "VolunteerAssignments",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 1,
                column: "AdminResponseReason",
                value: "Application approved. Previous volunteering experience and availability match activity requirements.");

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 2,
                column: "AdminResponseReason",
                value: "Approved due to full-day availability and positive application details.");

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 3,
                column: "AdminResponseReason",
                value: null);

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 4,
                column: "AdminResponseReason",
                value: "Approved because of prior event organization experience.");

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 5,
                column: "AdminResponseReason",
                value: "Application approved and activity successfully completed.");

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 6,
                column: "AdminResponseReason",
                value: "Approved due to availability and commitment. Activity completed successfully.");

            migrationBuilder.UpdateData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 7,
                column: "AdminResponseReason",
                value: "Volunteer cancelled participation before activity start date.");

            migrationBuilder.InsertData(
                table: "VolunteerAssignments",
                columns: new[] { "AssignmentId", "ActivityId", "AdminResponseReason", "ApplicationNote", "AppliedAt", "HoursWorked", "Status", "UserId" },
                values: new object[] { 8, 2, "Application rejected because all volunteer positions have already been filled.", "Would like to participate.", new DateTime(2026, 2, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), 0m, 2, 7 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "VolunteerAssignments",
                keyColumn: "AssignmentId",
                keyValue: 8);

            migrationBuilder.DropColumn(
                name: "AdminResponseReason",
                table: "VolunteerAssignments");
        }
    }
}
