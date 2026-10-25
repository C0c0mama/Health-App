// lib/screens/appointments/appointments_screen.dart
// Appointment Tracking - Upcoming, Completed, Cancelled

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../widgets/app_widgets.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
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

  List<AppointmentModel> _filterAppointments(AppointmentStatus status) {
    return DummyData.appointments.where((a) => a.status == status).toList();
  }

  List<AppointmentModel> get _upcomingAndPending =>
      DummyData.appointments
          .where(
            (a) =>
                a.status == AppointmentStatus.upcoming ||
                a.status == AppointmentStatus.pending,
          )
          .toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Schedule'),
        backgroundColor: AppColors.white,
        actions: [
          // Book appointment FAB-style button in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _showBookingSheet(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Book'),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryLighter,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.labelLarge.copyWith(fontSize: 13),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Upcoming'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _upcomingAndPending.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Tab(text: 'Completed'),
            const Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AppointmentList(
            appointments: _upcomingAndPending,
            emptyMessage: 'No upcoming appointments',
            emptySubtext: 'Book an appointment at the Barangay Health Center',
          ),
          _AppointmentList(
            appointments: _filterAppointments(AppointmentStatus.completed),
            emptyMessage: 'No completed appointments',
            emptySubtext: 'Completed appointments will appear here',
          ),
          _AppointmentList(
            appointments: _filterAppointments(AppointmentStatus.cancelled),
            emptyMessage: 'No cancelled appointments',
            emptySubtext: 'Cancelled appointments will appear here',
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BookingBottomSheet(),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Appointment List
// ──────────────────────────────────────────────────────────────────────────────
class _AppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final String emptyMessage;
  final String emptySubtext;

  const _AppointmentList({
    required this.appointments,
    required this.emptyMessage,
    required this.emptySubtext,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_rounded,
        title: emptyMessage,
        subtitle: emptySubtext,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: appointments.length,
      itemBuilder: (context, index) => _AppointmentCard(
        appointment: appointments[index],
        onTap: () => _showAppointmentDetails(context, appointments[index]),
      ),
    );
  }

  void _showAppointmentDetails(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AppointmentDetailSheet(appointment: appointment),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Appointment Card
// ──────────────────────────────────────────────────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;

  const _AppointmentCard({required this.appointment, required this.onTap});

  Color get _typeColor {
    switch (appointment.type) {
      case AppointmentType.prenatal:
        return AppColors.primary;
      case AppointmentType.vaccination:
        return AppColors.secondary;
      case AppointmentType.checkup:
        return const Color(0xFF8B5CF6);
      case AppointmentType.consultation:
        return const Color(0xFFF59E0B);
    }
  }

  IconData get _typeIcon {
    switch (appointment.type) {
      case AppointmentType.prenatal:
        return Icons.pregnant_woman_rounded;
      case AppointmentType.vaccination:
        return Icons.vaccines_rounded;
      case AppointmentType.checkup:
        return Icons.monitor_heart_rounded;
      case AppointmentType.consultation:
        return Icons.medical_services_outlined;
    }
  }

  StatusBadge get _statusBadge {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return StatusBadge.upcoming();
      case AppointmentStatus.completed:
        return StatusBadge.completed();
      case AppointmentStatus.cancelled:
        return StatusBadge.cancelled();
      case AppointmentStatus.pending:
        return StatusBadge.pending();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Color bar top
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: _typeColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top row: icon + title + status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_typeIcon, color: _typeColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.title,
                              style: AppTextStyles.h3,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _typeColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                appointment.typeLabel,
                                style: AppTextStyles.caption.copyWith(
                                  color: _typeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _statusBadge,
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Details row
                  Row(
                    children: [
                      _DetailItem(
                        icon: Icons.calendar_today_rounded,
                        text: DateFormat(
                          'MMM d, y',
                        ).format(appointment.dateTime),
                      ),
                      const SizedBox(width: 16),
                      _DetailItem(
                        icon: Icons.access_time_rounded,
                        text: DateFormat('h:mm a').format(appointment.dateTime),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _DetailItem(
                        icon: Icons.person_outline_rounded,
                        text: appointment.doctorName,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _DetailItem(
                        icon: Icons.location_on_outlined,
                        text: appointment.location,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Appointment Detail Bottom Sheet
// ──────────────────────────────────────────────────────────────────────────────
class _AppointmentDetailSheet extends StatelessWidget {
  final AppointmentModel appointment;

  const _AppointmentDetailSheet({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(appointment.title, style: AppTextStyles.h1),
          const SizedBox(height: 4),
          Text(
            appointment.typeLabel,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          InfoRow(
            label: 'Date',
            value: DateFormat('EEEE, MMMM d, y').format(appointment.dateTime),
          ),
          InfoRow(
            label: 'Time',
            value: DateFormat('h:mm a').format(appointment.dateTime),
          ),
          InfoRow(label: 'Doctor / Nurse', value: appointment.doctorName),
          InfoRow(label: 'Location', value: appointment.location),
          if (appointment.notes != null)
            InfoRow(
              label: 'Notes',
              value: appointment.notes!,
              showDivider: false,
            ),
          const SizedBox(height: 24),
          if (appointment.status == AppointmentStatus.upcoming)
            AppOutlinedButton(
              label: 'Cancel Appointment',
              onPressed: () => Navigator.pop(context),
              icon: Icons.cancel_outlined,
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Book Appointment Bottom Sheet (simplified UI)
// ──────────────────────────────────────────────────────────────────────────────
class _BookingBottomSheet extends StatefulWidget {
  const _BookingBottomSheet();

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  String _selectedType = 'Prenatal Check-up';

  final List<String> _types = [
    'Prenatal Check-up',
    'Vaccination',
    'Weight Monitoring',
    'General Consultation',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Book Appointment', style: AppTextStyles.h1),
          const SizedBox(height: 4),
          Text(
            'Barangay Pampang Health Center',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text('Appointment Type', style: AppTextStyles.labelLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types.map((type) {
              final selected = _selectedType == type;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    type,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Walk-ins accepted every Wednesday 8AM–12PM. For specific schedules, visit the Barangay Health Center.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'Request Appointment',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Appointment request submitted!'),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            icon: Icons.check_circle_outline_rounded,
          ),
        ],
      ),
    );
  }
}
