import 'package:flutter/material.dart';
import 'package:frontend/screens/subject_screen.dart';
import 'package:frontend/widgets/mode_card.dart';
import 'package:frontend/screens/import_seed_screen.dart';
import 'package:frontend/widgets/responsive_layout.dart';

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
          final crossAxisCount = ResponsiveBreakpoints.isTabletOrWider(
            constraints.maxWidth,
          )
              ? 2
              : 1;
          final isShortScreen = constraints.maxHeight < 620;
          final cardAspectRatio = crossAxisCount == 1
              ? (isShortScreen ? 2.2 : 1.35)
              : 1.15;

          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Align(
                  alignment: const Alignment(0, -0.25),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      padding: EdgeInsets.all(
                        ResponsiveBreakpoints.horizontalPadding(
                          constraints.maxWidth,
                        ),
                      ),
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: cardAspectRatio,
                      children: [
                        ModeCard(
                          icon: Icons.menu_book,
                          title: 'Study Mode',
                          subtitle: 'Review topic, notes and practice',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const SubjectScreen()),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
