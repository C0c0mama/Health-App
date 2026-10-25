// lib/data/dummy_data.dart
// Static dummy data for MVP frontend demonstration
// Replace with actual API calls when backend is ready

import '../models/models.dart';

class DummyData {
  DummyData._();

  // ── Current User ──────────────────────────────────────────────────────────
  static const UserModel currentUser = UserModel(
    id: 'user_001',
    fullName: 'Maria Santos',
    email: 'maria.santos@email.com',
    phone: '09171234567',
    address: 'Purok 3, Barangay Pampang, Angeles City',
    birthDate: 'March 15, 1995',
    bloodType: 'O+',
    role: 'patient',
  );

  // ── Appointments ──────────────────────────────────────────────────────────
  static List<AppointmentModel> appointments = [
    AppointmentModel(
      id: 'apt_001',
      title: '4th Prenatal Check-up',
      doctorName: 'Dr. Liza Reyes',
      location: 'Barangay Health Center, Pampang',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 9)),
      status: AppointmentStatus.upcoming,
      type: AppointmentType.prenatal,
      notes: 'Bring previous lab results and health booklet.',
    ),
    AppointmentModel(
      id: 'apt_002',
      title: 'BCG Vaccination - Baby Juan',
      doctorName: 'Nurse Ana Dela Cruz',
      location: 'Barangay Health Center, Pampang',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 10)),
      status: AppointmentStatus.upcoming,
      type: AppointmentType.vaccination,
      notes: 'Baby should be healthy. No fever.',
    ),
    AppointmentModel(
      id: 'apt_003',
      title: 'Monthly Weight Monitoring',
      doctorName: 'Nurse Ana Dela Cruz',
      location: 'Barangay Health Center, Pampang',
      dateTime: DateTime.now().add(const Duration(days: 14, hours: 8)),
      status: AppointmentStatus.pending,
      type: AppointmentType.checkup,
    ),
    AppointmentModel(
      id: 'apt_004',
      title: '3rd Prenatal Check-up',
      doctorName: 'Dr. Liza Reyes',
      location: 'Barangay Health Center, Pampang',
      dateTime: DateTime.now().subtract(const Duration(days: 30)),
      status: AppointmentStatus.completed,
      type: AppointmentType.prenatal,
      notes: 'All vitals normal. BP: 110/70. Weight: 58 kg.',
    ),
    AppointmentModel(
      id: 'apt_005',
      title: 'General Consultation',
      doctorName: 'Dr. Mark Cruz',
      location: 'Barangay Health Center, Pampang',
      dateTime: DateTime.now().subtract(const Duration(days: 45)),
      status: AppointmentStatus.completed,
      type: AppointmentType.consultation,
    ),
    AppointmentModel(
      id: 'apt_006',
      title: 'Pentavalent 1st Dose',
      doctorName: 'Nurse Ana Dela Cruz',
      location: 'Barangay Health Center, Pampang',
      dateTime: DateTime.now().subtract(const Duration(days: 15)),
      status: AppointmentStatus.cancelled,
      type: AppointmentType.vaccination,
      notes: 'Rescheduled due to baby fever.',
    ),
  ];

  // ── Notifications ─────────────────────────────────────────────────────────
  static List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_001',
      title: 'Upcoming Prenatal Check-up',
      message:
          'Your 4th prenatal check-up with Dr. Liza Reyes is scheduled tomorrow at 9:00 AM. Please bring your health booklet.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      type: NotificationType.appointment,
    ),
    NotificationModel(
      id: 'notif_002',
      title: 'Vaccination Reminder',
      message:
          'Baby Juan\'s BCG vaccination is due in 5 days. Please ensure baby is healthy before the appointment.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      type: NotificationType.vaccination,
    ),
    NotificationModel(
      id: 'notif_003',
      title: 'Free Vitamins Distribution',
      message:
          'Free prenatal vitamins and iron supplements will be distributed at the Barangay Health Center on Friday, 8AM-12PM. Please bring your health booklet.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: NotificationType.announcement,
    ),
    NotificationModel(
      id: 'notif_004',
      title: 'Health Check Records Updated',
      message:
          'Your prenatal check-up record for your 3rd visit has been updated by Dr. Liza Reyes.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.system,
    ),
    NotificationModel(
      id: 'notif_005',
      title: 'Dengue Prevention Drive',
      message:
          'Barangay Pampang will conduct a clean-up drive and fumigation on Saturday. Residents are advised to clean surroundings.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      type: NotificationType.announcement,
    ),
    NotificationModel(
      id: 'notif_006',
      title: 'Appointment Confirmed',
      message:
          'Your appointment for monthly weight monitoring on June 24 at 8:00 AM has been confirmed.',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
      type: NotificationType.appointment,
    ),
  ];

  // ── Health Records ────────────────────────────────────────────────────────
  static const MaternalHealthSummary maternalSummary = MaternalHealthSummary(
    patientName: 'Maria Santos',
    lmpDate: 'September 15, 2024',
    eddDate: 'June 22, 2025',
    gravida: 2,
    para: 1,
    bloodType: 'O+',
    isHighRisk: false,
    allergies: ['Penicillin'],
    currentWeight: '60 kg',
    height: '158 cm',
  );

  static List<PrenatalRecord> prenatalRecords = [
    PrenatalRecord(
      id: 'pn_001',
      visitNumber: 3,
      visitDate: DateTime.now().subtract(const Duration(days: 30)),
      doctorName: 'Dr. Liza Reyes',
      bloodPressure: '110/70',
      weight: 58.0,
      gestationalAge: 24,
      fetalHeartRate: '140 bpm',
      notes:
          'Normal progression. Fundal height 24 cm. Iron supplement prescribed.',
    ),
    PrenatalRecord(
      id: 'pn_002',
      visitNumber: 2,
      visitDate: DateTime.now().subtract(const Duration(days: 60)),
      doctorName: 'Dr. Liza Reyes',
      bloodPressure: '112/72',
      weight: 56.5,
      gestationalAge: 20,
      fetalHeartRate: '138 bpm',
      notes: 'Anatomy scan normal. Position: Cephalic. All organs visible.',
    ),
    PrenatalRecord(
      id: 'pn_003',
      visitNumber: 1,
      visitDate: DateTime.now().subtract(const Duration(days: 90)),
      doctorName: 'Dr. Mark Cruz',
      bloodPressure: '110/68',
      weight: 54.0,
      gestationalAge: 16,
      fetalHeartRate: '142 bpm',
      notes:
          'Initial prenatal visit. CBC and urinalysis ordered. Multivitamins prescribed.',
    ),
  ];

  static List<VaccinationRecord> vaccinationRecords = [
    VaccinationRecord(
      id: 'vac_001',
      vaccineName: 'Tetanus Toxoid (TT)',
      dose: '2nd Dose',
      dateGiven: DateTime.now().subtract(const Duration(days: 45)),
      administeredBy: 'Nurse Ana Dela Cruz',
      isCompleted: true,
    ),
    VaccinationRecord(
      id: 'vac_002',
      vaccineName: 'Tetanus Toxoid (TT)',
      dose: '1st Dose',
      dateGiven: DateTime.now().subtract(const Duration(days: 75)),
      administeredBy: 'Nurse Ana Dela Cruz',
      isCompleted: true,
    ),
    VaccinationRecord(
      id: 'vac_003',
      vaccineName: 'BCG (Baby Juan)',
      dose: '1st Dose',
      dateGiven: DateTime.now().add(const Duration(days: 5)),
      administeredBy: 'Scheduled',
      isCompleted: false,
      nextDueDate: DateTime.now().add(const Duration(days: 5)),
    ),
    VaccinationRecord(
      id: 'vac_004',
      vaccineName: 'Hepatitis B (Baby Juan)',
      dose: 'Birth Dose',
      dateGiven: DateTime.now().subtract(const Duration(days: 120)),
      administeredBy: 'Hospital Staff',
      isCompleted: true,
    ),
  ];

  // ── Announcements ─────────────────────────────────────────────────────────
  static List<AnnouncementModel> announcements = [
    AnnouncementModel(
      id: 'ann_001',
      title: 'Free Prenatal Vitamins Distribution',
      content:
          'Free prenatal vitamins and iron supplements will be given at the Barangay Health Center. Bring your health booklet.',
      category: 'Health Services',
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      postedBy: 'Brgy. Health Center',
    ),
    AnnouncementModel(
      id: 'ann_002',
      title: 'Immunization Day – Every Wednesday',
      content:
          'Vaccination services for infants and pregnant women are available every Wednesday 8AM–12PM. No appointment needed.',
      category: 'Vaccination',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      postedBy: 'Brgy. Health Center',
    ),
    AnnouncementModel(
      id: 'ann_003',
      title: 'Dengue Awareness Campaign',
      content:
          '4S strategy: Search and destroy mosquito breeding sites, Self-protective measures, Seek early consultation, Support fogging.',
      category: 'Health Advisory',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      postedBy: 'Brgy. Pampang Officials',
    ),
  ];
}
