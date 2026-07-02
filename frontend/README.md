# StudyFlow Frontend

This folder contains the Flutter frontend for StudyFlow.

The current frontend is a local prototype. It uses local example data and is not connected to the ASP.NET Core backend yet.

## Current Features

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
- Reusable layout and list item widgets
- SnackBar feedback for local actions

## App Flow

```text
SubjectsScreen
-> TopicsScreen
-> StudyNotesScreen
-> NoteScreen
```

## Project Structure

```text
lib/
|-- data/
|   `-- example_data.dart
|-- models/
|   |-- subject.dart
|   |-- topic.dart
|   `-- study_note.dart
|-- screens/
|   |-- subject_screen.dart
|   |-- topics_screen.dart
|   |-- study_notes_screen.dart
|   |-- note_screen.dart
|   |-- new_subject.dart
|   |-- new_topic.dart
|   `-- new_study_note.dart
`-- widgets/
    |-- corner_lines.dart
    |-- studyflow_screen_body.dart
    `-- study_notes/
        `-- study_note_list_item.dart
```

## Tech Stack

- Dart
- Flutter
- Material Design
- Local example data
- StatefulWidget and setState for local state
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

The frontend is intentionally local-first at this stage. The goal of this sprint is to understand Flutter fundamentals, screen navigation, local state, forms, list rendering, and basic UI structure before connecting the app to the backend.

## Next Steps

- Improve local creation forms
- Refine local state handling
- Add better empty states and validation
- Prepare API service classes
- Connect the Flutter frontend to the ASP.NET Core backend
