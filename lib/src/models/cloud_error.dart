import 'package:flutter/material.dart';

/// Categories of errors that can occur during cloud operations and transfers.
enum CloudErrorType {
  network,
  diskSpace,
  authExpired,
  notFound,
  permissionDenied,
  generic;

  /// Analyzes an error object or message string to classify the error cause.
  static CloudErrorType fromError(dynamic error) {
    if (error == null) return CloudErrorType.generic;
    final str = error.toString().toLowerCase();

    // 1. Spazio in esaurimento / disco pieno
    if (str.contains('no space left') ||
        str.contains('disk full') ||
        str.contains('enospc') ||
        str.contains('quota exceeded') ||
        str.contains('insufficient storage') ||
        str.contains('storage quota') ||
        str.contains('out of disk space')) {
      return CloudErrorType.diskSpace;
    }

    // 2. Token revocati o scaduti / autenticazione
    if (str.contains('invalid_grant') ||
        str.contains('token expired') ||
        str.contains('token has been revoked') ||
        str.contains('unauthorized') ||
        str.contains('status code 401') ||
        str.contains('401 unauthorized') ||
        str.contains('invalid_token') ||
        str.contains('cannot fetch token') ||
        str.contains('re-authenticate') ||
        str.contains('oauth2: cannot fetch token') ||
        str.contains('failed when making oauth client') ||
        str.contains('failed to create oauth client') ||
        str.contains('oauth client')) {
      return CloudErrorType.authExpired;
    }

    // 3. Perdita di connessione / rete
    if (str.contains('no such host') ||
        str.contains('connection refused') ||
        str.contains('network is unreachable') ||
        str.contains('i/o timeout') ||
        str.contains('dial tcp') ||
        str.contains('connection reset') ||
        str.contains('offline') ||
        str.contains('failed host lookup') ||
        str.contains('socketexception') ||
        str.contains('handshake failed') ||
        str.contains('context deadline exceeded') ||
        str.contains('timeout')) {
      return CloudErrorType.network;
    }

    // 4. File o cartella non trovata
    if (str.contains('file not found') ||
        str.contains('object not found') ||
        str.contains('not found') ||
        str.contains('404')) {
      return CloudErrorType.notFound;
    }

    // 5. Permessi negati
    if (str.contains('permission denied') ||
        str.contains('access denied') ||
        str.contains('access forbidden') ||
        str.contains('403 forbidden') ||
        str.contains('status code 403')) {
      return CloudErrorType.permissionDenied;
    }

    return CloudErrorType.generic;
  }

  /// User-friendly localized message in Italian explaining the error cause.
  String get userFriendlyMessage {
    switch (this) {
      case CloudErrorType.network:
        return 'Connessione assente o instabile. Verifica la rete internet e riprova.';
      case CloudErrorType.diskSpace:
        return 'Spazio di archiviazione insufficiente o disco pieno. Libera memoria per continuare.';
      case CloudErrorType.authExpired:
        return 'Sessione o token scaduto/revocato. Riconnetti il tuo account.';
      case CloudErrorType.notFound:
        return 'Elemento o cartella non trovata sul provider cloud.';
      case CloudErrorType.permissionDenied:
        return 'Permesso negato per eseguire questa operazione sul cloud.';
      case CloudErrorType.generic:
        return 'Si è verificato un errore durante l\'operazione.';
    }
  }

  /// Recommended Material Icon for visual feedback.
  IconData get icon {
    switch (this) {
      case CloudErrorType.network:
        return Icons.wifi_off_rounded;
      case CloudErrorType.diskSpace:
        return Icons.disc_full_rounded;
      case CloudErrorType.authExpired:
        return Icons.lock_reset_rounded;
      case CloudErrorType.notFound:
        return Icons.find_in_page_rounded;
      case CloudErrorType.permissionDenied:
        return Icons.block_rounded;
      case CloudErrorType.generic:
        return Icons.error_outline_rounded;
    }
  }

  /// Whether operations failing with this error should permit immediate retry.
  bool get canRetry {
    switch (this) {
      case CloudErrorType.network:
        return true;
      case CloudErrorType.diskSpace:
        // Do not auto-retry if disk is full to avoid burning resources
        return false;
      case CloudErrorType.authExpired:
        // Requires re-auth flow first
        return false;
      default:
        return true;
    }
  }
}
