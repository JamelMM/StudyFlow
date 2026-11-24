# StudyFlow Frontend

The StudyFlow frontend is an offline-first Flutter application for organizing
learning material, running focused quizzes, and practising short exams. It uses
ToStore for local persistence and is intentionally independent from the ASP.NET
Core backend during V1 development.

## English

### Current Features

#### Study Mode

- Create, edit, and delete Subjects, Topics, and Subtopics
- Organize Markdown Study Notes inside Subtopics
- Create one question bank / Quiz for each Topic
- Classify every quiz question with a Subtopic
- Select one, several, or all Subtopics before starting a quiz
- Create and edit Markdown questions, answers, and explanations
- Enforce a single correct answer per question
- Randomize questions and answer options during quiz play
- Show immediate correct/incorrect feedback and explanations
- Navigate through quizzes and view final score and percentage
- Retry a quiz with the same Subtopic selection
- Use quizzes without a fixed question limit

#### Exam Mode

- Create, edit, and delete Exam Sections such as AP1 and AP2
- Create and read Markdown Exam Tips
- Create, edit, and delete Practice Exams
- Configure passing percentage and optional duration
- Create and edit Practice Exam questions and explanations
- Optionally associate exam questions with a Subtopic
- Create, edit, and delete answer options
- Require at least four options and exactly one correct answer
- Run complete Practice Exam simulations offline
- Move backwards and forwards while preserving selected answers
- Show immediate feedback, explanations, final score, and percentage

Attempt persistence and history are the next Exam Mode milestones.

#### Shared Application Features

- Offline ToStore persistence with foreign keys and cascade rules
- Riverpod repository, stream, controller, and use-case providers
- Repository contracts separating UI and persistence
- JSON import from pasted text or a selected `.json` file
- Responsive layouts for phone and tablet orientations
- Light and dark themes
- Markdown rendering
- Custom Android, iOS, and Windows launcher icon
- Shared buttons, empty states, SnackBars, and responsive layout widgets

### App Flow

```text
StartScreen
-> ModeSelectionScreen
   -> Study Mode
      -> SubjectsScreen
         -> TopicsScreen
            -> TopicDetailScreen
               -> SubtopicsScreen
                  -> SubtopicDetailScreen
                     -> StudyNotesScreen
                        -> NoteScreen
               -> QuizzesScreen
                  -> Subtopic selection
                  -> QuizPlayScreen
                     -> QuizResultScreen
                  -> QuizQuestionsScreen
                     -> QuestionDetailScreen
   -> Exam Mode
      -> ExamSectionsScreen
         -> ExamSectionDetailScreen
            -> Exam Tips
            -> Practice Exams
               -> Question and answer management
               -> PracticeExamPlayScreen
                  -> PracticeExamResultScreen
            -> History (planned)
```

### Data Model

```text
Subject 1 --- * Topic
Topic   1 --- * Subtopic
Subtopic 1 -- * StudyNote

Topic 1 ----- 0..1 Quiz
Quiz 1 ------ * Question
Subtopic 1 -- * Question
Question 1 -- * AnswerOption

ExamSection 1 --- * ExamTip
ExamSection 1 --- * PracticeExam
PracticeExam 1 -- * PracticeExamQuestion
PracticeExamQuestion 1 -- * PracticeExamAnswerOption
Subtopic 0..1 --- * PracticeExamQuestion
```

Deleting a Subtopic deletes its Study Notes and regular quiz questions. A
Practice Exam question is preserved and its optional Subtopic reference is set
to `null`.

### Project Structure

```text
frontend/
|-- docs/
|   |-- architecture/
|   |-- screenshots/
|   `-- study-seed-subtopics-example.json
|-- lib/
|   |-- core/
|   |   |-- database/            ToStore setup and schemas
|   |   |-- theme/               Light and dark Material themes
|   |   `-- widgets/             UI shared by multiple features
|   |-- features/
|   |   |-- app_shell/           Startup and mode selection
|   |   |-- exam/                Exam Mode and Practice Exams
|   |   |-- quiz/                Topic quizzes and quiz play
|   |   |-- seed_import/         JSON parsing, validation, and import UI
|   |   `-- study_content/       Subject to Study Note hierarchy
|   `-- main.dart
|-- test/                        Tests grouped by feature
|-- pubspec.yaml
`-- README.md
```

#### Architecture Decision: Feature First

The first implementation used global folders such as `models`, `providers`,
`controllers`, `repositories`, and `screens`. That layout was easy to start
with, but a single product change eventually required navigating through many
folders containing unrelated files.

StudyFlow now groups code by product capability. A developer working on a quiz,
an exam, content management, or seed import can find the complete flow under one
feature. Larger features use the following internal layers:

```text
feature/
|-- domain/         Models and repository contracts
|-- data/           ToStore repository implementations
|-- application/    Controllers, providers, and use cases
`-- presentation/   Screens and feature-specific widgets
```

