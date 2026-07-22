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

The backend is in progress and already exposes the first API endpoints. The Flutter frontend has also been started and currently provides a visual, navigable, local-first version of StudyFlow using repository contracts and ToStore-backed local persistence.

---

## English

### About

StudyFlow is a full-stack learning project with an ASP.NET Core Web API backend and a Flutter frontend. The goal is to organize study content into subjects, topics, and study notes, and later extend the system with quizzes and review sessions.

This project is also my personal learning project for backend and frontend development with C#, ASP.NET Core, Entity Framework Core, PostgreSQL, Dart, Flutter, dependency injection, repositories, services, DTOs, local persistence, and layered architecture.

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

The Flutter frontend has been started as the mobile client for StudyFlow. See the frontend README for current Flutter UI screenshots.

Current frontend features:

- Start screen before entering the main StudyFlow flow
- View a list of subjects
- Create subjects locally
- Open a subject and view its topics
- Create topics locally
- Open a topic in a dedicated topic detail screen
- Switch between study notes and quiz area with a bottom navigation bar
- Open a topic and view its study notes
- Create study notes locally
- Delete study notes locally
- Open a study note and read its content
- Local persistence with ToStore for subjects, topics, study notes, quizzes, questions, and answer options
- Repository contracts with ToStore-backed local implementations
- Dependency registration with get_it
- String-based frontend IDs prepared for local persistence and backend/API integration
- Quiz foundation with Quiz, Question, and AnswerOption models
- Initial quiz questions screen
- Basic navigation between screens
- Basic app theming with a custom color scheme
- SnackBar feedback for local actions
- Dummy data and in-memory repositories have been removed

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
-> Local example data used as initial development data

lib/repositories/contracts
-> Repository contracts for frontend data access

lib/local
-> Local repository implementations, including ToStore-based persistence

lib/local/tostore
-> ToStore database setup, schemas, and ToStore repository implementations

lib/screens
-> App screens for start, subjects, topics, study notes, note details, and local creation flows

lib/widgets
-> Reusable UI widgets such as shared screen layout, empty state messages, and study note list items
```

### Frontend Flow

```text
StartScreen
-> SubjectsScreen
-> TopicsScreen
-> TopicDetailScreen
   -> StudyNotesScreen
   -> QuizzesScreen
-> NoteScreen
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- ToStore for local persistence
- Repository pattern with local ToStore implementations
- get_it for lightweight dependency registration
- Flutter Navigator for screen navigation
- Local state with StatefulWidget and setState

### Current Frontend Status

The current frontend sprint focuses on building a visual, navigable, local-first version of StudyFlow before backend integration.

The frontend currently uses repository contracts with ToStore-backed local persistence for subjects, topics, and study notes. Local creation flows for subjects, topics, and study notes are implemented, and study notes can also be deleted locally.

Reusable empty states are shown when no local data is available. The frontend models use string-based IDs, which prepares the app for local persistence and later ASP.NET Core API integration.

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Dart
- Flutter
- ToStore
- get_it
- Clean Architecture inspired layering

### Local Backend Setup

The real database connection string is not committed to GitHub. For local development, store it with ASP.NET Core User Secrets:

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

Dieses Projekt ist gleichzeitig mein persoenliches Lernprojekt fuer Backend- und Frontend-Entwicklung mit C#, ASP.NET Core, Entity Framework Core, PostgreSQL, Dart, Flutter, Dependency Injection, Repositories, Services, DTOs, lokaler Persistenz und Schichtenarchitektur.

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

Das Flutter-Frontend wurde als mobiler Client fuer StudyFlow gestartet. Siehe Frontend-README fuer aktuelle Screenshots der Flutter-Oberflaeche.

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
- Lokale Persistenz mit ToStore fuer Subjects, Topics und Study Notes
- Repository-Vertraege mit ToStore-basierten lokalen Implementierungen
- Dependency-Registrierung mit get_it
- String-basierte Frontend-IDs als Vorbereitung auf lokale Persistenz und Backend/API-Anbindung
- Lokale Beispieldaten als initiale Entwicklungsdaten
- Einfache Navigation zwischen den Screens
- Einfaches App-Theming mit eigenem Farbschema
- SnackBar-Feedback fuer lokale Aktionen
- Wiederverwendbare Widgets fuer gemeinsames Layout, Listenelemente und Empty States
- Ein Topic in einem eigenen Topic-Detail-Screen oeffnen
- Zwischen Study Notes und Quiz-Bereich ueber eine Bottom Navigation wechseln
- Erstes Quiz-Modell und ein vorlaeufiger Quiz-Tab als Platzhalter

### Frontend-Struktur

Das StudyFlow-Frontend ist aktuell als kleine Flutter-Anwendung organisiert:

```text
StudyFlow/frontend/
-> Flutter Mobile Application

lib/core
-> Dependency-Registrierung und app-weites Setup

lib/models
-> Frontend-Datenmodelle wie Subject, Topic, StudyNote und Quiz

lib/data
-> Lokale Beispieldaten als initiale Entwicklungsdaten

lib/repositories/contracts
-> Repository-Vertraege fuer den Datenzugriff im Frontend

lib/local
-> Lokale Repository-Implementierungen, inklusive ToStore-basierter Persistenz

lib/local/tostore
-> ToStore-Datenbank-Setup, Schemas und ToStore-Repository-Implementierungen

lib/screens
-> App-Screens fuer Start, Subjects, Topics, Topic Details, Study Notes, Quiz-Platzhalter, Note Details und lokale Creation Flows

lib/widgets
-> Wiederverwendbare UI-Widgets wie gemeinsames Screen-Layout, Empty-State-Meldungen und Study Note List Items
```

### Frontend Flow

```text
StartScreen
-> SubjectsScreen
-> TopicsScreen
-> TopicDetailScreen
   -> StudyNotesScreen
   -> QuizzesScreen
-> NoteScreen
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- ToStore fuer lokale Persistenz
- Repository Pattern mit lokalen ToStore-Implementierungen
- get_it fuer einfache Dependency-Registrierung
- Flutter Navigator fuer die Navigation zwischen Screens
- Lokaler State mit StatefulWidget und setState

### Aktueller Frontend-Status

Der aktuelle Frontend-Sprint konzentriert sich darauf, eine visuelle, navigierbare und local-first Version von StudyFlow vor der Backend-Anbindung zu erstellen.

Das Frontend verwendet aktuell Repository-Vertraege mit ToStore-basierter lokaler Persistenz fuer Subjects, Topics und Study Notes. Lokale Creation Flows fuer Subjects, Topics und Study Notes sind umgesetzt. Study Notes koennen lokal geloescht werden.

Wiederverwendbare Empty States werden angezeigt, wenn keine lokalen Daten vorhanden sind. Die Frontend-Modelle verwenden String-basierte IDs. Dadurch wird die App auf lokale Persistenz und eine spaetere ASP.NET Core API-Anbindung vorbereitet.

Zusätzlich wurde ein Topic-Detail-Screen eingeführt. Dort kann der Benutzer innerhalb eines Topics zwischen Study Notes und einem vorläufigen Quiz-Bereich wechseln. Der Quiz-Bereich ist aktuell noch ein Platzhalter und dient als Vorbereitung fuer die naechsten Schritte mit Quizzes, Questions und Answer Options.

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Dart
- Flutter
- ToStore
- get_it
- Clean-Architecture-inspirierte Schichten

### Lokales Backend Setup

Der echte Datenbank-Connection-String wird nicht nach GitHub committed. Fuer lokale Entwicklung wird er mit ASP.NET Core User Secrets gespeichert:

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