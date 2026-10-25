// lib/screens/records/records_screen.dart
// Digital Health Records - Maternal, Prenatal, Vaccination

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
//import '../../constants/app_text_styles.dart' show AppSizes;
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../widgets/app_widgets.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Health Records'),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.labelLarge.copyWith(fontSize: 13),
          unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Maternal'),
            Tab(text: 'Prenatal'),
            Tab(text: 'Vaccination'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_MaternalTab(), _PrenatalTab(), _VaccinationTab()],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MATERNAL HEALTH TAB
// ══════════════════════════════════════════════════════════════════════════════
class _MaternalTab extends StatelessWidget {
  const _MaternalTab();

  @override
  Widget build(BuildContext context) {
    final summary = DummyData.maternalSummary;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Profile banner
        _buildProfileBanner(summary),
        const SizedBox(height: 20),

        // Pregnancy info
        _buildSection(
          title: 'Pregnancy Information',
          icon: Icons.pregnant_woman_rounded,
          color: AppColors.primary,
          child: Column(
            children: [
              InfoRow(label: 'Last Menstrual Period', value: summary.lmpDate),
              InfoRow(label: 'Est. Due Date', value: summary.eddDate),
              InfoRow(label: 'Gravida', value: summary.gravida.toString()),
              InfoRow(label: 'Para', value: summary.para.toString()),
              InfoRow(
                label: 'Risk Level',
                value: summary.isHighRisk ? 'High Risk ⚠️' : 'Low Risk ✓',
                showDivider: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Physical info
        _buildSection(
          title: 'Physical Information',
          icon: Icons.monitor_weight_outlined,
          color: AppColors.secondary,
          child: Column(
            children: [
              InfoRow(label: 'Blood Type', value: summary.bloodType),
              InfoRow(label: 'Current Weight', value: summary.currentWeight),
              InfoRow(label: 'Height', value: summary.height),
              InfoRow(
                label: 'Allergies',
                value: summary.allergies.isEmpty
                    ? 'None'
                    : summary.allergies.join(', '),
                showDivider: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Risk indicator
        _buildRiskCard(summary.isHighRisk),
      ],
    );
  }

  Widget _buildProfileBanner(MaternalHealthSummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              summary.patientName.split(' ').map((n) => n[0]).take(2).join(),
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.patientName,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Maternal Health Record',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'G${summary.gravida} P${summary.para}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(title, style: AppTextStyles.h3),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard(bool isHighRisk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighRisk
            ? const Color(0xFFFEF2F2)
            : AppColors.secondaryLighter,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighRisk
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.secondaryLight.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isHighRisk ? Icons.warning_rounded : Icons.verified_rounded,
            color: isHighRisk ? AppColors.error : AppColors.secondary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHighRisk ? 'High Risk Pregnancy' : 'Normal Pregnancy',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isHighRisk ? AppColors.error : AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHighRisk
                      ? 'Requires close monitoring. Please attend all scheduled check-ups.'
                      : 'Progressing normally. Keep up with regular check-ups.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PRENATAL HISTORY TAB
// ══════════════════════════════════════════════════════════════════════════════
class _PrenatalTab extends StatelessWidget {
  const _PrenatalTab();

  @override
  Widget build(BuildContext context) {
    final records = DummyData.prenatalRecords;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLighter,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.timeline, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prenatal Visit History',
                    style: AppTextStyles.labelLarge,
                  ),
                  Text(
                    '${records.length} visits completed',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Timeline
        ...records.asMap().entries.map(
          (entry) => _PrenatalCard(
            record: entry.value,
            isLast: entry.key == records.length - 1,
          ),
        ),
      ],
    );
  }
}

class _PrenatalCard extends StatelessWidget {
  final PrenatalRecord record;
  final bool isLast;

  const _PrenatalCard({required this.record, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLighter,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${record.visitNumber}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Card content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Visit ${record.visitNumber}',
                        style: AppTextStyles.h3.copyWith(fontSize: 15),
                      ),
                      Text(
                        DateFormat('MMM d, y').format(record.visitDate),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(record.doctorName, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // Vitals grid
                  Row(
                    children: [
                      _VitalChip(label: 'BP', value: record.bloodPressure),
                      const SizedBox(width: 8),
                      _VitalChip(label: 'Weight', value: '${record.weight} kg'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _VitalChip(
                        label: 'GA',
                        value: '${record.gestationalAge} wks',
                      ),
                      const SizedBox(width: 8),
                      _VitalChip(label: 'FHR', value: record.fetalHeartRate),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    record.notes,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VitalChip extends StatelessWidget {
  final String label;
  final String value;

  const _VitalChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// VACCINATION TAB
// ══════════════════════════════════════════════════════════════════════════════
class _VaccinationTab extends StatelessWidget {
  const _VaccinationTab();

  @override
  Widget build(BuildContext context) {
    final records = DummyData.vaccinationRecords;
    final completed = records.where((r) => r.isCompleted).length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Progress banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vaccination Progress',
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed / ${records.length} administered',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: completed / records.length,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 5,
                    ),
                  ),
                  Text(
                    '${((completed / records.length) * 100).round()}%',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Vaccination cards
        ...records.map((v) => _VaccinationCard(record: v)),
      ],
    );
  }
}

class _VaccinationCard extends StatelessWidget {
  final VaccinationRecord record;

  const _VaccinationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: record.isCompleted
              ? AppColors.secondaryLight.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: record.isCompleted
                  ? AppColors.secondaryLighter
                  : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              record.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
              color: record.isCompleted
                  ? AppColors.secondary
                  : AppColors.textMuted,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.vaccineName,
                  style: AppTextStyles.h3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(record.dose, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.isCompleted
                          ? DateFormat('MMM d, y').format(record.dateGiven)
                          : 'Due: ${DateFormat('MMM d, y').format(record.nextDueDate ?? record.dateGiven)}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                if (record.isCompleted) ...[
                  const SizedBox(height: 2),
                  Text(
                    'By: ${record.administeredBy}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),
          ),
          record.isCompleted
              ? StatusBadge.completed()
              : StatusBadge(
                  label: 'Scheduled',
                  color: AppColors.statusPending,
                  bgColor: const Color(0xFFFFFBEB),
                ),
        ],
      ),
    );
  }
}
