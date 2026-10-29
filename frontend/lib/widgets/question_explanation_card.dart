
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class QuestionExplanationCard extends StatelessWidget {
  const QuestionExplanationCard({
    super.key,
    required this.explanationMarkdown,
    this.margin,
  });

  final String explanationMarkdown;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: margin,
      color: colorScheme.secondaryContainer,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Explanation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              MarkdownBody(
                data: explanationMarkdown,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
