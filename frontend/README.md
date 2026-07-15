# StudyFlow Frontend

This folder contains the Flutter frontend for StudyFlow.

The current frontend is a local-first prototype. It uses repository contracts with ToStore-backed local persistence and is not connected to the ASP.NET Core backend yet.

## Current Features

- Start screen before entering the main StudyFlow flow
- View subjects
- Create subjects locally
- View topics for a selected subject
- Create topics locally
- View study notes for a selected topic
- Create study notes locally
- Delete study notes locally
- Open a study note and read its content
- Basic Material Design UI
- Custom color scheme
- Local repository layer for subjects, topics, and study notes
- ToStore-backed local persistence for subjects, topics, and study notes
- Repository contracts for local-first data access
- String-based IDs prepared for ToStore and backend integration
- Dependency registration with get_it
- Reusable layout, list item, and empty state widgets
- SnackBar feedback for local actions
  
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
-> StudyNotesScreen
-> NoteScreen
```

## Project Structure

```text
lib/
|-- core/
|   `-- service_locator.dart
|-- data/
|   `-- example_data.dart
|-- local/
|   |-- tostore/
|   |   |-- studyflow_database.dart
|   |   |-- studyflow_schemas.dart
|   |   |-- tostore_subjects_repository.dart
|   |   |-- tostore_topics_repository.dart
|   |   `-- tostore_study_notes_repository.dart
|   |-- local_subjects_repository.dart
|   |-- local_topics_repository.dart
|   `-- local_study_notes_repository.dart
|-- models/
|   |-- subject.dart
|   |-- topic.dart
|   `-- study_note.dart
|-- repositories/
|   `-- contracts/
|       |-- subjects_repository.dart
|       |-- topics_repository.dart
|       `-- study_notes_repository.dart
|-- screens/
|   |-- start_screen.dart
|   |-- subject_screen.dart
|   |-- topics_screen.dart
|   |-- study_notes_screen.dart
|   |-- note_screen.dart
|   |-- new_subject.dart
|   |-- new_topic.dart
|   `-- new_study_note.dart
`-- widgets/
    |-- corner_lines.dart
    |-- empty_state_message.dart
    |-- studyflow_screen_body.dart
    `-- study_notes/
        `-- study_note_list_item.dart
 
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

Screens access data through repository contracts, and the active implementations use ToStore for local persistence. Subjects, topics, and study notes can be created locally. Study notes can also be deleted locally.

The frontend models use string-based IDs to prepare the app for later backend synchronization.

## Next Steps

- Continue refining ToStore persistence and repository structure
- Add edit flows for existing study notes
- Improve form validation
- Add quizzes and questions
- Prepare API service classes
- Connect the Flutter frontend to the ASP.NET Core backend
- Add synchronization between local data and backend data

