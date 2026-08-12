using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Assessment.Api.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Plannings",
                columns: table => new
                {
                    PlanningId = table.Column<long>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    RequestCode = table.Column<string>(type: "TEXT", nullable: false),
                    CandidateToken = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "TEXT", nullable: false),
                    Status = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Plannings", x => x.PlanningId);
                });

            migrationBuilder.CreateTable(
                name: "PlanningSlot",
                columns: table => new
                {
                    PlanningId = table.Column<long>(type: "INTEGER", nullable: false),
                    SlotOrder = table.Column<int>(type: "INTEGER", nullable: false),
                    SlotName = table.Column<string>(type: "TEXT", nullable: false),
                    OriginalQuantity = table.Column<long>(type: "INTEGER", nullable: false),
                    BalancedQuantity = table.Column<long>(type: "INTEGER", nullable: false),
                    IsActive = table.Column<bool>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PlanningSlot", x => new { x.PlanningId, x.SlotOrder });
                    table.CheckConstraint("CK_PlanningSlot_BalancedQuantity_NonNegative", "BalancedQuantity >= 0");
                    table.CheckConstraint("CK_PlanningSlot_OriginalQuantity_NonNegative", "OriginalQuantity >= 0");
                    table.ForeignKey(
                        name: "FK_PlanningSlot_Plannings_PlanningId",
                        column: x => x.PlanningId,
                        principalTable: "Plannings",
                        principalColumn: "PlanningId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Plannings_RequestCode",
                table: "Plannings",
                column: "RequestCode",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PlanningSlot");

            migrationBuilder.DropTable(
                name: "Plannings");
        }
    }
}
