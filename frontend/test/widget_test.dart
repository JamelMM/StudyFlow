import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/subtopic.dart';
import 'package:frontend/screens/quiz_subtopic_selection_sheet.dart';

void main() {
  testWidgets('subtopic selection requires at least one selection', (
    tester,
  ) async {
    final subtopics = [
      Subtopic(
        id: 'subtopic-1',
        topicId: 'topic-1',
        name: 'OOP',
        createdAt: DateTime(2026),
      ),
      Subtopic(
        id: 'subtopic-2',
        topicId: 'topic-1',
        name: 'Testing',
        createdAt: DateTime(2026),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: QuizSubtopicSelectionSheet(subtopics: subtopics)),
      ),
    );

    expect(find.text('OOP'), findsOneWidget);
    expect(find.text('Testing'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Clear all'));
    await tester.pump();

    expect(find.text('Select all'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}
