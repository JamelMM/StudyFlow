import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/seed_import/application/study_seed_parser.dart';
import 'package:frontend/features/seed_import/application/study_seed_validation.dart';

void main() {
  const parser = StudySeedParser();
  const validation = StudySeedValidation();

  test('wraps legacy topic notes in a General subtopic', () {
    final seed = parser.parse(_legacySeedJson);
    final topic = seed.subjects.single.topics.single;

    expect(topic.subtopics, hasLength(1));
    expect(topic.subtopics.single.name, 'General');
    expect(topic.subtopics.single.studyNotes.single.name, 'Encapsulation');
    expect(topic.quiz!.questions.single.subtopicName, isNull);
    expect(validation.validate(seed), isNull);
  });

  test('parses notes and quiz questions classified by subtopic', () {
    final seed = parser.parse(_subtopicSeedJson);
    final topic = seed.subjects.single.topics.single;

    expect(topic.subtopics.map((subtopic) => subtopic.name), [
      'OOP',
      'Testing',
    ]);
    expect(topic.subtopics.first.studyNotes.single.name, 'Polymorphism');
    expect(topic.quiz!.questions.single.subtopicName, 'OOP');
    expect(validation.validate(seed), isNull);
  });

  test('rejects a quiz question assigned to an unknown subtopic', () {
    final seed = parser.parse(
      _subtopicSeedJson.replaceFirst('"subtopic": "OOP"', '"subtopic": "SQL"'),
    );

    expect(
      validation.validate(seed),
      'Question references unknown subtopic "SQL" in topic "Programming".',
    );
  });
}

const _legacySeedJson = '''
{
  "version": 1,
  "subjects": [
    {
      "name": "Application Development",
      "topics": [
        {
          "name": "Programming",
          "studyNotes": [
            {
              "name": "Encapsulation",
              "markdownText": "# Encapsulation\\n\\nProtects internal state."
            }
          ],
          "quiz": {
            "name": "Programming Quiz",
            "questions": [
              {
                "markdownText": "What protects internal state?",
                "answerOptions": [
                  {"markdownText": "Encapsulation", "isCorrect": true},
                  {"markdownText": "Inheritance", "isCorrect": false}
                ]
              }
            ]
          }
        }
      ]
    }
  ]
}
''';

const _subtopicSeedJson = '''
{
  "version": 1,
  "subjects": [
    {
      "name": "Application Development",
      "topics": [
        {
          "name": "Programming",
          "subtopics": [
            {
              "name": "OOP",
              "studyNotes": [
                {
                  "name": "Polymorphism",
                  "markdownText": "# Polymorphism\\n\\nOne interface, multiple forms."
                }
              ]
            },
            {
              "name": "Testing",
              "studyNotes": []
            }
          ],
          "quiz": {
            "name": "Programming Quiz",
            "questions": [
              {
                "subtopic": "OOP",
                "markdownText": "What describes polymorphism?",
                "explanationMarkdown": "The same interface can have different implementations.",
                "answerOptions": [
                  {"markdownText": "Multiple forms", "isCorrect": true},
                  {"markdownText": "A database index", "isCorrect": false}
                ]
              }
            ]
          }
        }
      ]
    }
  ]
}
''';
