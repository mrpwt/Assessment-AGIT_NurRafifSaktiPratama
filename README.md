# Assessment-AGIT_NurRafifSaktiPratama

Software Engineer Coding Assessment menggunakan C#, ASP.NET Core, Entity Framework Core, dan SQLite.

Project ini mengimplementasikan:

- Case 1 - Foundation: Understand and Balance
- Case 2 - Application and Persistence
- Case 3 - Database, Integrity, and Advanced Reasoning

---

## Teknologi

- C#
- .NET 10
- ASP.NET Core Web API
- Entity Framework Core
- SQLite
- Swagger / OpenAPI
- xUnit
- Git

---

# 1. Prasyarat

Sebelum menjalankan project, pastikan perangkat sudah memiliki:

- .NET SDK 10
- Git

Cek versi .NET:

```bash
dotnet --version

# How To start project
git clone https://github.com/mrpwt/Assessment-AGIT_NurRafifSaktiPratama.git
cd Assessment-AGIT_NurRafifSaktiPratama
dotnet restore
dotnet build
dotnet ef database update --project src/Assessment.Api --startup-project src/Assessment.Api
dotnet run --project src/Assessment.Api