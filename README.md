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
|   |-- docs/
|   |-- ios/
|   |-- lib/
|   |   |-- core/
|   |   |-- controllers/
|   |   |-- data/
|   |   |-- local/
|   |   |-- models/
|   |   |-- providers/
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

StudyFlow is a full-stack learning project with an ASP.NET Core Web API backend and a Flutter frontend. The goal is to organize study content into subjects, topics, study notes, quizzes, questions, and answer options.

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
- View, create, edit, and delete subjects locally
- View, create, edit, and delete topics locally
- Open a topic in a dedicated topic detail screen
- Switch between study notes and quiz area with a bottom navigation bar
- View, create, edit, and delete study notes locally
- Open a study note and read its content
- Create quizzes locally
- View, create, edit, and delete quiz questions locally
- View, create, edit, and delete answer options locally
- Mark answer options as correct
- Validate quiz readiness before starting
- Play quizzes with visual answer feedback
- Show final quiz results with score, percentage, and retry option
- Local persistence with ToStore for subjects, topics, study notes, quizzes, questions, and answer options
- Cascade deletion support through ToStore relationships
- Repository contracts with ToStore-backed implementations
- Initial Riverpod migration for subjects, topics, and study notes
- Riverpod controllers for migrated list state and create/edit/delete actions
- Dependency registration with get_it
- String-based frontend IDs prepared for local persistence and backend/API integration
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

lib/controllers
-> Riverpod controllers for migrated state and user actions

lib/models
-> Frontend data models such as Subject, Topic, StudyNote, Quiz, Question, and AnswerOption

lib/providers
-> Riverpod providers for repositories and async state

lib/repositories/contracts
-> Repository contracts for frontend data access

lib/local
-> Local repository implementations, including ToStore-based persistence

lib/local/tostore
-> ToStore database setup, schemas, and ToStore repository implementations

lib/screens
-> App screens for start, subjects, topics, topic details, study notes, quizzes, questions, answer options, note details, and local creation flows

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
      -> NoteScreen
   -> QuizzesScreen
      -> QuizQuestionsScreen
         -> QuestionDetailScreen
      -> QuizPlayScreen
         -> QuizResultScreen
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- ToStore for local persistence
- Repository pattern with local ToStore implementations
- Riverpod for migrated state management and controller-based screen logic
- get_it for lightweight dependency registration
- Flutter Navigator for screen navigation
- Local widget state with StatefulWidget and setState where the state is purely visual

### Current Frontend Status

The current frontend sprint focuses on building a visual, navigable, local-first version of StudyFlow before backend integration.

The frontend currently uses repository contracts with ToStore-backed local persistence for subjects, topics, study notes, quizzes, questions, and answer options. The main study entities now support local create, edit, and delete flows.

The frontend is being migrated gradually from screen-owned state and get_it-based access to Riverpod providers and controllers. Subjects, topics, and study notes already use Riverpod for loading state and create/edit/delete actions. Remaining flows still use the previous pattern until they are migrated.

The quiz area supports a first usable local quiz flow. Users can create questions, add answer options, mark the correct answer, edit quiz content, start a quiz, select answers, receive visual feedback for correct and incorrect answers, and view a final result screen.

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

StudyFlow ist ein Full-Stack-Lernprojekt mit einem ASP.NET Core Web API Backend und einem Flutter-Frontend. Das Ziel ist, Lerninhalte in Subjects, Topics, Study Notes, Quizzes, Questions und Answer Options zu organisieren.

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

Das Flutter-Frontend wurde als mobiler Client fuer StudyFlow gestartet. Aktuelle Screenshots befinden sich im Frontend-README.

Aktuelle Frontend-Funktionen:

