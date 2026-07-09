# StudyFlow

StudyFlow is a personal learning project built as a full-stack application.

The repository is organized as a monorepo:

```text
StudyFlow/
|-- backend/
|   |-- StudyFlow.API/
|   |-- StudyFlow.Application/
|   |-- StudyFlow.Domain/
|   |-- StudyFlow.Infrastructure/
|   `-- StudyFlow.API.slnx
|-- frontend/
|   |-- android/
|   |-- ios/
|   |-- lib/
|   |   |-- core/
|   |   |-- data/
|   |   |-- local/
|   |   |-- models/
|   |   |-- repositories/
|   |   |-- screens/
|   |   `-- widgets/
|   |-- test/
|   |-- web/
|   |-- pubspec.yaml
|   `-- README.md
|-- .gitignore
`-- README.md
```

The backend is in progress and already exposes the first API endpoints. The Flutter frontend has also been started and currently provides a visual, navigable, local-first version of StudyFlow using local in-memory repositories backed by example data.

---

## English

### About

StudyFlow is a full-stack learning project with an ASP.NET Core Web API backend and a Flutter frontend. The goal is to organize study content into subjects, topics, and study notes, and later extend the system with quizzes and review sessions.

This project is also my personal learning project for backend and frontend development with C#, ASP.NET Core, Entity Framework Core, PostgreSQL, Dart, Flutter, dependency injection, repositories, services, DTOs, and layered architecture.

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

### Current Frontend Features

The Flutter frontend has been started as the mobile client for StudyFlow.
See the frontend README for current Flutter UI screenshots.

Current frontend features:

- Start screen before entering the main StudyFlow flow
- View a list of subjects
- Create subjects locally
- Open a subject and view its topics
- Create topics locally
- Open a topic and view its study notes
- Create study notes locally
- Delete study notes locally
- Open a study note and read its content
- Local in-memory repositories for subjects, topics, and study notes
- Repository contracts for local-first data access
- Dependency registration with get_it
- String-based frontend IDs prepared for local persistence and backend/API integration
- Local example data used behind the current repository implementations
- Basic navigation between screens
- Basic app theming with a custom color scheme
- SnackBar feedback for local actions
- Reusable widgets for shared layout, list items, and empty states

### Frontend Structure

StudyFlow frontend is currently organized as a small Flutter application:

```text
StudyFlow/frontend/
-> Flutter mobile application

lib/core
-> Dependency registration and app-level setup

lib/models
-> Frontend data models such as Subject, Topic, and StudyNote

lib/data
-> Local example data used before connecting persistence or the backend

lib/repositories/contracts
-> Repository contracts for frontend data access

lib/local
-> Local in-memory repository implementations used before persistence/API integration

lib/screens
-> App screens for start, subjects, topics, study notes, note details, and local creation flows

lib/widgets
-> Reusable UI widgets such as shared screen layout, decorative corner lines, empty state messages, and study note list items
```

### Frontend Flow

