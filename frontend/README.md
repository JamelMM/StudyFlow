# StudyFlow Frontend

This folder contains the Flutter frontend for StudyFlow.

The current frontend is a local-first prototype. It uses repository contracts with ToStore-backed local persistence and is not connected to the ASP.NET Core backend yet.

## Current Features

- Start screen before entering the main StudyFlow flow
- View subjects
- Create subjects locally
- View topics for a selected subject
- Create topics locally
- Open topics in a dedicated topic detail screen
- Switch between notes and quiz area with a bottom navigation bar
- View study notes for a selected topic
- Create study notes locally
- Delete study notes locally
- Open a study note and read its content
- Basic Material Design UI
- Custom color scheme
- ToStore-backed local persistence for subjects, topics, study notes, quizzes, questions, and answer options
- Repository contracts for local-first data access
- String-based IDs prepared for ToStore and backend integration
- Dependency registration with get_it
- Reusable list item and empty state widgets
- SnackBar feedback for local actions
- Local quiz model with questions and answer options
- Create quiz questions locally
- Create answer options for quiz questions
- Mark answer options as correct
- Manage quiz questions and answer options
- Start a quiz and answer questions
- Visual feedback for correct and incorrect quiz answers

## Screenshots

Current work-in-progress Flutter UI using local-first ToStore persistence.

<p>
  <img src="docs/screenshots/start-screen.png" alt="Start screen" width="220">
  <img src="docs/screenshots/subjects-screen.png" alt="Subjects screen" width="220">
  <img src="docs/screenshots/topics-screen.png" alt="Topics screen" width="220">
  <img src="docs/screenshots/study-notes-screen.png" alt="Study notes screen" width="220">
  <img src="docs/screenshots/note-detail-screen.png" alt="Note detail screen" width="220">
</p>

## Empty States

Screens shown when there is no local data yet.

<p>
  <img src="docs/screenshots/subjects-empty-screen.png" width="180" />
  <img src="docs/screenshots/topics-empty-screen.png" width="180" />
  <img src="docs/screenshots/study-notes-empty-screen.png" width="180" />
</p>

## App Flow

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

## Project Structure

```text
lib/
|-- core/
|   `-- service_locator.dart
|-- local/
|   `-- tostore/
|       |-- studyflow_database.dart
|       |-- studyflow_schemas.dart
|       |-- tostore_subjects_repository.dart
|       |-- tostore_topics_repository.dart
|       |-- tostore_study_notes_repository.dart
|       |-- tostore_quizzes_repository.dart
|       |-- tostore_questions_repository.dart
|       `-- tostore_answer_options_repository.dart
|-- models/
|   |-- subject.dart
|   |-- topic.dart
|   |-- study_note.dart
|   |-- quiz.dart
|   |-- question.dart
|   `-- answer_option.dart
|-- repositories/
|   `-- contracts/
|-- screens/
|-- widgets/
 
```

## Tech Stack

- Dart
- Flutter
- Material Design
- ToStore for local persistence
- Repository pattern with local ToStore implementations
- get_it for dependency registration
- StatefulWidget and setState for local UI state
- Flutter Navigator for screen navigation

## Run Locally

Install dependencies:

```powershell
flutter pub get
```

Analyze the project:

```powershell
flutter analyze
```

Run the app:

```powershell
flutter run
```

## Current Status

The frontend is intentionally local-first at this stage.

Screens access data through repository contracts, and the active implementations use ToStore for local persistence. Subjects, topics, study notes, quizzes, questions, and answer options can be created locally. Study notes can also be deleted locally.

The quiz area now has a first usable local flow. Users can create quiz questions, add answer options, mark correct answers, start the quiz, select answers, and receive visual feedback for correct and incorrect answers.

The frontend models use string-based IDs to prepare the app for later backend synchronization.

## Next Steps

- Improve quiz play results and add a summary screen
- Add edit/delete flows for quiz questions and answer options
- Add validation to ensure each question has one correct answer
- Improve form validation
- Add edit flows for existing study notes
- Prepare API service classes
- Connect the Flutter frontend to the ASP.NET Core backend
- Add synchronization between local data and backend data
- Refactor StudyNotesScreen into an internal StudyNotesView