This is a pragmatic feature-first architecture rather than strict Clean
Architecture. Layer boundaries remain useful, but they serve the product flow
instead of scattering it. `core` is reserved for infrastructure and UI that is
actually shared by more than one feature.

The main data flow is:

```text
Screen
-> Riverpod Controller / Application Use Case
-> Repository Contract
-> ToStore Repository
-> Local Database
```

### JSON Seed Import

The importer currently supports:

- Subjects, Topics, and Subtopics
- Markdown Study Notes inside Subtopics
- One Topic Quiz with questions classified by Subtopic
- Answer options and optional Markdown explanations
- Exam Sections and Markdown Exam Tips

Canonical example:

- [Subtopic seed example](docs/study-seed-subtopics-example.json)

A new-format Topic looks like this:

```json
{
  "name": "Programmiergrundlagen",
  "subtopics": [
    {
      "name": "Objektorientierte Programmierung",
      "studyNotes": []
    }
  ],
  "quiz": {
    "name": "Programmiergrundlagen Quiz",
    "questions": [
      {
        "subtopic": "Objektorientierte Programmierung",
        "markdownText": "What does encapsulation protect?",
        "explanationMarkdown": "It protects the internal object state.",
        "answerOptions": [
          {
            "markdownText": "The internal state",
            "isCorrect": true
          },
          {
            "markdownText": "The package manager",
            "isCorrect": false
          }
        ]
      }
    ]
  }
}
```

Legacy Topics containing `studyNotes` directly remain valid. Their notes are
placed in an automatically created `General` Subtopic. With multiple Subtopics,
every question must name an existing Subtopic from the same Topic.

Practice Exams, attempts, and flashcards are not part of the importer yet.
Reimporting the same seed can duplicate child content. Large imports also do not
show detailed progress yet and should not be interrupted.

### Local Database Version

The Subtopic schema uses `studyflow_v2`. This clean database version was
introduced because ToStore cannot safely add required Subtopic foreign keys to
already populated pre-V1 tables. Existing old database files are not deleted,
but their content is not read by V2 and must be imported through a converted
seed.

### Verification

```powershell
flutter analyze
flutter test
```

The current suite has 26 passing tests. It covers:

- Old and new JSON seed formats
- Optional question explanations
- Unknown Subtopic rejection
- Practice Exam data loading and validation
- Practice Exam controllers
- Subtopic selection behaviour

### Run and Build

```powershell
flutter pub get
flutter run
```

Generate the Android release APK:

```powershell
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The current application version is `1.0.0+1`.

### Next V1 Steps

- Add `ExamAttempt` and `ExamAttemptAnswer`
- Persist completed Practice Exams and selected answers
- Add attempt list and detail screens
- Calculate basic accuracy by Subtopic and Topic
- Recommend relevant notes and filtered Topic Quizzes after mistakes
- Add flashcards with Again, Hard, Good, and Easy
- Import Practice Exams and flashcards from JSON
- Add import progress, duplicate protection, and recoverable errors
- Finish Android phone and tablet release QA

---

## Deutsch

### Aktuelle Funktionen

#### Study Mode

- Subjects, Topics und Subtopics erstellen, bearbeiten und loeschen
- Markdown Study Notes innerhalb von Subtopics organisieren
- Einen gemeinsamen Fragenbestand pro Topic verwalten
- Jede Quizfrage einem Subtopic zuordnen
- Vor dem Quiz ein, mehrere oder alle Subtopics auswaehlen
- Fragen, Antworten und Erklaerungen als Markdown verwalten
- Genau eine richtige Antwort pro Frage sicherstellen
- Fragen und Antwortoptionen zufaellig anordnen
- Direktes Richtig/Falsch-Feedback und Erklaerungen anzeigen
- Ergebnis mit Punktzahl und Prozentwert anzeigen
- Quiz mit derselben Subtopic-Auswahl wiederholen
- Quizze ohne feste maximale Fragenanzahl verwenden

#### Exam Mode

- Exam Sections wie AP1 und AP2 verwalten
- Markdown Exam Tips verwalten
- Practice Exams erstellen, bearbeiten und loeschen
- Bestehensgrenze und optionale Dauer konfigurieren
- Fragen, Erklaerungen und Antwortoptionen verwalten
- Exam-Fragen optional einem Subtopic zuordnen
- Mindestens vier Optionen und genau eine richtige Antwort validieren
- Practice Exams vollstaendig offline durchfuehren
- Mit erhaltenen Antworten vor- und zuruecknavigieren
- Direktes Feedback, Erklaerungen und Endergebnis anzeigen

Die Persistenz von Versuchen und der Verlauf sind die naechsten Meilensteine.

#### Gemeinsame Funktionen

- Lokale ToStore-Persistenz mit Foreign Keys und Cascade-Regeln
- Riverpod-Provider, Streams, Controller und Use Cases
- Repository-Vertraege zwischen UI und Persistenz
- JSON-Import ueber Text oder Dateiauswahl
- Responsive Layouts fuer Smartphone und Tablet
- Light Mode und Dark Mode
- Markdown-Darstellung
- Eigenes App-Icon

### App-Ablauf

```text
StartScreen
-> ModeSelectionScreen
   -> Study Mode
      -> Subjects -> Topics -> Subtopics -> Study Notes
      -> Topic Quiz -> Subtopic-Auswahl -> Quiz -> Ergebnis
   -> Exam Mode
      -> Exam Sections
         -> Tips
         -> Practice Exams -> Simulation -> Ergebnis
         -> History (geplant)