- Startbildschirm vor dem eigentlichen StudyFlow-Bereich
- Subjects lokal anzeigen, erstellen, bearbeiten und loeschen
- Topics lokal anzeigen, erstellen, bearbeiten und loeschen
- Ein Topic in einem eigenen Topic-Detail-Screen oeffnen
- Zwischen Study Notes und Quiz-Bereich ueber eine Bottom Navigation wechseln
- Study Notes lokal anzeigen, erstellen, bearbeiten und loeschen
- Eine Study Note oeffnen und den Inhalt lesen
- Quizze lokal erstellen
- Quizfragen lokal anzeigen, erstellen, bearbeiten und loeschen
- Antwortoptionen lokal anzeigen, erstellen, bearbeiten und loeschen
- Antwortoptionen als richtig markieren
- Quiz vor dem Start validieren
- Quizze mit richtig/falsch-Feedback spielen
- Ergebnisbildschirm mit Punktzahl, Prozentanzeige und Wiederholen-Option anzeigen
- Lokale Persistenz mit ToStore fuer Subjects, Topics, Study Notes, Quizze, Fragen und Antwortoptionen
- Cascade Delete ueber ToStore-Beziehungen
- Repository-Contracts mit ToStore-basierten Implementierungen
- Erste Riverpod-Migration fuer Subjects, Topics und Study Notes
- Riverpod-Controller fuer migrierten Listen-State und Create/Edit/Delete-Aktionen
- Dependency-Registrierung mit get_it
- String-basierte IDs fuer lokale Persistenz und spaetere Backend/API-Integration
- Einfache Navigation zwischen Screens
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

lib/controllers
-> Riverpod-Controller fuer migrierten State und Benutzeraktionen

lib/models
-> Frontend-Datenmodelle wie Subject, Topic, StudyNote, Quiz, Question und AnswerOption

lib/providers
-> Riverpod-Provider fuer Repositories und asynchronen State

lib/repositories/contracts
-> Repository-Vertraege fuer den Datenzugriff im Frontend

lib/local
-> Lokale Repository-Implementierungen, inklusive ToStore-basierter Persistenz

lib/local/tostore
-> ToStore-Datenbank-Setup, Schemas und ToStore-Repository-Implementierungen

lib/screens
-> App-Screens fuer Start, Subjects, Topics, Topic Details, Study Notes, Quizzes, Questions, Answer Options, Note Details und lokale Creation Flows

lib/widgets
-> Wiederverwendbare UI-Widgets wie Empty-State-Meldungen und Study Note List Items
```

### Frontend Flow

```text
StartScreen
-> SubjectsScreen
-> TopicsScreen
-> TopicDetailScreen
   -> StudyNotesScreen
      -> NoteScreen
   -> QuizzesScreen
      -> QuizQuestionsScreen
         -> QuestionDetailScreen
      -> QuizPlayScreen
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- ToStore fuer lokale Persistenz
- Repository Pattern mit lokalen ToStore-Implementierungen
- Riverpod fuer migriertes State Management und Controller-basierte Screen-Logik
- get_it fuer einfache Dependency-Registrierung
- Flutter Navigator fuer die Navigation zwischen Screens
- Lokaler Widget-State mit StatefulWidget und setState, wenn der State rein visuell ist

### Aktueller Frontend-Status

Der aktuelle Frontend-Sprint konzentriert sich darauf, eine visuelle, navigierbare und local-first Version von StudyFlow vor der Backend-Anbindung zu erstellen.

Das Frontend verwendet aktuell Repository-Vertraege mit ToStore-basierter lokaler Persistenz fuer Subjects, Topics, Study Notes, Quizzes, Questions und Answer Options. Die wichtigsten Lern-Entitaeten unterstuetzen jetzt lokale Create-, Edit- und Delete-Flows.

Das Frontend wird schrittweise von Screen-eigenem State und get_it-basiertem Zugriff auf Riverpod-Provider und Controller migriert. Subjects, Topics und Study Notes verwenden bereits Riverpod fuer Ladezustand und Create/Edit/Delete-Aktionen. Die uebrigen Flows verwenden noch das bisherige Muster, bis sie migriert werden.

Der Quiz-Bereich unterstuetzt jetzt einen ersten nutzbaren lokalen Quiz-Flow. Benutzer koennen Fragen erstellen, Antwortoptionen hinzufuegen, die richtige Antwort markieren, Quiz-Inhalte bearbeiten, ein Quiz starten, Antworten auswaehlen, visuelles Feedback fuer richtige und falsche Antworten erhalten und einen Ergebnisbildschirm anzeigen.

Wiederverwendbare Empty States werden angezeigt, wenn keine lokalen Daten vorhanden sind. Die Frontend-Modelle verwenden String-basierte IDs. Dadurch wird die App auf lokale Persistenz und eine spaetere ASP.NET Core API-Anbindung vorbereitet.

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Dart
- Flutter
- ToStore
- Riverpod
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