```text
StartScreen
-> SubjectsScreen
-> TopicsScreen
-> StudyNotesScreen
-> NoteScreen
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- Local in-memory repositories
- Repository pattern for local data access
- get_it for lightweight dependency registration
- Flutter Navigator for screen navigation
- Local state with StatefulWidget and setState

### Current Frontend Status

The current frontend sprint focuses on building a visual and navigable version of StudyFlow without backend integration.

The frontend currently uses local in-memory repositories backed by example data. Local creation flows for subjects, topics, and study notes are implemented in memory. Study notes can also be deleted locally. Reusable empty states are shown when no local data is available. The frontend models now use string-based IDs, which prepares the app for ToStore local persistence and later ASP.NET Core API integration.

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Dart
- Flutter
- get_it
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

### Local Frontend Setup

Install Flutter dependencies:

```powershell
cd frontend
flutter pub get
```

Analyze the Flutter project:

```powershell
flutter analyze
```

Run the Flutter frontend:

```powershell
flutter run
```

---

## Deutsch

### Ueber das Projekt

StudyFlow ist ein Full-Stack-Lernprojekt mit einem ASP.NET Core Web API Backend und einem Flutter-Frontend. Das Ziel ist, Lerninhalte in Subjects, Topics und Study Notes zu organisieren und das System spaeter mit Quizzes und Review Sessions zu erweitern.

Dieses Projekt ist gleichzeitig mein persoenliches Lernprojekt fuer Backend- und Frontend-Entwicklung mit C#, ASP.NET Core, Entity Framework Core, PostgreSQL, Dart, Flutter, Dependency Injection, Repositories, Services, DTOs und Schichtenarchitektur.

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

### Aktuelle Frontend-Funktionen

Das Flutter-Frontend wurde als mobiler Client fuer StudyFlow gestartet.
Siehe Frontend-README fuer aktuelle Screenshots der Flutter-Oberflaeche.

Aktuelle Frontend-Funktionen:

- Startscreen vor dem Einstieg in den Hauptbereich der App
- Liste von Subjects anzeigen
- Subjects lokal erstellen
- Ein Subject oeffnen und die dazugehoerigen Topics anzeigen
- Topics lokal erstellen
- Ein Topic oeffnen und die dazugehoerigen Study Notes anzeigen
- Study Notes lokal erstellen
- Study Notes lokal loeschen
- Eine Study Note oeffnen und ihren Inhalt lesen
- Lokale In-Memory-Repositories fuer Subjects, Topics und Study Notes
- Repository-Vertraege fuer lokalen Datenzugriff
- Dependency-Registrierung mit get_it
- String-basierte Frontend-IDs als Vorbereitung auf lokale Persistenz und Backend/API-Anbindung
- Lokale Beispieldaten hinter den aktuellen Repository-Implementierungen
- Einfache Navigation zwischen den Screens
- Einfaches App-Theming mit eigenem Farbschema
- SnackBar-Feedback fuer lokale Aktionen
- Wiederverwendbare Widgets fuer gemeinsames Layout, Listenelemente und Empty States

### Frontend-Struktur

Das StudyFlow-Frontend ist aktuell als kleine Flutter-Anwendung organisiert:

```text
StudyFlow/frontend/
-> Flutter Mobile Application

lib/core
-> Dependency-Registrierung und app-weites Setup

lib/models
-> Frontend-Datenmodelle wie Subject, Topic und StudyNote

lib/data
-> Lokale Beispieldaten, die vor Persistenz oder Backend-Anbindung verwendet werden

lib/repositories/contracts
-> Repository-Vertraege fuer den Datenzugriff im Frontend

lib/local
-> Lokale In-Memory-Repository-Implementierungen vor Persistenz/API-Integration

lib/screens
-> App-Screens fuer Start, Subjects, Topics, Study Notes, Note Details und lokale Creation Flows

lib/widgets
-> Wiederverwendbare UI-Widgets wie gemeinsames Screen-Layout, dekorative Corner Lines, Empty-State-Meldungen und Study Note List Items
```

### Frontend Flow

```text
StartScreen
-> SubjectsScreen
-> TopicsScreen
-> StudyNotesScreen
-> NoteScreen
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- Lokale In-Memory-Repositories
- Repository Pattern fuer lokalen Datenzugriff
- get_it fuer einfache Dependency-Registrierung
- Flutter Navigator fuer die Navigation zwischen Screens
- Lokaler State mit StatefulWidget und setState

### Aktueller Frontend-Status

Der aktuelle Frontend-Sprint konzentriert sich darauf, eine visuelle und navigierbare Version von StudyFlow ohne Backend-Anbindung zu erstellen.

Das Frontend verwendet aktuell lokale In-Memory-Repositories, die auf Beispieldaten basieren. Lokale Creation Flows fuer Subjects, Topics und Study Notes sind im Speicher umgesetzt. Study Notes koennen lokal geloescht werden. Wiederverwendbare Empty States werden angezeigt, wenn keine lokalen Daten vorhanden sind. Die Frontend-Modelle verwenden jetzt String-basierte IDs. Dadurch wird die App auf lokale Persistenz mit ToStore und eine spaetere ASP.NET Core API-Anbindung vorbereitet.

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Dart
- Flutter
- get_it
- Clean-Architecture-inspirierte Schichten

### Lokales Backend Setup

Der echte Datenbank-Connection-String wird nicht nach GitHub committed.
Fuer lokale Entwicklung wird er mit ASP.NET Core User Secrets gespeichert:

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

### Lokales Frontend Setup

Flutter-Abhaengigkeiten installieren:

```powershell
cd frontend
flutter pub get
```

Flutter-Projekt analysieren:

```powershell
flutter analyze
```

Flutter-Frontend starten:

```powershell
flutter run
```

