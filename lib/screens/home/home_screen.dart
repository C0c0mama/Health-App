import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
//import '../../constants/app_sizes.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../services/auth_provider.dart';
import '../../services/notification_provider.dart';
import '../../widgets/app_widgets.dart';
import '../main_shell.dart'; // for TabIndex constants

class HomeScreen extends StatelessWidget {
  /// Callback that switches the MainShell's bottom-nav to a given tab index.
  /// Use the TabIndex constants: TabIndex.records, TabIndex.appointments, etc.
  final void Function(int tabIndex) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final firstName = user?.fullName.split(' ').first ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ──
          SliverToBoxAdapter(child: _buildHeader(context, firstName)),

          // ── Quick Access Buttons ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Access', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                ],
              ),
            ),
          ),

          // ── Health Summary Cards ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _buildHealthSummary(),
            ),
          ),

          // ── Upcoming Appointments ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  SectionHeader(
                    title: 'Upcoming Appointments',
                    onSeeAll: () => onTabChange(TabIndex.appointments),
                  ),
                  const SizedBox(height: 12),
                  ..._upcomingAppointments
                      .take(2)
                      .map((a) => _AppointmentPreviewCard(appointment: a)),
                ],
              ),
            ),
          ),

          // ── Announcements ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  const SectionHeader(title: 'Health Announcements'),
                  const SizedBox(height: 12),
                  ...DummyData.announcements.map(
                    (a) => _AnnouncementCard(announcement: a),
                  ),
                ],
              ),
            ),
          ),

          // ── Recent Notifications preview ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Consumer<NotificationProvider>(
                builder: (context, notifProvider, _) {
                  final unread = notifProvider.unreadNotifications
                      .take(2)
                      .toList();
                  if (unread.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      SectionHeader(
                        title: 'Recent Alerts',
                        onSeeAll: () => onTabChange(TabIndex.notifications),
                      ),
                      const SizedBox(height: 12),
                      ...unread.map(
                        (n) => _NotificationPreviewCard(notification: n),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<AppointmentModel> get _upcomingAppointments => DummyData.appointments
      .where((a) => a.status == AppointmentStatus.upcoming)
      .toList();

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, String firstName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting,',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  Text(
                    firstName,
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // Notification bell — taps to Alerts tab
              GestureDetector(
                onTap: () => onTabChange(TabIndex.notifications),
                child: Consumer<NotificationProvider>(
                  builder: (context, notifProvider, _) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      if (notifProvider.unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                notifProvider.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Today's date chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickActionButton(
          icon: Icons.folder_shared_outlined,
          label: 'My\nRecords',
          color: AppColors.primary,
          bgColor: AppColors.primaryLighter,
          onTap: () => onTabChange(TabIndex.records), // → Records tab
        ),
        QuickActionButton(
          icon: Icons.calendar_month_outlined,
          label: 'Book\nAppointment',
          color: AppColors.secondary,
          bgColor: AppColors.secondaryLighter,
          onTap: () => onTabChange(TabIndex.appointments), // → Schedule tab
        ),
        QuickActionButton(
          icon: Icons.vaccines_outlined,
          label: 'Vaccination\nSchedule',
          color: const Color(0xFF8B5CF6),
          bgColor: const Color(0xFFF3EEFF),
          onTap: () => onTabChange(TabIndex.appointments), // → Schedule tab
        ),
        QuickActionButton(
          icon: Icons.campaign_outlined,
          label: 'Health\nAlerts',
          color: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFFFBEB),
          onTap: () => onTabChange(TabIndex.notifications), // → Alerts tab
        ),
      ],
    );
  }

  // ── Health Summary ────────────────────────────────────────────────────────
  Widget _buildHealthSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Health Summary', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChange(TabIndex.records), // → Records tab
                child: HealthStatCard(
                  label: 'Prenatal Visits',
                  value: '3 / 8',
                  icon: Icons.pregnant_woman_rounded,
                  color: AppColors.primary,
                  bgColor: AppColors.primaryLighter,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChange(TabIndex.records), // → Records tab
                child: HealthStatCard(
                  label: 'Vaccinations',
                  value: '2 done',
                  icon: Icons.vaccines_rounded,
                  color: AppColors.secondary,
                  bgColor: AppColors.secondaryLighter,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    onTabChange(TabIndex.appointments), // → Schedule tab
                child: HealthStatCard(
                  label: 'Next Check-up',
                  value: 'In 2 days',
                  icon: Icons.event_available_rounded,
                  color: const Color(0xFF8B5CF6),
                  bgColor: const Color(0xFFF3EEFF),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChange(TabIndex.records), // → Records tab
                child: HealthStatCard(
                  label: 'Gest. Age',
                  value: '28 wks',
                  icon: Icons.child_care_rounded,
                  color: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFFFBEB),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appointment Preview Card
// ─────────────────────────────────────────────────────────────────────────────
class _AppointmentPreviewCard extends StatelessWidget {
  final AppointmentModel appointment;

  const _AppointmentPreviewCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('h:mm a').format(appointment.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Date block
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('EEE').format(appointment.dateTime),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('d').format(appointment.dateTime),
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primary,
                    fontSize: 20,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(appointment.dateTime),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.title,
                  style: AppTextStyles.h3.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(time, style: AppTextStyles.bodySmall),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appointment.doctorName,
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusBadge.upcoming(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Announcement Card
// ─────────────────────────────────────────────────────────────────────────────
class _AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: AppTextStyles.h3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.content,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLighter,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        announcement.category,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d').format(announcement.publishedAt),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Preview Card
// ─────────────────────────────────────────────────────────────────────────────
class _NotificationPreviewCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationPreviewCard({required this.notification});

  IconData get _typeIcon {
    switch (notification.type) {
      case NotificationType.appointment:
        return Icons.calendar_today_rounded;
      case NotificationType.vaccination:
        return Icons.vaccines_rounded;
      case NotificationType.announcement:
        return Icons.campaign_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.white : AppColors.primaryLighter,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notification.isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTextStyles.h3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
