// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Inicio';

  @override
  String get explorer => 'Explorador';

  @override
  String get sync => 'Sincronización';

  @override
  String get settings => 'Ajustes';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get edit => 'Editar';

  @override
  String get create => 'Crear';

  @override
  String get retry => 'Reintentar';

  @override
  String get copy => 'Copiar';

  @override
  String get move => 'Mover';

  @override
  String get rename => 'Renombrar';

  @override
  String get download => 'Descargar';

  @override
  String get upload => 'Subir';

  @override
  String get share => 'Compartir';

  @override
  String get details => 'Detalles';

  @override
  String get search => 'Buscar';

  @override
  String get change => 'Cambiar';

  @override
  String get reset => 'Restablecer';

  @override
  String get done => 'Listo';

  @override
  String get loading => 'Cargando...';

  @override
  String get success => 'Operación completada';

  @override
  String get error => 'Error';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get resetDefaultsTooltip => 'Restaurar valores predeterminados';

  @override
  String get resetDialogTitle => 'Restablecer ajustes';

  @override
  String get resetDialogContent =>
      '¿Deseas restablecer todas las preferencias (tema, idioma, carpetas, visualización) a los valores de fábrica?';

  @override
  String get resetSuccessSnackbar =>
      'Ajustes restaurados a los valores predeterminados';

  @override
  String get appearanceAndTheme => 'Aspecto y tema';

  @override
  String get chooseVisualThemeSubtitle =>
      'Elige el tema visual de la interfaz de UnifyCloud:';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Seleccionar idioma de la interfaz';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Predeterminado del sistema';

  @override
  String get filesAndExploration => 'Archivos y exploración';

  @override
  String get showHiddenFiles => 'Mostrar archivos ocultos';

  @override
  String get showHiddenFilesSubtitle =>
      'Mostrar archivos y carpetas que comienzan con un punto';

  @override
  String get confirmBeforeDelete => 'Confirmar antes de eliminar';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Pedir confirmación antes de eliminar archivos permanentemente';

  @override
  String get defaultDownloadFolder => 'Carpeta de descargas predeterminada';

  @override
  String get defaultDownloadFolderSystem =>
      'Directorio de descargas predeterminado del sistema';

  @override
  String get restoreDefaultPath => 'Restaurar ruta predeterminada';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Selecciona una carpeta usando el explorador del sistema o escribe la ruta deseada:';

  @override
  String get folderPath => 'Ruta de la carpeta';

  @override
  String get folderPathHint => 'ej. /home/usuario/Descargas';

  @override
  String get browseWithSystemPicker => 'Examinar con el selector del sistema';

  @override
  String errorOpenPicker(String error) {
    return 'No se pudo abrir el selector del sistema: $error';
  }

  @override
  String get restoreDefault => 'Restaurar predeterminado';

  @override
  String get maxConcurrentTransfers => 'Transferencias simultáneas';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Número máximo de transferencias simultáneas activas';

  @override
  String get dualPaneMode => 'Modo Commander (Doble panel)';

  @override
  String get dualPaneModeSubtitle =>
      'Mostrar dos paneles lado a lado en pantallas anchas y tabletas';

  @override
  String get communityAndSupport => 'Comunidad y soporte';

  @override
  String get openSourceDescription =>
      'UnifyCloud es un software libre y de código abierto diseñado para unificar tus nubes sin rastreadores ni intermediarios propietarios.';

  @override
  String get supportDeveloper => 'Apoyar al desarrollador';

  @override
  String get supportDeveloperSubtitle =>
      'Invita a un café para apoyar el desarrollo independiente';

  @override
  String get viewSourceOnGitLab => 'Ver código en GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Repositorio oficial, reporte de errores y contribuciones';

  @override
  String errorOpenBrowser(String url) {
    return 'No se pudo abrir el navegador. Repositorio: $url';
  }

  @override
  String get supportDialogTitle => 'Apoyar a UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud es un proyecto gratuito y de código abierto creado para darte el control total sobre tus archivos en la nube.';

  @override
  String get supportDialogDescription2 =>
      'Si encuentras útil esta aplicación, considera invitar a un café o hacer una donación para apoyar el desarrollo continuo y nuevas funciones.';

  @override
  String get supportKofiTitle => 'Invita a un café en Ko-fi';

  @override
  String get supportLiberapayTitle => 'Donar en Liberapay';

  @override
  String get supportPaypalTitle => 'Donar mediante PayPal';

  @override
  String get securityAndEncryption => 'Seguridad y cifrado';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud emplea una arquitectura de Texto Cero Plano. Todos los tokens OAuth y credenciales están protegidos en el Keychain/Keystore del sistema e inyectados exclusivamente en la memoria RAM del motor Go.';

  @override
  String get appLock => 'Bloqueo de app (PIN / Biometría)';

  @override
  String get appLockSubtitle => 'Requerir PIN o huella digital para acceder';

  @override
  String get appLockActiveSubtitle => 'Activo al iniciar y tras inactividad';

  @override
  String get appLockEnabledSnackbar => 'Bloqueo de app activado con éxito';

  @override
  String get appLockDisabledSnackbar => 'Bloqueo de app desactivado';

  @override
  String get changePin => 'Cambiar PIN';

  @override
  String get changePinSubtitle => 'Establecer un nuevo PIN de 6 dígitos';

  @override
  String get pinChangedSnackbar => 'PIN de seguridad actualizado con éxito';

  @override
  String get biometricAuth => 'Autenticación biométrica';

  @override
  String get biometricAuthSubtitle =>
      'Usar huella digital o sensor biométrico si está disponible';

  @override
  String get biometricNotAvailable =>
      'No disponible o no configurado en este dispositivo';

  @override
  String get autoLock => 'Bloqueo automático';

  @override
  String get autoLockSubtitle =>
      'Tiempo de inactividad en segundo plano antes de bloquear';

  @override
  String get lockImmediately => 'Inmediatamente';

  @override
  String get lockAfter1Minute => 'Tras 1 minuto';

  @override
  String get lockAfter5Minutes => 'Tras 5 minutos';

  @override
  String get lockAfter15Minutes => 'Tras 15 minutos';

  @override
  String get lockAfter30Minutes => 'Tras 30 minutos';

  @override
  String get syncCloudAccounts => 'Sincronizar cuentas en la nube';

  @override
  String get syncCloudAccountsSubtitle =>
      'Recargar configuraciones desde el almacenamiento seguro';

  @override
  String get syncCloudAccountsSuccess =>
      'Cuentas en la nube recargadas con éxito';

  @override
  String get clearAllCredentials => 'Borrar todas las credenciales';

  @override
  String get clearAllCredentialsSubtitle =>
      'Elimina la configuración cifrada y desconecta todas las nubes';

  @override
  String get clearCredentialsDialogTitle => 'Aviso: Restablecer credenciales';

  @override
  String get clearCredentialsDialogContent =>
      '¿Estás seguro de que deseas eliminar todas las credenciales guardadas? Tendrás que volver a conectar tus cuentas.';

  @override
  String get clearCredentialsSuccess => 'Credenciales eliminadas con éxito';

  @override
  String get aboutUnifyCloud => 'Acerca de UnifyCloud';

  @override
  String get appVersion => 'Versión de la app: 1.0.0';

  @override
  String get developerInfo => 'Desarrollador: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Motor: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Licencia: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Copyright: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Resumen de almacenamiento';

  @override
  String get connectedClouds => 'Nubes conectadas';

  @override
  String get noCloudsConfigured => 'No hay cuentas configuradas';

  @override
  String get noCloudsDescription =>
      'Conecta tu primera cuenta de almacenamiento en la nube para comenzar a gestionar y sincronizar archivos.';

  @override
  String get addCloud => 'Añadir nube';

  @override
  String get used => 'usado';

  @override
  String get free => 'libre';

  @override
  String get total => 'total';

  @override
  String get manageAccounts => 'Gestionar cuentas';

  @override
  String get viewFiles => 'Ver archivos';

  @override
  String get createVaultHere => 'Crear baúl cifrado aquí...';

  @override
  String get disconnectAccount => 'Desconectar cuenta';

  @override
  String get disconnectConfirmTitle => '¿Desconectar cuenta?';

  @override
  String get disconnectConfirmContent =>
      '¿Estás seguro de que deseas desconectar esta cuenta? Los archivos remotos permanecerán intactos.';

  @override
  String get allFiles => 'Todos los archivos';

  @override
  String get emptyFolder => 'Esta carpeta está vacía';

  @override
  String get emptyFolderSubtitle =>
      'Sube archivos o crea una subcarpeta para comenzar.';

  @override
  String get uploadFile => 'Subir archivo';

  @override
  String get uploadFolder => 'Subir carpeta completa';

  @override
  String get newFolder => 'Nueva carpeta';

  @override
  String get newFolderPrompt => 'Introduce el nombre para la nueva carpeta:';

  @override
  String get folderNameHint => 'Nombre de la carpeta';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get clearSelection => 'Deseleccionar';

  @override
  String get deleteSelected => 'Eliminar seleccionados';

  @override
  String get deleteSelectedPrompt =>
      '¿Estás seguro de que deseas eliminar los elementos seleccionados?';

  @override
  String get deleteItemPrompt =>
      '¿Estás seguro de que deseas eliminar este elemento?';

  @override
  String get shareLink => 'Compartir enlace';

  @override
  String get createShareLink => 'Crear enlace para compartir';

  @override
  String get copyShareLink => 'Copiar enlace';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get transfers => 'Transferencias';

  @override
  String get activeTransfers => 'Transferencias activas';

  @override
  String get completed => 'Completado';

  @override
  String get failed => 'Fallido';

  @override
  String get queued => 'En cola';

  @override
  String get cancelTransfer => 'Cancelar transferencia';

  @override
  String get clearCompleted => 'Limpiar completadas';

  @override
  String get syncRulesTitle => 'Reglas de respaldo y sync';

  @override
  String get newRule => 'Nueva regla';

  @override
  String get noSyncRules => 'No hay reglas de sincronización configuradas';

  @override
  String get noSyncRulesSubtitle =>
      'Crea una regla automática para sincronizar carpetas locales con tu nube.';

  @override
  String get ruleName => 'Nombre de la regla';

  @override
  String get sourcePath => 'Carpeta de origen';

  @override
  String get destinationCloud => 'Nube de destino';

  @override
  String get destinationPath => 'Ruta remota';

  @override
  String get direction => 'Dirección';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get runNow => 'Ejecutar ahora';

  @override
  String get syncInProgress => 'Sincronización en curso...';

  @override
  String get syncSuccess => 'Sincronización completada';

  @override
  String get syncFailed => 'Sincronización fallida';

  @override
  String get addCloudDialogTitle => 'Conectar nueva nube';

  @override
  String get selectProvider => 'Seleccionar proveedor de nube';

  @override
  String get accountNameLabel => 'Nombre de cuenta / Alias';

  @override
  String get connectButton => 'Conectar cuenta';

  @override
  String get vaultTitle => 'Cifrado E2E (Crypt)';

  @override
  String get vaultPassword => 'Contraseña del baúl';

  @override
  String get vaultConfirmPassword => 'Confirmar contraseña';

  @override
  String get vaultSalt => 'Salt / Contraseña secundaria (Opcional)';

  @override
  String get encryptFileNames => 'Cifrar nombres de archivo';

  @override
  String get encryptDirNames => 'Cifrar nombres de carpeta';

  @override
  String get langSpanish => 'Español';

  @override
  String get langFrench => 'Français';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langPortuguese => 'Português';

  @override
  String get langRussian => 'Русский';

  @override
  String get langChinese => '简体中文';

  @override
  String get langJapanese => '日本語';

  @override
  String get langKorean => '한국어';

  @override
  String get langArabic => 'العربية';

  @override
  String get langHindi => 'हिन्दी';

  @override
  String get langDutch => 'Nederlands';

  @override
  String get langPolish => 'Polski';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get searchLanguageHint => 'Buscar idioma o país...';

  @override
  String get currentLanguage => 'Idioma actual';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Predeterminado del sistema ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Actualizar nubes configuradas';

  @override
  String get storageOverviewAggregated => 'Resumen de almacenamiento agregado';

  @override
  String get ramEncryptionActive => 'Cifrado RAM activo';

  @override
  String connectedAccountsCount(int count) {
    return 'Cuentas en la nube conectadas: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'No hay cuentas en la nube configuradas. Toca \"+ Conectar nueva nube\" abajo.';

  @override
  String percentUsed(String percent) {
    return '$percent% ocupado';
  }

  @override
  String availableSpace(String space) {
    return '$space disponibles';
  }

  @override
  String get calculatingQuota =>
      'Calculando cuota de almacenamiento o espacio ilimitado...';

  @override
  String get syncAndBackup => 'Sincronización y respaldo';

  @override
  String get noRulesConfigured => 'No hay reglas configuradas';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total reglas activas';
  }

  @override
  String get manage => 'Gestionar';

  @override
  String connectedCloudsCount(int count) {
    return 'Nubes conectadas ($count)';
  }

  @override
  String get connectNewCloud => 'Conectar nueva nube';

  @override
  String get noCloudProvidersConnected => 'Ningún proveedor de nube conectado';

  @override
  String get connectCloudDescription =>
      'Conecta Google Drive, Dropbox, OneDrive, SFTP o WebDAV para comenzar a sincronizar y explorar tus archivos.';

  @override
  String get addFirstCloud => 'Añadir primera nube';

  @override
  String vaultOnRemote(String remote) {
    return 'BAÚL EN $remote';
  }

  @override
  String get disconnectCloudTitle => 'Desconectar nube';

  @override
  String disconnectCloudPrompt(String name) {
    return '¿Deseas desconectar \"$name\"? Las credenciales se eliminarán del almacenamiento cifrado.';
  }

  @override
  String get disconnect => 'Desconectar';

  @override
  String freeSpace(String space) {
    return '$space libres';
  }

  @override
  String get storage => 'Almacenamiento';

  @override
  String get available => 'Disponible';

  @override
  String get exploreFiles => 'Explorar archivos';

  @override
  String get paneLeft => 'Izquierda';

  @override
  String get paneRight => 'Derecha';

  @override
  String get folderName => 'Nombre de la carpeta';

  @override
  String errorCreatingFolder(String error) {
    return 'Error al crear carpeta: $error';
  }

  @override
  String get moveAction => 'Mover';

  @override
  String get copyAction => 'Copiar';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action de $count elementos hacia [$remote] iniciado...';
  }

  @override
  String errorTransferring(String error) {
    return 'Error durante la transferencia: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" copiado al portapapeles';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count elementos copiados al portapapeles';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" cortado (listo para mover)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count elementos cortados (listos para mover)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'No se han seleccionado archivos para descargar.';

  @override
  String downloadingItems(int count) {
    return 'Descargando $count elementos...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count elementos descargados en \"$path\"';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Error al iniciar la descarga: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '¿Eliminar $count elementos seleccionados?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return '¿Estás seguro de que deseas eliminar definitivamente $count elementos seleccionados de la nube?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count elementos eliminados';
  }

  @override
  String errorDeleting(String error) {
    return 'Error durante la eliminación: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Subida completada con éxito';

  @override
  String errorUploading(String error) {
    return 'Error durante la subida: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'Subida de carpeta completada con éxito';

  @override
  String errorFolderUploading(String error) {
    return 'Error al subir carpeta: $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'Los archivos ya se encuentran en esta carpeta.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action de $count elementos hacia [$remote] iniciado...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Error en transferencia arrastrar y soltar: $error';
  }

  @override
  String get closeSelection => 'Cerrar selección';

  @override
  String itemsSelectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get deselectAll => 'Deseleccionar todo';

  @override
  String copyToRemote(String remote) {
    return 'Copiar a $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Mover a $remote';
  }

  @override
  String get moreActions => 'Más acciones';

  @override
  String get downloadSelected => 'Descargar seleccionados';

  @override
  String get copyToClipboard => 'Copiar al portapapeles';

  @override
  String get cutToClipboard => 'Cortar al portapapeles';

  @override
  String get selectCloud => 'Seleccionar nube';

  @override
  String get closeSearch => 'Cerrar búsqueda';

  @override
  String get uploadFromDevice => 'Subir desde el dispositivo';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String get viewGrid => 'Vista cuadrícula';

  @override
  String get viewList => 'Vista lista';

  @override
  String get multiSelection => 'Selección múltiple';

  @override
  String get sortNameAsc => 'Nombre (A-Z)';

  @override
  String get sortNameDesc => 'Nombre (Z-A)';

  @override
  String get sortSizeDesc => 'Tamaño (Mayor -> Menor)';

  @override
  String get sortSizeAsc => 'Tamaño (Menor -> Mayor)';

  @override
  String get sortDateDesc => 'Fecha (Más reciente primero)';

  @override
  String get disableDualPane => 'Desactivar Commander (Panel único)';

  @override
  String get enableDualPane => 'Activar Commander (Doble panel)';

  @override
  String itemsInClipboard(int count) {
    return '$count elementos en el portapapeles';
  }

  @override
  String get pasteHere => 'Pegar aquí';

  @override
  String get noResults => 'Sin resultados';

  @override
  String noMatchingResults(String query) {
    return 'Ningún archivo o carpeta coincide con \"$query\"';
  }

  @override
  String get selectACloud => 'Selecciona una nube';

  @override
  String get selectCloudDescription =>
      'Selecciona un proveedor de nube en el menú superior para ver y explorar tus archivos remotos.';

  @override
  String optionsForItem(String name) {
    return 'Opciones para $name';
  }

  @override
  String get select => 'Seleccionar';

  @override
  String get openWithSystemApp => 'Abrir con app del sistema';

  @override
  String get downloadToLocal => 'Descargar a local';

  @override
  String get cut => 'Cortar (Mover)';

  @override
  String get copyPath => 'Copiar ruta';

  @override
  String get info => 'Información';

  @override
  String generatingShareLink(String name) {
    return 'Generando enlace para \"$name\"...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Error en enlace público: $error';
  }

  @override
  String get noLinkGenerated => 'El proveedor no generó ningún enlace.';

  @override
  String errorDownloading(String error) {
    return 'Error durante la descarga: $error';
  }

  @override
  String get renameFolderTitle => 'Renombrar carpeta';

  @override
  String get renameFileTitle => 'Renombrar archivo';

  @override
  String errorRenaming(String error) {
    return 'Error al renombrar: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Ruta copiada al portapapeles';

  @override
  String itemDetailsPath(String path) {
    return 'Ruta: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Tipo: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Tamaño: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Fecha de modificación: $date';
  }

  @override
  String get folder => 'Carpeta';

  @override
  String get file => 'Archivo';

  @override
  String get selectCloudFirstLeft =>
      'Selecciona primero una nube en el panel izquierdo.';

  @override
  String get selectCloudFirstRight =>
      'Selecciona primero una nube en el panel derecho.';

  @override
  String get selectDestinationCloudLeft =>
      'Selecciona primero una nube de destino en el panel izquierdo.';

  @override
  String get selectDestinationCloudRight =>
      'Selecciona primero una nube de destino en el panel derecho.';

  @override
  String get noFilesToTransfer =>
      'No hay archivos presentes ni seleccionados para transferir.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action de $count elementos de [$src] a [$dst] iniciado...';
  }

  @override
  String get swapPanesTooltip => 'Intercambiar paneles (<->)';

  @override
  String get refreshBothPanesTooltip => 'Actualizar ambos paneles';

  @override
  String get copyRight => 'Copiar a la derecha ->';

  @override
  String get moveRight => 'Mover a la derecha ->';

  @override
  String get copyLeft => '<- Copiar a la izquierda';

  @override
  String get moveLeft => '<- Mover a la izquierda';

  @override
  String copyRightWithCount(int count) {
    return 'Copiar a la derecha ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Mover a la derecha ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Copiar a la izquierda ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Mover a la izquierda ($count)';
  }

  @override
  String get deleteRuleTitle => 'Eliminar regla';

  @override
  String deleteRulePrompt(String name) {
    return '¿Seguro que deseas eliminar la regla \"$name\"? Los archivos locales y en la nube se conservarán.';
  }

  @override
  String get syncAll => 'Sincronizar todo';

  @override
  String get newRuleTooltip => 'Nueva regla';

  @override
  String get backupBannerTitle =>
      'Respaldo continuo y sincronización en la nube';

  @override
  String get backupBannerSubtitle =>
      'Configura sincronizaciones programadas entre carpetas locales y nubes remotas.';

  @override
  String get noActiveRules => 'No hay reglas activas';

  @override
  String get noActiveRulesSubtitle =>
      'Crea tu primera regla para realizar respaldos automáticos desde tu dispositivo a Google Drive, Dropbox, SFTP o cualquier otra nube.';

  @override
  String get createNewRule => 'Crear nueva regla';

  @override
  String get ruleOptionsTooltip => 'Opciones de regla';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get statusWaiting => 'En espera';

  @override
  String get statusInProgress => 'En curso...';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusFailed => 'Error';

  @override
  String get editRuleTitle => 'Editar regla de respaldo';

  @override
  String get newRuleTitle => 'Nueva regla de sincronización';

  @override
  String get ruleDialogSubtitle =>
      'Configura el respaldo automático entre una carpeta local y la nube.';

  @override
  String get ruleNameOptional => 'Nombre de regla (opcional)';

  @override
  String get ruleNameHint => 'Ej. Respaldo Fotos DCIM o Documentos Trabajo';

  @override
  String get sourceLocalFolder => 'Carpeta local de origen';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM o /home/usuario/Imágenes';

  @override
  String get browseFolders => 'Examinar carpetas';

  @override
  String get selectLocalFolderError =>
      'Introduce o selecciona una carpeta local';

  @override
  String get noCloudsConfiguredSync =>
      'No hay nubes configuradas. Añade una cuenta en la nube desde Inicio antes de continuar.';

  @override
  String get remoteDestinationPath => 'Ruta remota de destino';

  @override
  String get syncMode => 'Modo de sincronización';

  @override
  String get syncModeCopy => 'Respaldo incremental';

  @override
  String get syncModeCopyDesc =>
      'Sube archivos nuevos y modificados conservando siempre los archivos en la nube.';

  @override
  String get syncModeSync => 'Sincronización espejo';

  @override
  String get syncModeSyncDesc =>
      'Hace que el destino remoto sea idéntico a la carpeta local (los eliminados localmente se borran de la nube).';

  @override
  String get syncFrequency => 'Frecuencia de ejecución';

  @override
  String get freqManual => 'Manual (solo bajo demanda)';

  @override
  String get freq15Min => 'Cada 15 minutos';

  @override
  String get freq30Min => 'Cada 30 minutos';

  @override
  String get freqHourly => 'Cada hora';

  @override
  String get freq6Hours => 'Cada 6 horas';

  @override
  String get freq12Hours => 'Cada 12 horas';

  @override
  String get freqDaily => 'Cada día (24 horas)';

  @override
  String get activateRuleImmediately => 'Activar regla de inmediato';

  @override
  String get activateRuleImmediatelyDesc =>
      'La sincronización se ejecutará en segundo plano según el intervalo especificado';

  @override
  String get updateRule => 'Actualizar';

  @override
  String get saveRule => 'Guardar regla';

  @override
  String get selectCloudProvider => 'Seleccionar proveedor de nube:';

  @override
  String get cloudAccountName => 'Nombre de la cuenta de nube';

  @override
  String get cloudAccountNameHint =>
      'Ej. GoogleDrive, TrabajoDropbox (sin espacios)';

  @override
  String get enterNameError => 'Por favor introduce un nombre';

  @override
  String get noSpacesOrColons => 'No se permiten espacios ni \":\"';

  @override
  String get oauthMode => 'Modo Client ID (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Oficial / Recomendado)';

  @override
  String get oauthRclone => 'Rclone (No recomendado - Cuota compartida)';

  @override
  String get oauthCustom => 'Client ID Personal (Avanzado)';

  @override
  String get officialOauthTitle => 'Credenciales oficiales de UnifyCloud';

  @override
  String get officialOauthDesc =>
      'Credenciales preconfiguradas para conectar de inmediato con cuota dedicada y máxima velocidad.';

  @override
  String get rcloneOauthDesc =>
      'Claves de código abierto compartidas de Rclone. Pueden sufrir límites de cuota o errores 403 de Google.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination =>
      'Selecciona la nube de destino para el Baúl';

  @override
  String get vaultPasswordRequired => 'La contraseña de cifrado es obligatoria';

  @override
  String get vaultPasswordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String errorAddingRemote(String error) {
    return 'Error al añadir la nube: $error';
  }

  @override
  String get fileNameEncryption => 'Cifrado de nombres de archivo';

  @override
  String get encryptStandard =>
      'Estándar (Nombres de archivo totalmente cifrados - Recomendado)';

  @override
  String get encryptObscure => 'Ofuscación simple (Conserva extensiones)';

  @override
  String get encryptOff => 'Desactivado (Nombres visibles en claro)';

  @override
  String get encryptFolderNames => 'Cifrar también los nombres de carpeta';

  @override
  String get encryptFolderNamesDesc =>
      'Oculta por completo la estructura de directorios en la nube';

  @override
  String get connectCloud => 'Conectar nube';

  @override
  String get reopenAuth => 'Reabrir';

  @override
  String get linkCopiedToClipboard => '¡Enlace copiado al portapapeles!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'No se pudo abrir el navegador: $error';
  }

  @override
  String get shareableLinkTitle => 'Enlace para compartir';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Cualquier persona con este enlace podrá acceder a $item:';
  }

  @override
  String get open => 'Abrir';

  @override
  String activeTransfersCount(int count) {
    return '$count transferencias activas';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Cola de transferencias ($count)';
  }

  @override
  String get noTransfersInProgress => 'No hay transferencias en curso';

  @override
  String get transfersEmptySubtitle =>
      'Todos los archivos descargados o subidos aparecerán aquí';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get appLockedTitle => 'Aplicación bloqueada';

  @override
  String get unlockWithBiometrics => 'Desbloquear con biometría';

  @override
  String get pinMustBe6Digits => 'El PIN debe tener exactamente 6 dígitos';

  @override
  String get pinIncorrect => 'PIN incorrecto. Inténtalo de nuevo.';

  @override
  String get pinsDoNotMatch => 'Los PIN no coinciden. Inténtalo de nuevo.';

  @override
  String get pinStepOld => 'Introduce tu PIN actual para continuar.';

  @override
  String get pinStepNew => 'Introduce tu nuevo PIN de 6 dígitos.';

  @override
  String get pinStepConfirm =>
      'Vuelve a introducir el nuevo PIN para confirmarlo.';

  @override
  String get pinStepVerify => 'Introduce tu PIN para confirmar la operación.';

  @override
  String get pinTitleSetup => 'Configurar PIN de seguridad';

  @override
  String get pinTitleChange => 'Modificar PIN de seguridad';

  @override
  String get pinTitleVerify => 'Verificación de seguridad';

  @override
  String get pinContinue => 'Continuar';

  @override
  String get errorDetails => 'Detalles del error';

  @override
  String get errorDetailsCopied =>
      'Detalles del error copiados al portapapeles';

  @override
  String get collapse => 'Contraer';

  @override
  String get expand => 'Expandir';

  @override
  String get copyError => 'Copiar error';

  @override
  String get errorNetwork =>
      'Conexión ausente o inestable. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get errorDiskSpace =>
      'Espacio de almacenamiento insuficiente o disco lleno. Libera memoria para continuar.';

  @override
  String get errorAuthExpired =>
      'Sesión o token caducado/revocado. Vuelve a conectar tu cuenta.';

  @override
  String get errorNotFound =>
      'Elemento o carpeta no encontrado en el proveedor de nube.';

  @override
  String get errorPermissionDenied =>
      'Permiso denegado para realizar esta operación en la nube.';

  @override
  String get errorGeneric => 'Se produjo un error durante la operación.';
}
