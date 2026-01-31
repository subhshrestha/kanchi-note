import 'package:flutter/material.dart';

class DuplicateWarningDialog extends StatelessWidget {
  final String phrase;

  const DuplicateWarningDialog({
    super.key,
    required this.phrase,
  });

  static Future<void> show(BuildContext context, String phrase) {
    return showDialog<void>(
      context: context,
      builder: (context) => DuplicateWarningDialog(phrase: phrase),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          const Text('Duplicate Phrase'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('The phrase "$phrase" already exists in your dictionary.'),
          const SizedBox(height: 12),
          const Text('Please enter a different phrase.'),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
