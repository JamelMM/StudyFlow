import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/seed_import/application/study_seed_parser.dart';
import 'package:frontend/features/seed_import/application/study_seed_validation.dart';

void main() {
  const parser = StudySeedParser();
  const validation = StudySeedValidation();

  test('parses an optional question explanation', () {
    final seed = parser.parse(
      _seedJson(
        explanationProperty:
            '"explanationMarkdown": "## Erklärung\\n\\nWeil B richtig ist.",',
      ),
    );

    final question = seed.subjects.single.topics.single.quiz!.questions.single;

    expect(question.explanationMarkdown, '## Erklärung\n\nWeil B richtig ist.');
    expect(validation.validate(seed), isNull);
  });

  test('keeps questions without explanations valid', () {
    final seed = parser.parse(_seedJson());

    final question = seed.subjects.single.topics.single.quiz!.questions.single;

    expect(question.explanationMarkdown, isNull);
    expect(validation.validate(seed), isNull);
  });

  test('rejects a blank question explanation', () {
    final seed = parser.parse(
      _seedJson(explanationProperty: '"explanationMarkdown": "   ",'),
    );

    expect(
      validation.validate(seed),
      'Question explanation cannot be empty in quiz "Basics Quiz".',
    );
  });
}

String _seedJson({String explanationProperty = ''}) {
  return '''
  {
    "version": 1,
    "subjects": [
      {
        "name": "Anwendungsentwicklung",
        "topics": [
          {
            "name": "Programmiergrundlagen",
            "studyNotes": [],
            "quiz": {
              "name": "Basics Quiz",
              "questions": [
                {
                  "markdownText": "Welche Antwort ist richtig?",
                  $explanationProperty
                  "answerOptions": [
                    {
                      "markdownText": "Antwort A",
                      "isCorrect": false
                    },
                    {
                      "markdownText": "Antwort B",
                      "isCorrect": true
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
  ''';
}
