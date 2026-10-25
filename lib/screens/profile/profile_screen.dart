import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_sizes.dart';
import '../../services/auth_provider.dart';
import '../../widgets/app_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.white,
      ),
      body: ListView(
        children: [
          // ── Profile Header ──
          _buildProfileHeader(user?.fullName ?? 'User', user?.email ?? ''),
          const SizedBox(height: 20),

          // ── Personal Info ──
          _buildSection(
            title: 'Personal Information',
            children: [
              _ProfileTile(
                icon: Icons.person_outline_rounded,
                label: 'Full Name',
                value: user?.fullName ?? '—',
              ),
              _ProfileTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user?.email ?? '—',
              ),
              _ProfileTile(
                icon: Icons.phone_outlined,
                label: 'Mobile Number',
                value: user?.phone ?? '—',
              ),
              _ProfileTile(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: user?.address ?? '—',
              ),
              _ProfileTile(
                icon: Icons.cake_outlined,
                label: 'Date of Birth',
                value: user?.birthDate ?? '—',
              ),
              _ProfileTile(
                icon: Icons.bloodtype_outlined,
                label: 'Blood Type',
                value: user?.bloodType ?? '—',
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Settings ──
          _buildSection(
            title: 'Settings',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: 'Notification Preferences',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                label: 'Change Password',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.language_outlined,
                label: 'Language',
                trailing: const Text(
                  'English',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                onTap: () => _showComingSoon(context),
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── App Info ──
          _buildSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                trailing: const Text(
                  'v1.0.0',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.local_hospital_outlined,
                label: 'Barangay Health Center',
                trailing: const Text(
                  'Pampang',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                onTap: () {},
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Edit Profile Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppOutlinedButton(
              label: 'Edit Profile',
              onPressed: () => _showComingSoon(context),
              icon: Icons.edit_outlined,
            ),
          ),
          const SizedBox(height: 12),

          // ── Logout Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text('Log Out', style: AppTextStyles.buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────────────────────────
  Widget _buildProfileHeader(String name, String email) {
    final initials = name
        .split(' ')
        .map((n) => n.isNotEmpty ? n[0] : '')
        .take(2)
        .join();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                initials.toUpperCase(),
                style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(name, style: AppTextStyles.h1.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Registered Patient',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section wrapper ───────────────────────────────────────────────────────
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(title, style: AppTextStyles.h3),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This feature will be available soon.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Logout — confirms then calls auth_provider.logout() ──────────────────
  // auth_provider sets isAuthenticated = false → Auth Gate in main.dart
  // automatically swaps MainShell → LoginScreen. No Navigator.push needed.
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
        title: Text('Log Out', style: AppTextStyles.h2),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // 1. Close the dialog first
              Navigator.pop(ctx);
              // 2. Call logout — clears isAuthenticated + currentUser
              // 3. AuthProvider notifies listeners
              // 4. Consumer<AuthProvider> in main.dart rebuilds
              // 5. Auth Gate returns LoginScreen → MainShell is destroyed
              // 6. Back button can no longer return to any authenticated screen
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Profile Tile (read-only info row)
// ──────────────────────────────────────────────────────────────────────────────
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(value, style: AppTextStyles.labelLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 46, endIndent: 16),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Settings Tile (tappable row)
// ──────────────────────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          title: Text(label, style: AppTextStyles.labelLarge),
          trailing:
              trailing ??
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
        ),
        if (showDivider) const Divider(height: 1, indent: 56, endIndent: 16),
      ],
    );
  }
}
