import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/log_provider.dart';
import '../theme/colors.dart';
import 'package:file_picker/file_picker.dart';

class LogReaderView extends ConsumerWidget {
  const LogReaderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logContentProvider);
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Application Logs',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.getDirectoryPath(
                    dialogTitle: 'Select Export Destination for app_logs.txt',
                  );
                  if (result != null) {
                    await exportAppLogsTo(result);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logs successfully exported to $result\\import_log.txt'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export Logs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Dark terminal background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: ListView.builder(
                reverse: true, // Newest logs at bottom if we reverse the list in UI
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  // We reverse because reverse:true builds from bottom to top
                  final reversedIndex = logs.length - 1 - index;
                  return SelectableText(
                    logs[reversedIndex],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFFA1C281), // Console green
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
