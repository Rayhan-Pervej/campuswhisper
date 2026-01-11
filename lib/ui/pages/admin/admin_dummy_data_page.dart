import 'package:flutter/material.dart';
import 'package:campuswhisper/core/services/dummy_data_service.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';
import 'package:icons_plus/icons_plus.dart';

class AdminDummyDataPage extends StatefulWidget {
  const AdminDummyDataPage({super.key});

  @override
  State<AdminDummyDataPage> createState() => _AdminDummyDataPageState();
}

class _AdminDummyDataPageState extends State<AdminDummyDataPage> {
  final DummyDataService _dummyDataService = DummyDataService();
  bool _isLoading = false;
  Map<String, int>? _addedCounts;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Dummy Data'),
        backgroundColor: colorScheme.surface,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Adding dummy data to Firebase...',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This may take a few moments',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // Warning Card
                  _buildWarningCard(colorScheme),

                  const SizedBox(height: 32),

                  // Info Card
                  _buildInfoCard(colorScheme),

                  const SizedBox(height: 32),

                  // Results Card (if data has been added)
                  if (_addedCounts != null) ...[
                    _buildResultsCard(colorScheme),
                    const SizedBox(height: 24),
                  ],

                  // Add Dummy Data Button
                  DefaultButton(
                    text: 'Add All Dummy Data',
                    press: _addDummyData,
                  ),

                  const SizedBox(height: 16),

                  // Delete All Data Button
                  OutlinedButton.icon(
                    onPressed: _deleteAllData,
                    icon: Icon(
                      Iconsax.trash_outline,
                      color: colorScheme.error,
                    ),
                    label: Text(
                      'Delete All Dummy Data',
                      style: TextStyle(
                        color: colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      side: BorderSide(color: colorScheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildWarningCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.warning_2_outline,
            color: colorScheme.onErrorContainer,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Development Only',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This page is for development purposes only. Remove this page before production deployment.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withAlpha(77),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.info_circle_outline,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'What will be added?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(colorScheme, 'Posts', '30 items'),
          _buildInfoRow(colorScheme, 'Events', '15 items'),
          _buildInfoRow(colorScheme, 'Competitions', '10 items'),
          _buildInfoRow(colorScheme, 'Clubs', '8 items'),
          _buildInfoRow(colorScheme, 'Lost & Found', '15 items'),
          _buildInfoRow(colorScheme, 'Comments', '20 items'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ColorScheme colorScheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(179),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.tick_circle_outline,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Successfully Added',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultRow(
              colorScheme, 'Posts', _addedCounts!['posts'].toString()),
          _buildResultRow(
              colorScheme, 'Events', _addedCounts!['events'].toString()),
          _buildResultRow(colorScheme, 'Competitions',
              _addedCounts!['competitions'].toString()),
          _buildResultRow(
              colorScheme, 'Clubs', _addedCounts!['clubs'].toString()),
          _buildResultRow(colorScheme, 'Lost & Found',
              _addedCounts!['lostFound'].toString()),
          _buildResultRow(
              colorScheme, 'Comments', _addedCounts!['comments'].toString()),
          const SizedBox(height: 8),
          Divider(color: colorScheme.onPrimaryContainer.withAlpha(77)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                _getTotalCount().toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(ColorScheme colorScheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalCount() {
    if (_addedCounts == null) return 0;
    return _addedCounts!.values.fold(0, (sum, count) => sum + count);
  }

  Future<void> _addDummyData() async {
    final confirmed = await DialogHelper.showConfirmation(
      context,
      title: 'Add Dummy Data?',
      message:
          'This will add sample posts, events, clubs, competitions, lost & found items, and comments to Firebase. Continue?',
      confirmText: 'Add Data',
      cancelText: 'Cancel',
    );

    if (!confirmed) return;

    setState(() {
      _isLoading = true;
      _addedCounts = null;
    });

    try {
      final counts = await _dummyDataService.addAllDummyData();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _addedCounts = counts;
        });

        SnackbarHelper.showSuccess(
          context,
          'Successfully added ${_getTotalCount()} items to Firebase!',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        SnackbarHelper.showError(
          context,
          'Failed to add dummy data: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _deleteAllData() async {
    final confirmed = await DialogHelper.showConfirmation(
      context,
      title: 'Delete All Data?',
      message:
          'This will permanently delete all dummy data from Firebase. This action cannot be undone. Continue?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (!confirmed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _dummyDataService.deleteAllDummyData();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _addedCounts = null;
        });

        SnackbarHelper.showSuccess(
          context,
          'All dummy data has been deleted from Firebase',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        SnackbarHelper.showError(
          context,
          'Failed to delete data: ${e.toString()}',
        );
      }
    }
  }
}
