import 'dart:ui' show PlatformDispatcher;

import 'package:material_ui/material_ui.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Localization delegates compatible with `package:material_ui` and [AppLocalizations].
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates =
    <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// Resolves [AppLocalizations] without requiring a [BuildContext] with delegates.
/// Falls back to English if [locale] is null or unsupported.
AppLocalizations resolveAppLocalizations([Locale? locale]) {
  final candidate = locale ?? PlatformDispatcher.instance.locale;
  if (AppLocalizations.delegate.isSupported(candidate)) {
    return lookupAppLocalizations(candidate);
  }
  return lookupAppLocalizations(const Locale('en'));
}

/// Extension on [BuildContext] providing convenient, concise access to localized strings.
/// Usage: `context.l10n.someStringKey`
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ??
      resolveAppLocalizations(Localizations.maybeLocaleOf(this));
}
