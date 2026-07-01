using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class added_animalViewHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AnimalViewHistories",
                columns: table => new
                {
                    AnimalViewHistoryId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    AnimalId = table.Column<int>(type: "int", nullable: false),
                    ViewedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalViewHistories", x => x.AnimalViewHistoryId);
                    table.ForeignKey(
                        name: "FK_AnimalViewHistories_Animals_AnimalId",
                        column: x => x.AnimalId,
                        principalTable: "Animals",
                        principalColumn: "AnimalId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AnimalViewHistories_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AnimalViewHistories_AnimalId",
                table: "AnimalViewHistories",
                column: "AnimalId");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalViewHistories_UserId",
                table: "AnimalViewHistories",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AnimalViewHistories");
        }
    }
}
