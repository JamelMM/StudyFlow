# StudyFlow JSON Seed Template

Use this template to prepare study content that can be imported into StudyFlow.

The JSON seed can create:

- Subjects
- Topics
- Study notes
- Quizzes
- Questions
- Answer options

StudyFlow reuses existing subjects and topics when their names match after normalization. This means that `WISO`, `Wiso`, and `wiso` are treated as the same subject.

## Rules

- The root object must contain `version` and `subjects`.
- `version` must currently be `1`.
- `subjects` must be a list.
- Each subject needs a non-empty `name`.
- Each subject needs at least one topic.
- Each topic needs a non-empty `name`.
- `studyNotes` can be an empty list.
- `quiz` can be `null` or omitted if the topic has no quiz yet.
- Each quiz needs at least one question.
- Each question needs at least one answer option.
- Each question should have exactly one correct answer.
- Do not provide IDs. StudyFlow creates IDs locally.

## Empty Template

```json
{
  "version": 1,
  "subjects": [
    {
      "name": "Subject name",
      "topics": [
        {
          "name": "Topic name",
          "studyNotes": [
            {
              "name": "Note title",
              "markdownText": "Note content in Markdown."
            }
          ],
          "quiz": {
            "name": "Quiz name",
            "questions": [
              {
                "markdownText": "Question text",
                "answerOptions": [
                  {
                    "markdownText": "Correct answer",
                    "isCorrect": true
                  },
                  {
                    "markdownText": "Wrong answer",
                    "isCorrect": false
                  },
                  {
                    "markdownText": "Wrong answer",
                    "isCorrect": false
                  },
                  {
                    "markdownText": "Wrong answer",
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

## Topic Without Quiz

Use `quiz: null` when a topic has notes but no quiz yet.

```json
{
  "version": 1,
  "subjects": [
    {
      "name": "Anwendungsentwicklung",
      "topics": [
        {
          "name": "Clean Architecture",
          "studyNotes": [
            {
              "name": "Layer rule",
              "markdownText": "Inner layers should not depend on outer implementation details."
            }
          ],
          "quiz": null
        }
      ]
    }
  ]
}
```

## Complete Example

```json
{
  "version": 1,
  "subjects": [
    {
      "name": "WISO",
      "topics": [
        {
          "name": "Arbeitsrecht",
          "studyNotes": [
            {
              "name": "Kuendigung",
              "markdownText": "Eine Kuendigung beendet ein Arbeitsverhaeltnis. Sie muss rechtliche Fristen und Formvorschriften beachten."
            },
            {
              "name": "Probezeit",
              "markdownText": "Die Probezeit ist eine Anfangsphase des Arbeitsverhaeltnisses. In dieser Zeit gelten oft kuerzere Kuendigungsfristen."
            }
          ],
          "quiz": {
            "name": "Arbeitsrecht Quiz",
            "questions": [
              {
                "markdownText": "Was beendet eine Kuendigung?",
                "answerOptions": [
                  {
                    "markdownText": "Ein Arbeitsverhaeltnis",
                    "isCorrect": true
                  },
                  {
                    "markdownText": "Eine Rechnung",
                    "isCorrect": false
                  },
                  {
                    "markdownText": "Eine Datenbankverbindung",
                    "isCorrect": false
                  }
                ]
              },
              {
                "markdownText": "Was ist die Probezeit?",
                "answerOptions": [
                  {
                    "markdownText": "Eine Anfangsphase des Arbeitsverhaeltnisses",
                    "isCorrect": true
                  },
                  {
                    "markdownText": "Ein Urlaubsanspruch",
                    "isCorrect": false
                  },
                  {
                    "markdownText": "Eine Steuerart",
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

## AI Prompt For Creating StudyFlow JSON

Copy this prompt into an AI tool together with your notes.

```text
Convert the following learning material into a valid StudyFlow JSON seed.

Return only valid JSON. Do not include explanations outside the JSON.

Use exactly this JSON structure:

{
  "version": 1,
  "subjects": [
    {
      "name": "Subject name",
      "topics": [
        {
          "name": "Topic name",
          "studyNotes": [
            {
              "name": "Note title",
              "markdownText": "Note content in Markdown."
            }
          ],
          "quiz": {
            "name": "Quiz name",
            "questions": [
              {
                "markdownText": "Question text",
                "answerOptions": [
                  {
                    "markdownText": "Correct answer",
                    "isCorrect": true
                  },
                  {
                    "markdownText": "Wrong answer",
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

Rules:
- Do not create IDs.
- Use version: 1.
- Use only these field names: version, subjects, name, topics, studyNotes, markdownText, quiz, questions, answerOptions, isCorrect.
- Create clear and short subject names.
- Create clear topic names.
- Create atomic study notes, not very long notes.
- Each study note must have name and markdownText.
- quiz can be null only if there is not enough material to create questions.
- Each quiz must have at least 1 question.
- Each question must have 4 answer options.
- Each question must have exactly 1 correct answer.
- Use isCorrect: true only for the correct answer.
- Use isCorrect: false for all other answers.
- Keep markdownText concise but useful.
- Do not use trailing commas.

Learning material:

[PASTE MATERIAL HERE]
```

## Mental Model

```text
External notes
  -> AI or manual conversion
  -> StudyFlow JSON seed
  -> Import screen
  -> ImportStudySeed use case
  -> repositories
  -> ToStore
  -> StreamProviders update the UI
```

## Current Limitations

- The first import screen uses pasted JSON.
- File picker support is planned later.
- Subjects and topics are reused by name.
- Study notes, quizzes, questions, and answer options are currently imported as new content.
- Import rollback is not implemented yet.
