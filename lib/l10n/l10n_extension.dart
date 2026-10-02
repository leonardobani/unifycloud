import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Extension on [BuildContext] providing convenient, concise access to localized strings.
/// Usage: `context.l10n.someStringKey`
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

