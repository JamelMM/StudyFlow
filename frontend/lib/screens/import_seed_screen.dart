import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/import_study_seed_provider.dart';

class ImportSeedScreen extends ConsumerStatefulWidget {
  const ImportSeedScreen({super.key});

  @override
  ConsumerState<ImportSeedScreen> createState() {
    return _ImportSeedScreenState();
  }
}

class _ImportSeedScreenState extends ConsumerState<ImportSeedScreen> {
  final _jsonController = TextEditingController();

  bool _isImporting = false;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  Future<void> _importSeed() async {
    final jsonText = _jsonController.text.trim();

    if (jsonText.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paste a JSON seed before importing.')),
      );

      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      await ref.read(importStudySeedProvider).call(jsonText);

      if (!mounted) {
        return;
      }

      _jsonController.clear();

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Seed imported successfully.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xFF2F855A),
        ),
      );
    } on FormatException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message, textAlign: TextAlign.center)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not import seed.', textAlign: TextAlign.center),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import JSON Seed')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _jsonController,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'JSON seed',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isImporting ? null : _importSeed,
                child: _isImporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Import seed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
