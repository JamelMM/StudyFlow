import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/import_study_seed_provider.dart';
import 'package:frontend/widgets/app_snack_bar.dart';
import 'dart:convert';
import 'package:file_selector/file_selector.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(appInfoSnackBar('Paste a JSON seed before importing.'));

      return;
    }

    await _importJsonText(jsonText);
  }

  Future<void> _importJsonText(String jsonText) async {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(appSuccessSnackBar('Seed imported successfully.'));
    } on FormatException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(appErrorSnackBar(error.message));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(appErrorSnackBar('Could not import seed.'));
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  Future<void> _importSeedFromFile() async {
    const jsonTypeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    final selectedFile = await openFile(acceptedTypeGroups: [jsonTypeGroup]);

    if (!mounted || selectedFile == null) {
      return;
    }

    late final String jsonText;

    try {
      final bytes = await selectedFile.readAsBytes();
      jsonText = utf8.decode(bytes).trim();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(appErrorSnackBar('Could not read selected file.'));

      return;
    }

    if (!mounted) {
      return;
    }

    if (jsonText.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(appInfoSnackBar('Selected JSON file is empty.'));

      return;
    }

    await _importJsonText(jsonText);
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
            const SizedBox(height: 32),
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isImporting ? null : _importSeedFromFile,
                  icon: const Icon(Icons.file_open),
                  label: const Text('Import JSON file'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
