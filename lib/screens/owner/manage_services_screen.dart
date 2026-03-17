import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  @override
  Widget build(BuildContext context) {
    final services = MockData.services;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Services', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddServiceSheet(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _ManageableServiceCard(
            service: service,
            onEdit: () => _showAddServiceSheet(context, service: service),
            onToggle: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddServiceSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Service'),
      ),
    );
  }

  void _showAddServiceSheet(BuildContext context, {ServiceModel? service}) {
    final isEditing = service != null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xxl,
          right: AppSpacing.xxl,
          top: AppSpacing.xxl,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                isEditing ? 'Edit Service' : 'Add New Service',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xxl),
              GgTextField(
                label: 'Service Name',
                hint: 'e.g. Oil Change',
                controller: TextEditingController(text: service?.name ?? ''),
              ),
              const SizedBox(height: AppSpacing.lg),
              GgTextField(
                label: 'Description',
                hint: 'Describe the service...',
                maxLines: 3,
                controller: TextEditingController(text: service?.description ?? ''),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: GgTextField(
                      label: 'Price (\$)',
                      hint: '0.00',
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: service?.price.toStringAsFixed(2) ?? '',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: GgTextField(
                      label: 'Duration (min)',
                      hint: '30',
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: service?.estimatedMinutes.toString() ?? '',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              GgTextField(
                label: 'Category',
                hint: 'Select category',
                readOnly: true,
                onTap: () {},
                suffix: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                controller: TextEditingController(text: service?.category ?? ''),
              ),
              const SizedBox(height: AppSpacing.xxl),
              GgButton(
                label: isEditing ? 'Update Service' : 'Add Service',
                onPressed: () => Navigator.pop(context),
              ),
              if (isEditing) ...[
                const SizedBox(height: AppSpacing.sm),
                GgButton(
                  label: 'Delete Service',
                  color: AppColors.error,
                  isOutlined: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManageableServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const _ManageableServiceCard({
    required this.service,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.build_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: AppTextStyles.subtitle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(service.formattedPrice, style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(width: AppSpacing.md),
                    Text('• ${service.formattedDuration}', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: service.isActive,
            activeThumbColor: AppColors.primary,
            onChanged: (_) => onToggle(),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}