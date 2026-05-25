# StudyFlow

StudyFlow is a personal learning project built as a full-stack application.

The repository is organized as a monorepo:

```text
StudyFlow/
├── backend/
│   ├── StudyFlow.API/
│   ├── StudyFlow.Application/
│   ├── StudyFlow.Domain/
│   ├── StudyFlow.Infrastructure/
│   └── StudyFlow.API.slnx
├── frontend/
│   └── .gitkeep
├── .gitignore
└── README.md
```

The backend is already in progress. The frontend folder is reserved for the future Flutter application.

---

## English

### About

StudyFlow is a learning API built with ASP.NET Core Web API. The goal is to organize study content into subjects, topics, and study notes, and later extend the system with quizzes and review sessions.

This project is also my personal learning project for backend development with C#, ASP.NET Core, Entity Framework Core, PostgreSQL, dependency injection, repositories, services, DTOs, and layered architecture.

### Current Backend Features

- Create and read subjects
- Create and read topics
- Filter topics by subject
- Create and read study notes
- Filter study notes by topic
- PostgreSQL persistence with Entity Framework Core
- Layered architecture with API, Application, Domain, and Infrastructure projects

### Backend Architecture

```text
StudyFlow.API
-> Controllers and HTTP endpoints

StudyFlow.Application
-> Services, DTOs, validation, application logic

StudyFlow.Domain
-> Entities, enums, repository contracts

StudyFlow.Infrastructure
-> EF Core DbContext, repositories, migrations, PostgreSQL configuration
```

### Backend Flow

```text
HTTP Request
-> Controller
-> Service
-> Repository
-> DbContext
-> PostgreSQL
```

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Flutter planned for the frontend
- Clean Architecture inspired layering

### Local Backend Setup

The real database connection string is not committed to GitHub.
For local development, store it with ASP.NET Core User Secrets:

```powershell
cd backend
dotnet user-secrets set "ConnectionStrings:StudyFlowDb" "Host=localhost;Port=5432;Database=StudyFlowDb;Username=postgres;Password=YOUR_PASSWORD" --project StudyFlow.API\StudyFlow.API.csproj
```

Build the backend:

```powershell
cd backend
dotnet build StudyFlow.API.slnx
```

Run database migrations from the backend folder:

```powershell
cd backend
dotnet ef database update --project StudyFlow.Infrastructure --startup-project StudyFlow.API
```

---

## Deutsch

### Ueber das Projekt

StudyFlow ist eine Lern-API mit ASP.NET Core Web API. Das Ziel ist, Lerninhalte in Subjects, Topics und Study Notes zu organisieren und das System spaeter mit Quizzes und Review Sessions zu erweitern.

Dieses Projekt ist gleichzeitig mein persoenliches Lernprojekt fuer Backend-Entwicklung mit C#, ASP.NET Core, Entity Framework Core, PostgreSQL, Dependency Injection, Repositories, Services, DTOs und Schichtenarchitektur.

### Aktuelle Backend-Funktionen

- Subjects erstellen und lesen
- Topics erstellen und lesen
- Topics nach Subject filtern
- Study Notes erstellen und lesen
- Study Notes nach Topic filtern
- Persistenz mit PostgreSQL und Entity Framework Core
- Schichtenarchitektur mit API, Application, Domain und Infrastructure

### Backend-Architektur

```text
StudyFlow.API
-> Controller und HTTP-Endpunkte

StudyFlow.Application
-> Services, DTOs, Validierung, Applikationslogik

StudyFlow.Domain
-> Entities, Enums, Repository-Vertraege

StudyFlow.Infrastructure
-> EF Core DbContext, Repositories, Migrations, PostgreSQL-Konfiguration
```

### Backend Flow

```text
HTTP Request
-> Controller
-> Service
-> Repository
-> DbContext
-> PostgreSQL
```

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Flutter ist fuer das Frontend geplant
- Clean-Architecture-inspirierte Schichten

### Lokales Backend Setup

Die echte Datenbank-Connection-String wird nicht nach GitHub committed.
Fuer lokale Entwicklung wird sie mit ASP.NET Core User Secrets gespeichert:

```powershell
cd backend
dotnet user-secrets set "ConnectionStrings:StudyFlowDb" "Host=localhost;Port=5432;Database=StudyFlowDb;Username=postgres;Password=YOUR_PASSWORD" --project StudyFlow.API\StudyFlow.API.csproj
```

Backend bauen:

```powershell
cd backend
dotnet build StudyFlow.API.slnx
```

Datenbank-Migrationen ausfuehren:

```powershell
cd backend
dotnet ef database update --project StudyFlow.Infrastructure --startup-project StudyFlow.API
```
