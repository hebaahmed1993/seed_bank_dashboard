import '../localization/l10n/app_localizations.dart';
enum StatusFilter {
  all(null),
  active(false),  // active تعني isBlocked = false
  inactive(true); // inactive تعني isBlocked = true

  final bool? value;

  const StatusFilter(this.value);

  String label(AppLocalizations l10n) {
    switch (this) {
      case StatusFilter.all:
        return 'الكل';
      case StatusFilter.active:
        return l10n.activeStatus;
      case StatusFilter.inactive:
        return l10n.blockedStatus;
    }
  }
}