# StudyFlow

StudyFlow is an offline-first learning application built with Flutter. It
organizes learning material, supports focused quizzes, and provides short
practice exams with immediate explanations. An ASP.NET Core backend exists in
the same repository and will be connected after the V1 local data model is
stable.

```text
StudyFlow/
|-- backend/      ASP.NET Core Web API and PostgreSQL persistence
|-- frontend/     Flutter application and local ToStore database
`-- README.md
```

The current usable application is the Flutter frontend. It works without a
backend and stores its data locally.

---

## English

### Product Structure

Study Mode uses the following content hierarchy:

```text
Subject
`-- Topic
    |-- Subtopic
    |   `-- Study Notes
    `-- Topic Quiz
        `-- Questions classified by Subtopic
```

A Topic Quiz can be started with one, several, or all of its Subtopics. This
supports both focused practice and mixed revision without duplicating quizzes.

Exam Mode uses a separate model:

```text
Exam Section
|-- Exam Tips
`-- Practice Exams
    `-- Questions and answer options
```

Practice Exam questions can optionally reference a Subtopic. This classification
will later support weakness detection and direct recommendations to the relevant
Study Mode content.

### Current Frontend Features

- Offline-first local use with ToStore persistence
- Subjects, Topics, Subtopics, and Markdown Study Notes
- Local create, edit, and delete flows for Study Mode content
- One Topic Quiz containing questions classified by Subtopic
- Selection of one, multiple, or all Subtopics before starting a quiz
- Randomized quiz questions and answer options
- Immediate correct/incorrect feedback and Markdown explanations
- Quiz result screen with score, percentage, and retry
- No fixed maximum number of quiz questions
- Exam Sections and Markdown Exam Tips
- Practice Exam CRUD for exams, questions, and answer options
- Practice Exam validation with at least four options and exactly one correct answer
- Complete Practice Exam simulation with previous/next navigation
- Preserved answers, immediate feedback, explanations, and final results
- JSON import from pasted text or a selected file
- New nested Subtopic seed format and legacy seed compatibility
- Responsive phone and tablet layouts in portrait and landscape
- Light and dark themes
- Custom StudyFlow launcher icon
- Riverpod providers, streams, and controllers
- Repository contracts with ToStore-backed implementations

### JSON Seed Import

The current seed format supports:

- Subjects
- Topics
- Subtopics
- Study Notes
- Topic Quizzes
- Questions with Subtopic classification
- Answer options
- Optional Markdown explanations
- Exam Sections and Exam Tips

Legacy Topics that contain `studyNotes` directly are still accepted. Their
notes are placed in an automatically created `General` Subtopic. In the new
format every quiz question references a Subtopic by its exact name.

The canonical example is:

- [`frontend/docs/study-seed-subtopics-example.json`](frontend/docs/study-seed-subtopics-example.json)

Practice Exams and attempt history are not imported from JSON yet. Reimporting
the same seed can still duplicate notes, quizzes, questions, and answers, so a
large production import should currently be performed only once.

### Local Database

The current Subtopic schema uses the versioned local database
`studyflow_v2`. It intentionally starts with a clean local store because the
pre-V1 schema could not safely add required Subtopic foreign keys to existing
records. Old database files are not deleted, but their data must be converted
and imported into the new format.

### Frontend Architecture

```text
Flutter Screen
-> Riverpod Controller / Application Use Case
-> Repository Contract
-> ToStore Repository
-> Local ToStore Database
```

Main frontend folders:

```text
frontend/lib/
|-- core/                    Shared database, theme, and UI building blocks
|-- features/
|   |-- app_shell/           Startup and mode selection
|   |-- exam/                Exam Sections, Tips, and Practice Exams
|   |-- quiz/                Topic quizzes and quiz play
|   |-- seed_import/         JSON parsing, validation, and import UI
|   `-- study_content/       Subjects, Topics, Subtopics, and Study Notes
`-- main.dart
```

StudyFlow originally grouped every model, provider, controller, repository, and
screen in a global technical folder. As the application grew, changing one
workflow required searching across many unrelated directories. The frontend now
uses a feature-first structure: files that change together live together.

Larger features keep internal `domain`, `data`, `application`, and
`presentation` layers. This preserves repository abstractions and dependency
direction without introducing a separate feature for every entity. Shared code
belongs in `core` only when it is genuinely used by multiple features.

### Current Backend Status

The backend is an ASP.NET Core Web API organized into API, Application, Domain,
and Infrastructure projects. It already contains the first Subject, Topic, and
Study Note endpoints with Entity Framework Core and PostgreSQL. Backend work is
paused until the V1 frontend models, Practice Exam history, and JSON contracts
are stable.

### Verification

The current frontend state passes:

```powershell
flutter analyze
flutter test
```

The suite currently contains 26 passing tests covering seed parsing and
validation, Practice Exam use cases and controllers, and Subtopic selection.

### Run the Frontend

```powershell
cd frontend
flutter pub get
flutter run
```

Build the Android release APK:

```powershell
flutter build apk --release
```

Output:

```text
frontend/build/app/outputs/flutter-apk/app-release.apk
```

### Remaining V1 Work

- Persist Practice Exam attempts and selected answers
- Add basic history and attempt details
- Calculate accuracy by Subtopic and Topic
- Link failed exam areas to relevant notes and filtered quizzes
- Add flashcards with simple spaced repetition
- Import Practice Exams and flashcards from JSON
- Improve large imports with progress, duplicate protection, and recovery
- Complete release QA on phones and tablets

---

## Deutsch

### Produktstruktur

Der Study Mode verwendet folgende Hierarchie:

```text
Subject
`-- Topic
    |-- Subtopic
    |   `-- Study Notes
    `-- Topic Quiz
        `-- Nach Subtopic klassifizierte Fragen
