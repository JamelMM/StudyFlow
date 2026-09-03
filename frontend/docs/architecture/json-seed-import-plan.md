# JSON Seed Import Plan

## Goal

Allow StudyFlow to import complete study content from a JSON file.

The goal is to make it possible to prepare subjects, topics, study notes, quizzes, questions, and answer options outside the app and load them into local ToStore persistence in one controlled flow.

This feature should help the app become useful for real study material. For example, notes from school, exam preparation content, or AI-generated summaries could be transformed into a valid JSON structure and imported into StudyFlow.

## Problem It Solves

Right now, content is created manually through the UI.

That is good for learning CRUD flows, but it becomes slow when the user wants to load a complete subject with many topics, notes, and quiz questions.

The JSON import should solve this:

- Faster creation of study material.
- Easier reuse of external notes.
- Better support for exam preparation.
- Clear structure for generating content with AI tools.
- Better testing data for StudyFlow.

## Important Architecture Rule

The import logic should not live inside a Screen.

The Screen should only:

- Let the user choose a JSON file.
- Show loading, success, or error feedback.
- Call a controller or use case.

The import logic should live in the application layer because it is a complete app workflow that touches several entities.

## Suggested Folder Structure

```text
lib/
|-- application/
|   `-- import/
|       |-- import_study_seed.dart
|       |-- study_seed.dart
|       |-- study_seed_parser.dart
|       `-- study_seed_validation.dart
|-- providers/
|   `-- import_study_seed_provider.dart
|-- screens/
|   `-- import_seed_screen.dart
```

This keeps the import feature separated from individual entity controllers.

## Why A Use Case Is Better Than A Controller Here

The import does not belong to only one entity.

It touches:

- Subjects
- Topics
- Study notes
- Quizzes
- Questions
- Answer options

Because it coordinates several repositories, it is better as an application use case:

```text
ImportStudySeed
```

The entity controllers should stay focused:

- `SubjectsController`: create, edit, delete subjects.
- `TopicsController`: create, edit, delete topics.
- `StudyNotesController`: create, edit, delete study notes.
- `QuizzesController`: create, edit, delete quizzes.
- `QuestionsController`: create, edit, delete questions.
- `AnswerOptionsController`: create, edit, delete answer options.

The import use case coordinates all of them at a higher level.

## Suggested JSON Shape

The first version should use a nested structure because it is easy to read and easy to generate.

```json
{
  "version": 1,
  "subjects": [
    {
      "name": "Kommunikationstraining",
      "topics": [
        {
          "name": "Fragetechnik",
          "studyNotes": [
            {
              "name": "Offene Fragen",
              "markdownText": "Offene Fragen helfen, ausführliche Antworten zu bekommen."
            }
          ],
          "quiz": {
            "name": "Fragetechnik Quiz",
            "questions": [
              {
                "markdownText": "Was ist das Ziel einer offenen Frage?",
                "answerOptions": [
                  {
                    "markdownText": "Eine ausführliche Antwort ermöglichen",
                    "isCorrect": true
                  },
                  {
                    "markdownText": "Nur Ja oder Nein als Antwort bekommen",
                    "isCorrect": false
                  }
                ]
              }
            ]
          }
        }
      ]
    }
  ]
}
```

## Why The JSON Should Not Contain IDs In V1

In the first version, the JSON should not provide database IDs.

Reason:

- ToStore already generates IDs.
- It avoids conflicts with existing local data.
- It makes the JSON easier to write.
- It avoids accidental overwrites.

The import use case should create each entity in order and use the generated ID from the previous step.

Example:

```text
create subject -> get generated subjectId
create topic with subjectId -> get generated topicId
create note with topicId
create quiz with topicId -> get generated quizId
create question with quizId -> get generated questionId
create answer option with questionId
```

## Import Flow

```text
ImportSeedScreen
  -> user selects JSON file
  -> reads file as text
  -> calls ImportStudySeed

ImportStudySeed
  -> parses JSON
  -> validates structure
  -> creates subjects
  -> creates topics for each subject
  -> creates study notes for each topic
  -> creates quiz for each topic if present
  -> creates questions for each quiz
  -> creates answer options for each question

ToStore repositories
  -> persist each entity locally

StreamProviders
  -> emit updated lists automatically

Screens
  -> update automatically through ref.watch
```

## Providers Needed

The provider should create the import use case and inject all repositories.

```dart
final importStudySeedProvider = Provider<ImportStudySeed>((ref) {
  return ImportStudySeed(
    subjectsRepository: ref.watch(subjectsRepositoryProvider),
    topicsRepository: ref.watch(topicsRepositoryProvider),
    studyNotesRepository: ref.watch(studyNotesRepositoryProvider),
    quizzesRepository: ref.watch(quizzesRepositoryProvider),
    questionsRepository: ref.watch(questionsRepositoryProvider),
    answerOptionsRepository: ref.watch(answerOptionsRepositoryProvider),
  );
});
```

