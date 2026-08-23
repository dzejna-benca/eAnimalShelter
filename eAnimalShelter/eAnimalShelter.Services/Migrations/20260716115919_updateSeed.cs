using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class updateSeed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 12,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { null, 4 });

            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 13,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { null, 9 });

            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 14,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { null, 8 });

            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 15,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { null, 10 });

            migrationBuilder.UpdateData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 8,
                columns: new[] { "EndDateTime", "StartDateTime" },
                values: new object[] { new DateTime(2026, 9, 24, 12, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 9, 24, 8, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 9,
                columns: new[] { "EndDateTime", "StartDateTime" },
                values: new object[] { new DateTime(2026, 9, 30, 15, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 9, 30, 10, 0, 0, 0, DateTimeKind.Unspecified) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 12,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { 2, null });

            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 13,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { 3, null });

            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 14,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { 3, null });

            migrationBuilder.UpdateData(
                table: "Notifications",
                keyColumn: "NotificationId",
                keyValue: 15,
                columns: new[] { "TargetRoleId", "UserId" },
                values: new object[] { 1, null });

            migrationBuilder.UpdateData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 8,
                columns: new[] { "EndDateTime", "StartDateTime" },
                values: new object[] { new DateTime(2026, 7, 24, 12, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 7, 24, 8, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "VolunteerActivities",
                keyColumn: "ActivityId",
                keyValue: 9,
                columns: new[] { "EndDateTime", "StartDateTime" },
                values: new object[] { new DateTime(2026, 7, 30, 15, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 7, 30, 10, 0, 0, 0, DateTimeKind.Unspecified) });
        }
    }
}
