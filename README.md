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
|   |   |-- application/
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

The backend is in progress and already exposes the first API endpoints. The Flutter frontend has also been started and currently provides a visual, navigable, local-first version of StudyFlow using repository contracts, Riverpod, stream-based providers, and ToStore-backed local persistence.

---

## English

### About

StudyFlow is a full-stack learning project with an ASP.NET Core Web API backend and a Flutter frontend. The goal is to organize study content into subjects, topics, study notes, quizzes, questions, and answer options, while also providing a dedicated area for exam preparation.

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
- Mode selection screen with functional Study Mode and Exam Mode entry points
- View, create, edit, and delete subjects locally
- View, create, edit, and delete topics locally
- Open a topic in a dedicated topic detail screen
- Switch between study notes and quiz area with a bottom navigation bar
- View, create, edit, and delete study notes locally
- Open a study note and read Markdown-rendered content
- Create quizzes locally
- View, create, edit, and delete quiz questions locally
- View, create, edit, and delete answer options locally
- Mark answer options as correct
- Validate quiz readiness before starting
- Play quizzes with visual answer feedback
- Render quiz questions and answer options as Markdown
- Show final quiz results with score, percentage, and retry option
- Create, edit, and delete exam sections such as AP1 or AP2
- Create, edit, delete, and read Markdown-formatted exam tips
- Navigate through Exam Mode tabs for tips, future practice exams, and future attempt history
- Import structured content from pasted JSON or a selected `.json` file
- Import exam sections and exam tips alongside Study Mode content
- Reuse existing subjects, topics, and exam sections during JSON seed import
- Local persistence with ToStore for Study Mode content, exam sections, and exam tips
- Cascade deletion support through ToStore relationships
- Repository contracts with ToStore-backed implementations
- Riverpod migration for the main local-first study and quiz flows
- Stream-based Riverpod providers for automatic UI updates in migrated local lists
- Riverpod controllers for create/edit/delete actions
- Application-level helpers for quiz validation, quiz play data loading, and JSON seed import
- String-based frontend IDs prepared for local persistence and backend/API integration
- Basic navigation between screens
- Light and dark app themes with shared color configuration
- Responsive layouts for phone and tablet orientations
- Themed SnackBar feedback for local success, info, error, and delete actions
- Reusable widgets for shared layout, list items, and empty states

### Frontend Structure

StudyFlow frontend is currently organized as a small Flutter application:

```text
StudyFlow/frontend/
-> Flutter mobile application

lib/application
-> Application-level use cases, seed import logic, and data loading helpers, such as quiz validation and quiz play data loading

lib/controllers
-> Riverpod controllers for user actions such as create, edit, and delete

lib/models
-> Frontend data models such as Subject, Topic, StudyNote, Quiz, Question, AnswerOption, ExamSection, and ExamTip

lib/providers
-> Riverpod providers for repositories, stream-based list state, and application-level helpers

lib/theme
-> Shared light and dark Material theme configuration

lib/repositories/contracts
-> Repository contracts for frontend data access

lib/local
-> Local repository implementations, including ToStore-based persistence

lib/local/tostore
-> ToStore database setup, schemas, and ToStore repository implementations

lib/screens
-> App screens for Study Mode, Exam Mode sections and tips, JSON seed import, and local creation flows

lib/widgets
-> Reusable UI widgets such as mode cards, button styles, SnackBars, empty state messages, and study note list items
```

### Frontend Flow