The Screen would use `ref.read` because importing is an action:

```dart
await ref.read(importStudySeedProvider).call(jsonText);
```

## Repositories Needed

The use case would need access to all repository contracts:

- `SubjectsRepository`
- `TopicsRepository`
- `StudyNotesRepository`
- `QuizzesRepository`
- `QuestionsRepository`
- `AnswerOptionsRepository`

The existing repository methods are almost enough because the app already supports local creation.

Important: the create methods should return the created entity or generated ID where needed.

Example:

```dart
Future<Subject> addSubject(String name);
Future<Topic> addTopic({required String subjectId, required String name});
Future<Quiz> addQuiz({required String topicId, required String name});
Future<Question> addQuestion({
  required String quizId,
  required String markdownText,
});
```

This is important because nested imports need generated IDs.

## Validation Rules

The import should validate before writing data when possible.

Basic validation:

- JSON must be valid.
- `version` must be supported.
- `subjects` must be a list.
- Subject name must not be empty.
- Topic name must not be empty.
- Study note name must not be empty.
- Study note markdown text must not be empty.
- Quiz name must not be empty.
- Question markdown text must not be empty.
- Each question should have at least one answer option.
- Each question should have exactly one correct answer.
- A question should not have more than the configured maximum number of answers.

Later validation:

- Avoid duplicate subject names if needed.
- Avoid duplicate topic names inside the same subject.
- Limit maximum import size.
- Validate markdown length.
- Validate unsupported JSON version.

## Error Handling

The use case should return or throw clear errors.

Good error examples:

```text
Invalid JSON file.
Unsupported seed version.
Subject name cannot be empty.
Topic "Fragetechnik" has a quiz question without answers.
Question "..." must have exactly one correct answer.
```

The Screen should catch errors and show a SnackBar or an error state.

The use case should not use:

- `BuildContext`
- `ScaffoldMessenger`
- `Navigator`

Those belong to the UI layer.

## Transaction Question

Important open question:

```text
Should the import be all-or-nothing?
```

Ideal behavior:

- If the JSON is invalid, import nothing.
- If persistence fails halfway, avoid leaving partial data.

If ToStore supports transactions, the import should use one.

If ToStore does not support transactions yet, V1 can:

- Validate everything before writing.
- Import in a clear order.
- Show a warning if a write fails.
- Later add rollback or transaction support.

## V1 Scope

The first version should stay small.

V1 should support:

- Import from a JSON file.
- Nested subjects -> topics -> notes -> quiz -> questions -> answers.
- No custom IDs in JSON.
- Local ToStore persistence.
- Clear validation errors.
- UI feedback after import.

V1 should not support yet:

- Editing imported JSON inside the app.
- Merging by ID.
- Updating existing data.
- Remote sync.
- Conflict resolution.
- Import history.

## Implementation Steps

1. Define seed data classes.
2. Create parser from JSON text to seed classes.
3. Create validation logic.
4. Create `ImportStudySeed` use case.
5. Create `importStudySeedProvider`.
6. Add a simple import screen or drawer action.
7. Pick a JSON file from the device.
8. Call the use case with `ref.read`.
9. Show success or error feedback.
10. Verify that StreamProviders update the UI automatically.

## Suggested Learning Order

To implement this safely, learn and repeat these ideas:

- `dart:convert`
- `jsonDecode`
- Map access
- Type checking JSON data
- DTO classes
- Validation before persistence
- Use cases that coordinate several repositories
- Error messages from application layer to UI
- File picker basics
- Riverpod provider for application services

## Example Mental Model

```text
JSON file
  -> raw text
  -> jsonDecode
  -> seed DTOs
  -> validation
  -> ImportStudySeed use case
  -> repository contracts
  -> ToStore repositories
  -> local database
  -> streams emit new state
  -> screens update automatically
```

## Why This Feature Matters

This is not just a convenience feature.

It proves that StudyFlow is becoming a real app because it can handle structured external data and transform it into local domain data.

It also connects well with future AI workflows:

```text
notes or exam material
  -> AI converts to StudyFlow JSON
  -> StudyFlow imports it
  -> user studies with notes, quizzes, study mode, and exam mode
```

## Later Improvements

- Export existing StudyFlow content as JSON.
- Add import preview before writing.
- Add dry-run validation.
- Add import summary.
- Add duplicate detection.
- Add import history.
- Add rollback support.
- Add backend sync after import.
- Add templates for AI-generated JSON.