```

Vor dem Start eines Topic Quiz koennen ein, mehrere oder alle Subtopics
ausgewaehlt werden. Dadurch sind gezielte Tests und gemischte Wiederholungen mit
demselben Fragenbestand moeglich.

Der Exam Mode verwendet ein getrenntes Modell:

```text
Exam Section
|-- Exam Tips
`-- Practice Exams
    `-- Fragen und Antwortoptionen
```

Practice-Exam-Fragen koennen optional einem Subtopic zugeordnet werden. Diese
Klassifizierung soll spaeter Schwaechen erkennen und direkt zu passenden
Study-Mode-Inhalten fuehren.

### Aktuelle Frontend-Funktionen

- Offline-first Nutzung mit lokaler ToStore-Persistenz
- Subjects, Topics, Subtopics und Markdown Study Notes
- Lokales Erstellen, Bearbeiten und Loeschen von Lerninhalten
- Topic Quiz mit nach Subtopic klassifizierten Fragen
- Auswahl von einem, mehreren oder allen Subtopics vor einem Quiz
- Zufallsreihenfolge fuer Quizfragen und Antworten
- Sofortiges Richtig/Falsch-Feedback und Markdown-Erklaerungen
- Ergebnisbildschirm mit Punktzahl, Prozentwert und Wiederholen
- Keine feste maximale Anzahl von Quizfragen
- Exam Sections und Markdown Exam Tips
- CRUD fuer Practice Exams, Fragen und Antwortoptionen
- Validierung mit mindestens vier Optionen und genau einer richtigen Antwort
- Vollstaendige Practice-Exam-Simulation mit Zurueck/Weiter-Navigation
- Gespeicherte Antworten, direktes Feedback, Erklaerungen und Ergebnis
- JSON-Import ueber Text oder Dateiauswahl
- Neues verschachteltes Subtopic-Format und Kompatibilitaet mit alten Seeds
- Responsive Layouts fuer Smartphone und Tablet
- Light Mode, Dark Mode und eigenes App-Icon
- Riverpod-Provider, Streams und Controller
- Repository-Vertraege mit ToStore-Implementierungen

### JSON-Seed-Import

Das aktuelle Format unterstuetzt Subjects, Topics, Subtopics, Study Notes,
Topic Quizzes, klassifizierte Fragen, Antwortoptionen, optionale
Markdown-Erklaerungen sowie Exam Sections und Exam Tips.

Alte Topics mit direkten `studyNotes` bleiben gueltig. Beim Import werden diese
Notizen einem automatisch erstellten Subtopic `General` zugeordnet. Im neuen
Format verweist jede Quizfrage ueber den exakten Namen auf ein vorhandenes
Subtopic.

Das verbindliche Beispiel befindet sich hier:

- [`frontend/docs/study-seed-subtopics-example.json`](frontend/docs/study-seed-subtopics-example.json)

Practice Exams und Versuche koennen noch nicht aus JSON importiert werden. Ein
erneuter Import desselben Seeds kann Inhalte duplizieren.

### Lokale Datenbank

Das aktuelle Subtopic-Schema verwendet die versionierte lokale Datenbank
`studyflow_v2`. Sie startet bewusst leer, weil die erforderlichen
Subtopic-Fremdschluessel nicht sicher in bereits gefuellte Pre-V1-Tabellen
eingefuegt werden konnten. Alte Datenbankdateien werden nicht geloescht; ihre
Inhalte muessen in das neue JSON-Format konvertiert und erneut importiert werden.

### Architektur

```text
Flutter Screen
-> Riverpod Controller / Application Use Case
-> Repository Contract
-> ToStore Repository
-> Lokale ToStore-Datenbank
```

Das Frontend ist nach Features organisiert:

```text
frontend/lib/
|-- core/                    Gemeinsame Datenbank-, Theme- und UI-Bausteine
|-- features/
|   |-- app_shell/           Start und Modusauswahl
|   |-- exam/                Exam Sections, Tips und Practice Exams
|   |-- quiz/                Topic Quizzes und Quiz-Ablauf
|   |-- seed_import/         JSON-Parsing, Validierung und Import
|   `-- study_content/       Subjects, Topics, Subtopics und Study Notes
`-- main.dart
```

Urspruenglich lagen Modelle, Provider, Controller, Repositories und Screens in
globalen technischen Ordnern. Mit wachsendem Umfang mussten Aenderungen an
einem Ablauf in vielen getrennten Ordnern gesucht werden. Deshalb liegen jetzt
alle Dateien, die zu einem Feature gehoeren und gemeinsam geaendert werden, am
selben Ort.

Groessere Features behalten intern die Schichten `domain`, `data`,
`application` und `presentation`. Gemeinsamer Code kommt nur dann nach `core`,
wenn er tatsaechlich von mehreren Features verwendet wird.

### Backend-Stand

Das ASP.NET-Core-Backend ist in API, Application, Domain und Infrastructure
aufgeteilt. Erste Endpunkte fuer Subjects, Topics und Study Notes sowie EF Core
und PostgreSQL sind vorhanden. Die Backend-Arbeit wird fortgesetzt, sobald die
V1-Modelle, der Practice-Exam-Verlauf und die JSON-Vertraege stabil sind.

### Pruefung und Ausfuehrung

```powershell
cd frontend
flutter pub get
flutter analyze
flutter test
flutter run
```

Release-APK erstellen:

```powershell
flutter build apk --release
```

### Noch offen fuer V1

- Practice-Exam-Versuche und ausgewaehlte Antworten persistieren
- Einfachen Verlauf und Versuchdetails anzeigen
- Accuracy nach Subtopic und Topic berechnen
- Fehler mit passenden Notizen und gefilterten Quizzes verknuepfen
- Karteikarten mit einfacher Spaced Repetition
- Practice Exams und Karteikarten aus JSON importieren
- Grosse Imports mit Fortschritt und Duplikatschutz verbessern
- Release-QA auf Smartphone und Tablet abschliessen