```text
StartScreen
-> ModeSelectionScreen
   -> Study Mode
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
   -> Exam Mode
      -> ExamSectionsScreen
         -> ExamSectionDetailScreen
            -> Tips
            -> Practice Exams (planned)
            -> History (planned)
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- ToStore for local persistence
- Repository pattern with local ToStore implementations
- Riverpod for state management, dependency access, and controller-based screen logic
- StreamProvider for automatic UI updates in migrated local lists
- Flutter Navigator for screen navigation
- Local widget state with StatefulWidget and setState where the state is purely visual

### Current Frontend Status

The current frontend sprint focuses on building a visual, navigable, local-first version of StudyFlow before backend integration.

The frontend currently uses repository contracts with ToStore-backed local persistence for subjects, topics, study notes, quizzes, questions, and answer options. The main study entities now support local create, edit, and delete flows.

The frontend has been migrated from screen-owned list state and direct screen-level dependency access to Riverpod providers and controllers for the main local-first flows. Subjects, topics, study notes, quizzes, questions, answer options, quiz validation, and quiz play data loading now use Riverpod-based access patterns.

Subjects, topics, study notes, quizzes, quiz questions, and answer options now use stream-based Riverpod providers backed by ToStore watchers. Their screens observe live provider state, while controllers focus on user actions such as create, edit, and delete.

The quiz area supports a first usable local quiz flow. Users can create questions, add answer options, mark the correct answer, prevent multiple correct answers for the same question, edit quiz content, validate quiz readiness before starting, start a quiz, select answers, receive visual feedback for correct and incorrect answers, and view a final result screen.

Study notes, quiz questions, and answer options can now be displayed with Markdown formatting. The UI also includes a mode selection screen before the study flow, a shared theme file for light and dark mode, reusable mode cards, shared button styling for form actions, and themed SnackBar helpers for consistent success, info, error, and delete feedback.

The frontend JSON seed importer accepts pasted JSON and selected `.json` files. It creates Study Mode content plus Exam Mode sections and Markdown tips. Existing subjects, topics, and exam sections are reused by normalized name comparison, and local create operations are retried when ToStore temporarily needs time to refill its ID pool.

Exam Mode now has its first functional vertical slice. Users can manage exam sections such as AP1 and AP2, open a section, and manage Markdown-formatted tips and recommendations. The Practice Exams and History tabs establish the next extension points but do not persist exams or attempts yet.

Reusable empty states are shown when no local data is available. The frontend models use string-based IDs, which prepares the app for local persistence and later ASP.NET Core API integration.

### Tech Stack

- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Dart
- Flutter
- ToStore
- Riverpod
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
- Modus-Auswahl mit Study Mode und funktionalem Exam-Mode-Einstieg
- Subjects lokal anzeigen, erstellen, bearbeiten und loeschen
- Topics lokal anzeigen, erstellen, bearbeiten und loeschen
- Ein Topic in einem eigenen Topic-Detail-Screen oeffnen
- Zwischen Study Notes und Quiz-Bereich ueber eine Bottom Navigation wechseln
- Study Notes lokal anzeigen, erstellen, bearbeiten und loeschen
- Eine Study Note oeffnen und Markdown-formatierten Inhalt lesen
- Quizze lokal erstellen
- Quizfragen lokal anzeigen, erstellen, bearbeiten und loeschen
- Antwortoptionen lokal anzeigen, erstellen, bearbeiten und loeschen
- Antwortoptionen als richtig markieren
- Quiz vor dem Start validieren
- Quizze mit richtig/falsch-Feedback spielen
- Quizfragen und Antwortoptionen als Markdown anzeigen
- Ergebnisbildschirm mit Punktzahl, Prozentanzeige und Wiederholen-Option anzeigen
- Exam Sections wie AP1 oder AP2 lokal erstellen, bearbeiten und loeschen
- Markdown-formatierte Exam Tips erstellen, lesen, bearbeiten und loeschen
- Exam-Mode-Navigation fuer Tips sowie vorbereitete Bereiche fuer Practice Exams und Verlauf
- Strukturierte Inhalte aus eingefuegtem JSON oder einer ausgewaehlten `.json`-Datei importieren
- Exam Sections und Exam Tips zusammen mit Study-Mode-Inhalten importieren
- Vorhandene Subjects, Topics und Exam Sections beim JSON-Import wiederverwenden
- Lokale ToStore-Persistenz fuer Study Mode, Exam Sections und Exam Tips
- Cascade Delete ueber ToStore-Beziehungen
- Repository-Contracts mit ToStore-basierten Implementierungen
- Riverpod-Migration fuer die wichtigsten lokalen Study- und Quiz-Flows
- Stream-basierte Riverpod-Provider fuer automatische UI-Updates in den migrierten lokalen Listen
- Riverpod-Controller fuer Create/Edit/Delete-Aktionen
- Application-Level-Helfer fuer Quiz-Validierung, Quiz-Play-Daten und JSON-Seed-Import
- String-basierte IDs fuer lokale Persistenz und spaetere Backend/API-Integration
- Einfache Navigation zwischen Screens
- Light- und Dark-Theme mit gemeinsamer Farbkonfiguration
- Responsive Layouts fuer Smartphone- und Tablet-Ausrichtungen
- Gestyltes SnackBar-Feedback fuer Success-, Info-, Error- und Delete-Aktionen
- Wiederverwendbare Widgets fuer gemeinsames Layout, Listenelemente und Empty States

### Frontend-Struktur

Das StudyFlow-Frontend ist aktuell als kleine Flutter-Anwendung organisiert:

```text
StudyFlow/frontend/
-> Flutter Mobile Application

lib/application
-> Use Cases, Seed-Import-Logik und Lade-Helfer auf Application-Ebene, zum Beispiel Quiz-Validierung und Quiz-Play-Daten

lib/controllers
-> Riverpod-Controller fuer Benutzeraktionen wie Create, Edit und Delete

lib/models
-> Frontend-Datenmodelle wie Subject, Topic, StudyNote, Quiz, Question, AnswerOption, ExamSection und ExamTip