```

### JSON-Import

Das neue Format verwendet die Hierarchie:

```text
Subject -> Topic -> Subtopic -> Study Note
```

Das Topic besitzt weiterhin das Quiz. Jede Quizfrage verweist ueber `subtopic`
auf den exakten Namen eines Subtopics im selben Topic. Das verbindliche Beispiel
befindet sich unter:

- [Subtopic-Seed-Beispiel](docs/study-seed-subtopics-example.json)

Alte Topics mit direkten `studyNotes` bleiben kompatibel. Ihre Notizen werden
beim Import einem automatisch erzeugten Subtopic `General` zugeordnet.

Practice Exams, Versuche und Karteikarten werden noch nicht importiert. Ein
erneuter Import kann untergeordnete Inhalte duplizieren. Grosse Imports zeigen
noch keinen detaillierten Fortschritt und sollten nicht unterbrochen werden.

### Lokale Datenbank

Das aktuelle Schema verwendet `studyflow_v2`. Die neue lokale Datenbank startet
leer, weil erforderliche Subtopic-Fremdschluessel nicht sicher in bereits
gefuellte Pre-V1-Tabellen eingefuegt werden konnten. Alte Datenbankdateien werden
nicht geloescht; ihre Inhalte muessen ueber einen konvertierten Seed erneut
importiert werden.

### Architekturentscheidung: Feature First

Die erste Version verwendete globale Ordner fuer Modelle, Provider, Controller,
Repositories und Screens. Das war am Anfang einfach, fuehrte aber spaeter dazu,
dass eine funktionale Aenderung ueber viele Ordner mit nicht zusammengehoerigen
Dateien verteilt war.

Der Code ist deshalb jetzt nach Produktfunktionen organisiert: `study_content`,
`quiz`, `exam`, `seed_import` und `app_shell`. Groessere Features behalten intern
die Schichten `domain`, `data`, `application` und `presentation`. Dadurch bleibt
die Abhaengigkeitsrichtung nachvollziehbar, waehrend alle Dateien eines Ablaufs
nah beieinander liegen. `core` enthaelt nur Datenbank-, Theme- und UI-Code, der
wirklich von mehreren Features gemeinsam genutzt wird.

Diese Struktur ist bewusst pragmatisch und keine starre Clean Architecture. Sie
soll die Suche nach Dateien vereinfachen, zusammengehoerige Aenderungen buendeln
und neue Funktionen wie Verlauf, Karteikarten und Wiederholungsplanung klar
abgrenzen.

### Pruefung, Start und Build

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

Android-Release-APK erstellen:

```powershell
flutter build apk --release
```

Die aktuelle Testsuite umfasst 26 erfolgreiche Tests. Die App-Version ist
`1.0.0+1`.

### Naechste V1-Schritte

- ExamAttempt und ExamAttemptAnswer einfuehren
- Practice-Exam-Versuche und Antworten persistieren
- Verlaufs- und Detailansicht erstellen
- Accuracy nach Subtopic und Topic berechnen
- Nach Fehlern passende Notizen und gefilterte Quizzes empfehlen
- Karteikarten mit Again, Hard, Good und Easy implementieren
- Practice Exams und Karteikarten per JSON importieren
- Import-Fortschritt und Duplikatschutz hinzufuegen
- Release-QA auf Smartphone und Tablet abschliessen
