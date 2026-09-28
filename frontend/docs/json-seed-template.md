# StudyFlow JSON Seed Template

Use this template to prepare study content that can be imported into StudyFlow.

The JSON seed can create:

- Subjects
- Topics
- Study notes
- Quizzes
- Questions
- Answer options
- Exam sections
- Exam tips and recommendations

StudyFlow reuses existing subjects and topics when their names match after normalization. This means that `WISO`, `Wiso`, and `wiso` are treated as the same subject.

## Rules

- The root object must contain `version`.
- `version` must currently be `1`.
- `subjects` and `examSections` are optional lists.
- At least one of those lists must contain data.
- Each subject needs a non-empty `name`.
- Each subject needs at least one topic.
- Each topic needs a non-empty `name`.
- `studyNotes` can be an empty list.
- `quiz` can be `null` or omitted if the topic has no quiz yet.
- Each quiz needs at least one question.
- Each question needs at least one answer option.
- Each question should have exactly one correct answer.
- Do not provide IDs. StudyFlow creates IDs locally.

## Exam Mode Template

Use this structure to import exam sections and their tips. Existing exam
sections are reused when their names match without regard to capitalization.

```json
{
  "version": 1,
  "examSections": [
    {
      "name": "AP1",
      "tips": [
        {
          "name": "Time management",
          "markdownText": "## Before starting\n\nRead all tasks and assign time to each section."
        }
      ]
    }
  ]
}
```

Rules:

- Each exam section needs a non-empty `name`.
- `tips` can be empty or omitted.
- Every tip needs `name` and `markdownText`.
- `markdownText` supports the same Markdown formatting as study notes.
- Reimporting a section reuses the section but creates the tips again.
- Practice exams are not part of the seed format yet.

## AI Prompt For Exam Mode JSON

```text
Convert the following exam preparation material into a valid StudyFlow JSON seed.

Return only valid JSON. Do not include explanations outside the JSON.

Use exactly this structure:

{
  "version": 1,
  "examSections": [
    {
      "name": "Exam section name",
      "tips": [
        {
          "name": "Short tip title",
          "markdownText": "## Markdown heading\n\nConcise advice in Markdown."
        }
      ]
    }
  ]
}

Rules:
- Do not create IDs.
- Use version 1.
- Use only these field names: version, examSections, name, tips, markdownText.
- Make every tip atomic: one clear recommendation per tip.
- Use useful Markdown headings and lists.
- Put a blank line between a Markdown heading and its content.
- Do not use trailing commas.

Exam preparation material:

[PASTE MATERIAL HERE]
```

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
- Create enough atomic study notes to cover the important concepts of the material.
- Create as many quiz questions as necessary to help the user master the topic.
- Create at least 5 questions when the material contains enough information.
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

## AI Prompt With Fixed Subject And Topic

Use this prompt when you already know where the material belongs.

This is usually better than asking the AI to organize everything by itself. You decide the knowledge structure, and the AI only transforms the material into notes, quiz questions, and answer options.

```text
Convert the following learning material into a valid StudyFlow JSON seed.

Use this subject and topic exactly:

Subject: [SUBJECT NAME]
Topic: [TOPIC NAME]

Return only valid JSON. Do not include explanations outside the JSON.

Rules:
- Do not create IDs.
- Use version: 1.
- Use exactly the provided subject name.
- Use exactly the provided topic name.
- Do not create additional subjects.
- Do not create additional topics.
- Create enough atomic study notes to cover the important concepts of the material.
- Each study note must have name and markdownText.
- Create one quiz for the topic.
- Create as many quiz questions as necessary to help the user master the topic.
- Create at least 5 questions when the material contains enough information.
- Prefer clear, practical questions that test understanding, not only memorization.
- Each question must have 4 answer options.
- Each question must have exactly 1 correct answer.
- Use isCorrect: true only for the correct answer.
- Use isCorrect: false for all other answers.
- Use only these field names: version, subjects, name, topics, studyNotes, markdownText, quiz, questions, answerOptions, isCorrect.
- Return valid JSON with no trailing commas.

Use this exact JSON structure:

{
  "version": 1,
  "subjects": [
    {
      "name": "[SUBJECT NAME]",
      "topics": [
        {
          "name": "[TOPIC NAME]",
          "studyNotes": [],
          "quiz": {
            "name": "[TOPIC NAME] Quiz",
            "questions": []
          }
        }
      ]
    }
  ]
}

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

- The import screen supports pasted JSON and JSON files.
- Subjects and topics are reused by name.
- Exam sections are reused by name.
- Study notes, quizzes, questions, and answer options are currently imported as new content.
- Exam tips are currently imported as new content.
- Practice exams are not imported yet.
- Import rollback is not implemented yet.
