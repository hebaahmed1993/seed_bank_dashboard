class AppSettingsModel {
  final String aboutUs;
  final String appName;
  final String appVersion;
  final String currencyCode;
  final String facebookUrl;
  final String instagramUrl;
  final bool isUnderMaintenance;
  final String minOrderValue;
  final String privacyPolicyUrl;
  final String storePhoneNumber_1;
  final String termsAndConditionsUrl;
  final String whatsappNumber;

  const AppSettingsModel({
    required this.aboutUs,
    required this.appName,
    required this.appVersion,
    required this.currencyCode,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.isUnderMaintenance,
    required this.minOrderValue,
    required this.privacyPolicyUrl,
    required this.storePhoneNumber_1,
    required this.termsAndConditionsUrl,
    required this.whatsappNumber,
  });

  factory AppSettingsModel.empty() {
    return const AppSettingsModel(
      aboutUs: '',
      appName: '',
      appVersion: '',
      currencyCode: 'LYD',
      facebookUrl: '',
      instagramUrl: '',
      isUnderMaintenance: false,
      minOrderValue: '',
      privacyPolicyUrl: '',
      storePhoneNumber_1: '',
      termsAndConditionsUrl: '',
      whatsappNumber: '',
    );
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      aboutUs: map['aboutUs']?.toString() ?? '',
      appName: map['appName']?.toString() ?? '',
      appVersion: map['appVersion']?.toString() ?? '',
      currencyCode: map['currencyCode']?.toString() ?? '',
      facebookUrl: map['facebookUrl']?.toString() ?? '',
      instagramUrl: map['instagramUrl']?.toString() ?? '',
      isUnderMaintenance: map['isUnderMaintenance'] == true,
      minOrderValue: map['minOrderValue']?.toString() ?? '',
      privacyPolicyUrl: map['privacyPolicyUrl']?.toString() ?? '',
      storePhoneNumber_1: map['storePhoneNumber_1']?.toString() ?? '',
      termsAndConditionsUrl: map['termsAndConditionsUrl']?.toString() ?? '',
      whatsappNumber: map['whatsappNumber']?.toString() ?? '',
    );
  }

  factory AppSettingsModel.fromFirestore(
    Map<String, dynamic> json,
    String _,
  ) {
    return AppSettingsModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'aboutUs': aboutUs,
      'appName': appName,
      'appVersion': appVersion,
      'currencyCode': currencyCode,
      'facebookUrl': facebookUrl,
      'instagramUrl': instagramUrl,
      'isUnderMaintenance': isUnderMaintenance,
      'minOrderValue': minOrderValue,
      'privacyPolicyUrl': privacyPolicyUrl,
      'storePhoneNumber_1': storePhoneNumber_1,
      'termsAndConditionsUrl': termsAndConditionsUrl,
      'whatsappNumber': whatsappNumber,
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  AppSettingsModel copyWith({
    String? aboutUs,
    String? appName,
    String? appVersion,
    String? currencyCode,
    String? facebookUrl,
    String? instagramUrl,
    bool? isUnderMaintenance,
    String? minOrderValue,
    String? privacyPolicyUrl,
    String? storePhoneNumber_1,
    String? termsAndConditionsUrl,
    String? whatsappNumber,
  }) {
    return AppSettingsModel(
      aboutUs: aboutUs ?? this.aboutUs,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      currencyCode: currencyCode ?? this.currencyCode,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      isUnderMaintenance: isUnderMaintenance ?? this.isUnderMaintenance,
      minOrderValue: minOrderValue ?? this.minOrderValue,
      privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
      storePhoneNumber_1: storePhoneNumber_1 ?? this.storePhoneNumber_1,
      termsAndConditionsUrl:
          termsAndConditionsUrl ?? this.termsAndConditionsUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    );
  }
}
