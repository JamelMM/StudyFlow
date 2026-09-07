import 'package:flutter/material.dart';
import 'package:frontend/screens/subject_screen.dart';
import 'package:frontend/widgets/mode_card.dart';
import 'package:frontend/screens/import_seed_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyFlow'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImportSeedScreen(),
                ),
              );
            },
            icon: const Icon(Icons.upload_file),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 700 ? 2 : 1;

          return Align(
            alignment: const Alignment(0, -0.35),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: crossAxisCount,
                padding: const EdgeInsets.all(24),
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: crossAxisCount == 1 ? 1.3 : 1.3,
                children: [
                  ModeCard(
                    icon: Icons.menu_book,
                    title: 'Study Mode',
                    subtitle: 'Review topic, notes and practice',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SubjectScreen()),
                        ),
                      );
                    },
                  ),
                  ModeCard(
                    icon: Icons.quiz,
                    title: 'Exam Mode',
                    subtitle: 'Simulate a full exam',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
