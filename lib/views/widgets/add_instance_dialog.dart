import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/vanilla_version_provider.dart';
import '../../providers/installation_provider.dart';
import '../../src/rust/api/settings_manager.dart';
import '../../theme/colors.dart';
import 'import_dialog.dart';

class AddInstanceDialog extends HookConsumerWidget {
  const AddInstanceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 480,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Instance',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: tabController,
              indicatorColor: AppColors.primaryAccent,
              labelColor: AppColors.primaryAccent,
              unselectedLabelColor: AppColors.textSecondary,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Vanilla'),
                Tab(text: 'Import Modpack'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  _VanillaTab(),
                  _ImportTab(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VanillaTab extends HookConsumerWidget {
  const _VanillaTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync = ref.watch(vanillaVersionProvider);
    final selectedVersion = useState<String?>(null);
    final instanceNameController = useTextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: instanceNameController,
          style: const TextStyle(color: AppColors.textPrimary),
          cursorColor: AppColors.primaryAccent,
          decoration: InputDecoration(
            labelText: 'Instance Name',
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.searchBarBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        versionsAsync.when(
          data: (versions) {
            return DropdownButtonFormField<String>(
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              menuMaxHeight: 300,
              decoration: InputDecoration(
                labelText: 'Minecraft Version',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.searchBarBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              value: selectedVersion.value,
              items: versions.map((v) {
                return DropdownMenuItem(
                  value: v,
                  child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
                );
              }).toList(),
              onChanged: (val) => selectedVersion.value = val,
            );
          },
          loading: () => Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 24, height: 24, 
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryAccent)
              )
            ),
          ),
          error: (err, stack) => Text('Error loading versions: $err', style: const TextStyle(color: Colors.redAccent)),
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: AppColors.background,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            disabledBackgroundColor: AppColors.dividerColor,
          ),
          onPressed: selectedVersion.value != null && instanceNameController.text.isNotEmpty
              ? () async {
                  final name = instanceNameController.text.trim();
                  if (name.isEmpty) return;
                  
                  final settings = await loadSettings();
                  final targetPath = [settings.instanceDir, name].join(Platform.pathSeparator);
                  
                  if (context.mounted) {
                      Navigator.of(context).pop();
                  }
                  
                  ref.read(installationProgressProvider.notifier).startVanillaInstallation(
                    name,
                    targetPath,
                    selectedVersion.value!,
                  );
                }
              : null,
          child: const Text('Create Instance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _ImportTab extends HookConsumerWidget {
  const _ImportTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.archive_outlined, size: 48, color: AppColors.primaryAccent),
        ),
        const SizedBox(height: 24),
        const Text(
          'Import an existing modpack layout\nfrom a local Zip or MrPack archive.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.folder_open),
          label: const Text('Browse Archive'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.searchBarBackground,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['zip', 'mrpack'],
            );

            if (result != null && result.files.single.path != null) {
              final String path = result.files.single.path!;
              if (context.mounted) {
                Navigator.of(context).pop(); 
                
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return ImportDialog(zipPath: path);
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}
