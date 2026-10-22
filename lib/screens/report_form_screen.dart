
import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

const Color trikeRed = Color(0xFFD62828);
const Color trikeYellow = Color(0xFFFFC928);
const Color trikeGreen = Color(0xFF239447);
const Color trikeNavy = Color(0xFF142B45);
const Color trikePale = Color(0xFFFFF9E9);

enum ReportUiState {
  idle,
  loading,
  success,
  empty,
  error,
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;

  String _selectedCategory = 'Driver Availability';

  bool _simulateFailure = false;

  final List<Map<String, String>> _reports = [];

  final List<String> _categories = [
    'Driver Availability',
    'Incorrect Driver Location',
    'Incorrect Driver Information',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _uiState = ReportUiState.loading;
    });

    try {
      // Simulate an asynchronous REST API request.
      await Future<void>.delayed(
        const Duration(seconds: 3),
      );

      if (_simulateFailure) {
        throw Exception('Simulated submission failure');
      }

      if (!mounted) return;

      // Temporary in-memory storage for Activity 9.
      // This does not save anything to a database.
      setState(() {
        _reports.add({
          'title': _titleController.text.trim(),
          'category': _selectedCategory,
          'location': _locationController.text.trim(),
          'description': _descriptionController.text.trim(),
        });

        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.error;
      });
    }
  }

  void _showReports() {
    setState(() {
      _uiState = ReportUiState.empty;
    });
  }

  void _returnToForm() {
    setState(() {
      _uiState = ReportUiState.idle;
    });
  }

  void _clearForm() {
    _formKey.currentState?.reset();

    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedCategory = 'Driver Availability';
      _simulateFailure = false;
      _uiState = ReportUiState.idle;
    });
  }

  void _retrySubmission() {
    // Turn off the simulated failure and retry
    // with the values already entered in the form.
    setState(() {
      _simulateFailure = false;
      _uiState = ReportUiState.idle;
    });

    _submitReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: trikePale,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: trikeNavy,
        elevation: 1,
        title: const Row(
          children: [
            Icon(
              Icons.electric_rickshaw_rounded,
              color: trikeRed,
            ),
            SizedBox(width: 10),
            Text(
              'TRIKEFIND',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Close report form',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 650,
              ),
              child: _buildCurrentState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_uiState) {
      case ReportUiState.idle:
        return _buildForm();

      case ReportUiState.loading:
        return _buildLoadingState();

      case ReportUiState.success:
        return _buildSuccessState();

      case ReportUiState.empty:
        return _buildReportsState();

      case ReportUiState.error:
        return _buildErrorState();
    }
  }

  Widget _buildForm() {
    return _buildCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 42,
              color: trikeRed,
            ),
            const SizedBox(height: 12),
            const Text(
              'Submit a Report',
              style: TextStyle(
                color: trikeNavy,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Help us maintain accurate tricycle driver '
              'and location information in your barangay.',
              style: TextStyle(
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),

            // Reused widget: AppTextField.
            AppTextField(
              controller: _titleController,
              label: 'Report Title',
              hint: 'Enter a short report title',
              prefixIcon: Icons.title_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a report title.';
                }
                if (value.trim().length < 3) {
                  return 'Title must contain at least 3 characters.';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),
            _buildLabel('Report Category'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDecoration(
                'Select a category',
                Icons.category_outlined,
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            // Reused widget: AppTextField.
            AppTextField(
              controller: _locationController,
              label: 'Barangay / Location',
              hint: 'Enter the barangay or location',
              prefixIcon: Icons.location_on_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the location.';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            // Reused widget: AppTextField.
            AppTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Explain the issue or provide details',
              prefixIcon: Icons.description_outlined,
              minLines: 3,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description.';
                }
                if (value.trim().length < 10) {
                  return 'Please provide at least 10 characters.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: trikeRed,
              value: _simulateFailure,
              onChanged: (value) {
                setState(() {
                  _simulateFailure = value ?? false;
                });
              },
              title: const Text(
                'Simulate an error for testing',
                style: TextStyle(
                  color: trikeNavy,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text(
                'For the Activity 9 demonstration only.',
                style: TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 12),

            // Reused widget: AppButton.
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Submit Report',
                fullWidth: true,
                backgroundColor: trikeRed,
                icon: Icons.send_rounded,
                onPressed: _submitReport,
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showReports,
                icon: const Icon(Icons.inbox_outlined),
                label: const Text('View Reports'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: trikeGreen,
                  side: const BorderSide(color: trikeGreen),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Activity 9 demo: submissions are simulated.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return _buildCard(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: trikeRed,
            strokeWidth: 4,
          ),
          const SizedBox(height: 24),
          const Text(
            'Submitting Report...',
            style: TextStyle(
              color: trikeNavy,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please wait while TRIKEFIND processes '
            'your report.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const LinearProgressIndicator(
            color: trikeGreen,
            backgroundColor: trikePale,
          ),
          const SizedBox(height: 20),
          const Text(
            'Simulated loading state',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    final latestReport = _reports.isNotEmpty
        ? _reports.last
        : <String, String>{};

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: trikeGreen,
              size: 75,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Report Submitted!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: trikeNavy,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your report passed the simulated submission '
            'process. It is stored temporarily in this app '
            'session only, not in a database.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (latestReport.isNotEmpty) ...[
            _buildDetailRow(
              'Title',
              latestReport['title'] ?? '',
            ),
            _buildDetailRow(
              'Category',
              latestReport['category'] ?? '',
            ),
            _buildDetailRow(
              'Location',
              latestReport['location'] ?? '',
            ),
            _buildDetailRow(
              'Description',
              latestReport['description'] ?? '',
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Submit Another Report',
              fullWidth: true,
              backgroundColor: trikeGreen,
              icon: Icons.add_rounded,
              onPressed: _clearForm,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: _showReports,
              child: const Text(
                'View Reports',
                style: TextStyle(color: trikeNavy),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsState() {
    return _buildCard(
      child: Column(
        children: [
          Icon(
            _reports.isEmpty
                ? Icons.inbox_outlined
                : Icons.description_outlined,
            color: _reports.isEmpty ? trikeYellow : trikeGreen,
            size: 78,
          ),
          const SizedBox(height: 18),
          Text(
            _reports.isEmpty
                ? 'No Reports Available'
                : 'Submitted Reports',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: trikeNavy,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _reports.isEmpty
                ? 'There are currently no reports in this demo. '
                    'Submit a report to see it appear here.'
                : 'There are ${_reports.length} report(s) '
                    'available in this demo.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          if (_reports.isNotEmpty)
            ..._reports.map(
              (report) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.description_outlined,
                  color: trikeGreen,
                ),
                title: Text(report['title'] ?? ''),
                subtitle: Text(
                  '${report['category']} • ${report['location']}',
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Create a Report',
              fullWidth: true,
              backgroundColor: trikeRed,
              icon: Icons.add_rounded,
              onPressed: _returnToForm,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return _buildCard(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: trikeRed,
            size: 78,
          ),
          const SizedBox(height: 18),
          const Text(
            'Submission Failed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: trikeNavy,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'A simulated error occurred while submitting '
            'your report. Your form information is still '
            'available. You can retry or correct your input.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Retry Submission',
              fullWidth: true,
              backgroundColor: trikeRed,
              icon: Icons.refresh_rounded,
              onPressed: _retrySubmission,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _returnToForm,
            child: const Text(
              'Return to Form',
              style: TextStyle(color: trikeNavy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE4ECF0),
        ),
        boxShadow: [
          BoxShadow(
            color: trikeNavy.withValues(alpha: 0.07),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: trikeNavy,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: trikeGreen,
      ),
      filled: true,
      fillColor: const Color(0xFFFFFCF4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFDCE5E8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFDCE5E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: trikeGreen,
          width: 1.8,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: trikeRed,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: trikeRed,
          width: 1.8,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: trikeGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: trikeNavy,
              height: 1.4,
            ),
          ),
          const Divider(height: 18),
        ],
      ),
    );
  }
}
