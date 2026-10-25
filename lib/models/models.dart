// lib/models/user_model.dart
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String birthDate;
  final String bloodType;
  final String? profileImageUrl;
  final String role; // 'patient' | 'admin'

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.bloodType,
    this.profileImageUrl,
    this.role = 'patient',
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// lib/models/appointment_model.dart
// ──────────────────────────────────────────────────────────────────────────────
enum AppointmentStatus { upcoming, completed, cancelled, pending }

enum AppointmentType { prenatal, vaccination, checkup, consultation }

class AppointmentModel {
  final String id;
  final String title;
  final String doctorName;
  final String location;
  final DateTime dateTime;
  final AppointmentStatus status;
  final AppointmentType type;
  final String? notes;

  const AppointmentModel({
    required this.id,
    required this.title,
    required this.doctorName,
    required this.location,
    required this.dateTime,
    required this.status,
    required this.type,
    this.notes,
  });

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.pending:
        return 'Pending';
    }
  }

  String get typeLabel {
    switch (type) {
      case AppointmentType.prenatal:
        return 'Prenatal';
      case AppointmentType.vaccination:
        return 'Vaccination';
      case AppointmentType.checkup:
        return 'Check-up';
      case AppointmentType.consultation:
        return 'Consultation';
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// lib/models/notification_model.dart
// ──────────────────────────────────────────────────────────────────────────────
enum NotificationType { appointment, vaccination, announcement, system }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      type: type,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// lib/models/health_record_model.dart
// ──────────────────────────────────────────────────────────────────────────────
class VaccinationRecord {
  final String id;
  final String vaccineName;
  final String dose;
  final DateTime dateGiven;
  final String administeredBy;
  final bool isCompleted;
  final DateTime? nextDueDate;

  const VaccinationRecord({
    required this.id,
    required this.vaccineName,
    required this.dose,
    required this.dateGiven,
    required this.administeredBy,
    required this.isCompleted,
    this.nextDueDate,
  });
}

class PrenatalRecord {
  final String id;
  final int visitNumber;
  final DateTime visitDate;
  final String doctorName;
  final String bloodPressure;
  final double weight;
  final int gestationalAge; // in weeks
  final String fetalHeartRate;
  final String notes;

  const PrenatalRecord({
    required this.id,
    required this.visitNumber,
    required this.visitDate,
    required this.doctorName,
    required this.bloodPressure,
    required this.weight,
    required this.gestationalAge,
    required this.fetalHeartRate,
    required this.notes,
  });
}

class MaternalHealthSummary {
  final String patientName;
  final String lmpDate; // Last Menstrual Period
  final String eddDate; // Estimated Due Date
  final int gravida; // Number of pregnancies
  final int para; // Number of deliveries
  final String bloodType;
  final bool isHighRisk;
  final List<String> allergies;
  final String currentWeight;
  final String height;

  const MaternalHealthSummary({
    required this.patientName,
    required this.lmpDate,
    required this.eddDate,
    required this.gravida,
    required this.para,
    required this.bloodType,
    required this.isHighRisk,
    required this.allergies,
    required this.currentWeight,
    required this.height,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// lib/models/announcement_model.dart
// ──────────────────────────────────────────────────────────────────────────────
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime publishedAt;
  final String postedBy;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishedAt,
    required this.postedBy,
  });
}