lib/providers
-> Riverpod-Provider fuer Repositories, stream-basierten Listen-State und Application-Level-Helfer

lib/theme
-> Gemeinsame Material-Theme-Konfiguration fuer Light Mode und Dark Mode

lib/repositories/contracts
-> Repository-Vertraege fuer den Datenzugriff im Frontend

lib/local
-> Lokale Repository-Implementierungen, inklusive ToStore-basierter Persistenz

lib/local/tostore
-> ToStore-Datenbank-Setup, Schemas und ToStore-Repository-Implementierungen

lib/screens
-> App-Screens fuer Study Mode, Exam Sections und Tips, JSON-Seed-Import und lokale Creation Flows

lib/widgets
-> Wiederverwendbare UI-Widgets wie Mode Cards, Button Styles, SnackBars, Empty-State-Meldungen und Study Note List Items
```

### Frontend Flow

```text
StartScreen
-> ModeSelectionScreen
   -> Study Mode
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
   -> Exam Mode
      -> ExamSectionsScreen
         -> ExamSectionDetailScreen
            -> Tips
            -> Practice Exams (geplant)
            -> History (geplant)
```

### Frontend Tech Stack

- Dart
- Flutter
- Material Design
- ToStore fuer lokale Persistenz
- Repository Pattern mit lokalen ToStore-Implementierungen
- Riverpod fuer State Management, Dependency-Zugriff und Controller-basierte Screen-Logik
- StreamProvider fuer automatische UI-Updates in migrierten lokalen Listen
- Flutter Navigator fuer die Navigation zwischen Screens
- Lokaler Widget-State mit StatefulWidget und setState, wenn der State rein visuell ist

### Aktueller Frontend-Status

Der aktuelle Frontend-Sprint konzentriert sich darauf, eine visuelle, navigierbare und local-first Version von StudyFlow vor der Backend-Anbindung zu erstellen.

Das Frontend verwendet aktuell Repository-Vertraege mit ToStore-basierter lokaler Persistenz fuer Subjects, Topics, Study Notes, Quizzes, Questions und Answer Options. Die wichtigsten Lern-Entitaeten unterstuetzen jetzt lokale Create-, Edit- und Delete-Flows.

Das Frontend wurde fuer die wichtigsten lokalen Flows von Screen-eigenem Listen-State und direktem Dependency-Zugriff in Screens auf Riverpod-Provider und Controller migriert. Subjects, Topics, Study Notes, Quizze, Questions, Answer Options, Quiz-Validierung und Quiz-Play-Daten verwenden jetzt Riverpod-basierte Zugriffsmuster.

Subjects, Topics, Study Notes, Quizze, Quiz Questions und Answer Options verwenden jetzt stream-basierte Riverpod-Provider mit ToStore-Watchern. Die Screens beobachten live den Provider-State, waehrend Controller sich auf Benutzeraktionen wie Create, Edit und Delete konzentrieren.

Der Quiz-Bereich unterstuetzt jetzt einen ersten nutzbaren lokalen Quiz-Flow. Benutzer koennen Fragen erstellen, Antwortoptionen hinzufuegen, die richtige Antwort markieren, mehrere richtige Antworten pro Frage verhindern, Quiz-Inhalte bearbeiten, ein Quiz vor dem Start validieren, ein Quiz starten, Antworten auswaehlen, visuelles Feedback fuer richtige und falsche Antworten erhalten und einen Ergebnisbildschirm anzeigen.

Study Notes, Quizfragen und Antwortoptionen koennen jetzt mit Markdown-Formatierung angezeigt werden. Die UI enthaelt ausserdem eine Modus-Auswahl vor dem Study Flow, eine gemeinsame Theme-Datei fuer Light Mode und Dark Mode, wiederverwendbare Mode Cards, gemeinsames Button-Styling fuer Formularaktionen und gestylte SnackBar-Helfer fuer konsistentes Success-, Info-, Error- und Delete-Feedback.

Der JSON-Seed-Import akzeptiert eingefuegtes JSON und ausgewaehlte `.json`-Dateien. Neben Study-Mode-Inhalten koennen Exam Sections und Markdown-formatierte Exam Tips erstellt werden. Vorhandene Subjects, Topics und Exam Sections werden ueber normalisierte Namensvergleiche wiederverwendet. Erstellungsoperationen werden wiederholt, wenn der lokale ToStore-ID-Pool kurzzeitig noch nicht bereit ist.

Exam Mode besitzt jetzt einen ersten funktionalen Vertical Slice. Benutzer koennen Exam Sections wie AP1 und AP2 verwalten, eine Section oeffnen und Markdown-formatierte Tipps und Empfehlungen pflegen. Practice Exams und History sind als naechste Erweiterungspunkte vorbereitet, speichern aber noch keine Pruefungen oder Versuche.

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
