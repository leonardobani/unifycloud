// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Início';

  @override
  String get explorer => 'Explorador';

  @override
  String get sync => 'Sincronização';

  @override
  String get settings => 'Definições';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Fechar';

  @override
  String get edit => 'Editar';

  @override
  String get create => 'Criar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get copy => 'Copiar';

  @override
  String get move => 'Mover';

  @override
  String get rename => 'Mudar o nome';

  @override
  String get download => 'Descarregar';

  @override
  String get upload => 'Carregar';

  @override
  String get share => 'Partilhar';

  @override
  String get details => 'Detalhes';

  @override
  String get search => 'Pesquisar';

  @override
  String get change => 'Alterar';

  @override
  String get reset => 'Repor';

  @override
  String get done => 'Concluído';

  @override
  String get loading => 'A carregar...';

  @override
  String get success => 'Operação concluída';

  @override
  String get error => 'Erro';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get resetDefaultsTooltip => 'Restaurar predefinições';

  @override
  String get resetDialogTitle => 'Repor definições';

  @override
  String get resetDialogContent =>
      'Deseja repor todas as preferências (tema, idioma, pastas, visualização) para os valores de fábrica?';

  @override
  String get resetSuccessSnackbar =>
      'Definições repostas para os valores predefinidos';

  @override
  String get appearanceAndTheme => 'Aparência e Tema';

  @override
  String get chooseVisualThemeSubtitle =>
      'Escolha o tema visual para a interface do UnifyCloud:';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Selecionar o idioma da interface';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Padrão do sistema';

  @override
  String get filesAndExploration => 'Ficheiros e Exploração';

  @override
  String get showHiddenFiles => 'Mostrar ficheiros ocultos';

  @override
  String get showHiddenFilesSubtitle =>
      'Apresentar ficheiros e pastas iniciados por um ponto';

  @override
  String get confirmBeforeDelete => 'Confirmar antes de eliminar';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Pedir confirmação antes de eliminar ficheiros permanentemente';

  @override
  String get defaultDownloadFolder => 'Pasta de descargas predefinida';

  @override
  String get defaultDownloadFolderSystem =>
      'Diretório de descargas predefinido do sistema';

  @override
  String get restoreDefaultPath => 'Restaurar caminho predefinido';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Selecione uma pasta usando o seletor do sistema ou introduza o caminho:';

  @override
  String get folderPath => 'Caminho da pasta';

  @override
  String get folderPathHint => 'ex. /home/utilizador/Descargas';

  @override
  String get browseWithSystemPicker => 'Procurar com o seletor do sistema';

  @override
  String errorOpenPicker(String error) {
    return 'Não foi possível abrir o seletor do sistema: $error';
  }

  @override
  String get restoreDefault => 'Restaurar predefinição';

  @override
  String get maxConcurrentTransfers => 'Transferências simultâneas';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Número máximo de transferências de ficheiros ativas simultâneas';

  @override
  String get dualPaneMode => 'Modo Commander (Painel duplo)';

  @override
  String get dualPaneModeSubtitle =>
      'Apresentar dois painéis lado a lado em ecrãs largos e tablets';

  @override
  String get communityAndSupport => 'Comunidade e Suporte';

  @override
  String get openSourceDescription =>
      'O UnifyCloud é software livre e de código aberto criado para unificar os seus dados na nuvem sem rastreadores ou intermediários proprietários.';

  @override
  String get supportDeveloper => 'Apoiar o programador';

  @override
  String get supportDeveloperSubtitle =>
      'Pague um café para apoiar o desenvolvimento independente';

  @override
  String get viewSourceOnGitLab => 'Ver código no GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Repositório oficial, relatórios de erros e contribuições';

  @override
  String errorOpenBrowser(String url) {
    return 'Não foi possível abrir o navegador. Repositório: $url';
  }

  @override
  String get supportDialogTitle => 'Apoiar o UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'O UnifyCloud é um projeto gratuito e de código aberto desenvolvido para lhe dar controlo total sobre os seus ficheiros na nuvem.';

  @override
  String get supportDialogDescription2 =>
      'Se considera esta aplicação útil, considere pagar um café ou fazer uma doação para apoiar o desenvolvimento contínuo!';

  @override
  String get supportKofiTitle => 'Pagar um café no Ko-fi';

  @override
  String get supportLiberapayTitle => 'Doar no Liberapay';

  @override
  String get supportPaypalTitle => 'Doar via PayPal';

  @override
  String get securityAndEncryption => 'Segurança e Encriptação';

  @override
  String get securityArchitectureDescription =>
      'O UnifyCloud adota uma arquitetura Zero-Plaintext. Todos os tokens OAuth e credenciais são protegidos no Keychain/Keystore do sistema e injetados exclusivamente na memória RAM do motor Go.';

  @override
  String get appLock => 'Bloqueio da Aplicação (PIN / Biometria)';

  @override
  String get appLockSubtitle => 'Exigir PIN ou impressão digital para aceder';

  @override
  String get appLockActiveSubtitle => 'Ativo no arranque e após inatividade';

  @override
  String get appLockEnabledSnackbar =>
      'Bloqueio da aplicação ativado com sucesso';

  @override
  String get appLockDisabledSnackbar => 'Bloqueio da aplicação desativado';

  @override
  String get changePin => 'Alterar PIN';

  @override
  String get changePinSubtitle =>
      'Definir um novo PIN de segurança de 6 dígitos';

  @override
  String get pinChangedSnackbar => 'PIN de segurança atualizado com sucesso';

  @override
  String get biometricAuth => 'Autenticação biométrica';

  @override
  String get biometricAuthSubtitle =>
      'Usar impressão digital ou sensor biométrico se disponível';

  @override
  String get biometricNotAvailable =>
      'Não disponível ou não configurado neste dispositivo';

  @override
  String get autoLock => 'Bloqueio automático';

  @override
  String get autoLockSubtitle =>
      'Tempo de inatividade em segundo plano antes do bloqueio';

  @override
  String get lockImmediately => 'Imediatamente';

  @override
  String get lockAfter1Minute => 'Após 1 minuto';

  @override
  String get lockAfter5Minutes => 'Após 5 minutos';

  @override
  String get lockAfter15Minutes => 'Após 15 minutos';

  @override
  String get lockAfter30Minutes => 'Após 30 minutos';

  @override
  String get syncCloudAccounts => 'Sincronizar contas na nuvem';

  @override
  String get syncCloudAccountsSubtitle =>
      'Recarregar configurações a partir do armazenamento seguro';

  @override
  String get syncCloudAccountsSuccess =>
      'Contas na nuvem recarregadas com sucesso';

  @override
  String get clearAllCredentials => 'Limpar todas as credenciais';

  @override
  String get clearAllCredentialsSubtitle =>
      'Remove a configuração encriptada e desliga todas as nuvens';

  @override
  String get clearCredentialsDialogTitle => 'Aviso: Redefinir credenciais';

  @override
  String get clearCredentialsDialogContent =>
      'Tem a certeza de que pretende eliminar todas as credenciais guardadas? Terá de voltar a ligar as suas contas na nuvem.';

  @override
  String get clearCredentialsSuccess => 'Credenciais eliminadas com sucesso';

  @override
  String get aboutUnifyCloud => 'Sobre o UnifyCloud';

  @override
  String get appVersion => 'Versão da aplicação: 1.0.0';

  @override
  String get developerInfo => 'Programador: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Motor: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Licença: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Direitos de autor: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Visão geral do armazenamento';

  @override
  String get connectedClouds => 'Nuvens ligadas';

  @override
  String get noCloudsConfigured => 'Nenhuma conta na nuvem configurada';

  @override
  String get noCloudsDescription =>
      'Ligue a sua primeira conta de armazenamento na nuvem para começar a gerir e sincronizar ficheiros.';

  @override
  String get addCloud => 'Adicionar nuvem';

  @override
  String get used => 'usado';

  @override
  String get free => 'livre';

  @override
  String get total => 'total';

  @override
  String get manageAccounts => 'Gerir contas';

  @override
  String get viewFiles => 'Ver ficheiros';

  @override
  String get createVaultHere => 'Criar cofre encriptado aqui...';

  @override
  String get disconnectAccount => 'Desligar conta';

  @override
  String get disconnectConfirmTitle => 'Desligar conta?';

  @override
  String get disconnectConfirmContent =>
      'Tem a certeza de que pretende desligar esta conta? Os ficheiros remotos permanecerão intactos.';

  @override
  String get allFiles => 'Todos os ficheiros';

  @override
  String get emptyFolder => 'Esta pasta está vazia';

  @override
  String get emptyFolderSubtitle =>
      'Carregue ficheiros ou crie uma subpasta para começar.';

  @override
  String get uploadFile => 'Carregar ficheiro';

  @override
  String get uploadFolder => 'Carregar pasta inteira';

  @override
  String get newFolder => 'Nova pasta';

  @override
  String get newFolderPrompt => 'Introduza o nome da nova pasta:';

  @override
  String get folderNameHint => 'Nome da pasta';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get clearSelection => 'Limpar seleção';

  @override
  String get deleteSelected => 'Eliminar selecionados';

  @override
  String get deleteSelectedPrompt =>
      'Tem a certeza de que deseja eliminar os elementos selecionados?';

  @override
  String get deleteItemPrompt =>
      'Tem a certeza de que deseja eliminar este elemento?';

  @override
  String get shareLink => 'Partilhar ligação';

  @override
  String get createShareLink => 'Criar ligação partilhável';

  @override
  String get copyShareLink => 'Copiar ligação';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get transfers => 'Transferências';

  @override
  String get activeTransfers => 'Transferências ativas';

  @override
  String get completed => 'Concluído';

  @override
  String get failed => 'Falhou';

  @override
  String get queued => 'Em fila';

  @override
  String get cancelTransfer => 'Cancelar transferência';

  @override
  String get clearCompleted => 'Limpar concluídas';

  @override
  String get syncRulesTitle => 'Regras de Backup e Sync';

  @override
  String get newRule => 'Nova regra';

  @override
  String get noSyncRules => 'Nenhuma regra de sincronização configurada';

  @override
  String get noSyncRulesSubtitle =>
      'Crie uma regra automática para sincronizar pastas locais com a sua nuvem.';

  @override
  String get ruleName => 'Nome da regra';

  @override
  String get sourcePath => 'Pasta de origem';

  @override
  String get destinationCloud => 'Nuvem de destino';

  @override
  String get destinationPath => 'Caminho remoto';

  @override
  String get direction => 'Direção';

  @override
  String get frequency => 'Frequência';

  @override
  String get runNow => 'Executar agora';

  @override
  String get syncInProgress => 'Sincronização em curso...';

  @override
  String get syncSuccess => 'Sincronização concluída';

  @override
  String get syncFailed => 'Falha na sincronização';

  @override
  String get addCloudDialogTitle => 'Ligar nova nuvem';

  @override
  String get selectProvider => 'Selecionar fornecedor de nuvem';

  @override
  String get accountNameLabel => 'Nome da conta / Alias';

  @override
  String get connectButton => 'Ligar conta';

  @override
  String get vaultTitle => 'Encriptação E2E (Crypt)';

  @override
  String get vaultPassword => 'Palavra-passe do cofre';

  @override
  String get vaultConfirmPassword => 'Confirmar palavra-passe';

  @override
  String get vaultSalt => 'Salt / Palavra-passe secundária (Opcional)';

  @override
  String get encryptFileNames => 'Encriptar nomes de ficheiros';

  @override
  String get encryptDirNames => 'Encriptar nomes de pastas';

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
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get searchLanguageHint => 'Pesquisar idioma ou país...';

  @override
  String get currentLanguage => 'Idioma atual';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Padrão do sistema ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Atualizar nuvens configuradas';

  @override
  String get storageOverviewAggregated =>
      'Visão geral agregada do armazenamento';

  @override
  String get ramEncryptionActive => 'Encriptação RAM ativa';

  @override
  String connectedAccountsCount(int count) {
    return 'Contas na nuvem ligadas: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Nenhuma conta na nuvem configurada. Toque em «+ Ligar nova nuvem» abaixo.';

  @override
  String percentUsed(String percent) {
    return '$percent% ocupado';
  }

  @override
  String availableSpace(String space) {
    return '$space disponíveis';
  }

  @override
  String get calculatingQuota =>
      'A calcular quotas de armazenamento ou espaço ilimitado...';

  @override
  String get syncAndBackup => 'Sincronização e Cópia de segurança';

  @override
  String get noRulesConfigured => 'Nenhuma regra configurada';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total regras ativas';
  }

  @override
  String get manage => 'Gerir';

  @override
  String connectedCloudsCount(int count) {
    return 'Nuvens ligadas ($count)';
  }

  @override
  String get connectNewCloud => 'Ligar nova nuvem';

  @override
  String get noCloudProvidersConnected => 'Nenhum fornecedor de nuvem ligado';

  @override
  String get connectCloudDescription =>
      'Ligue Google Drive, Dropbox, OneDrive, SFTP ou WebDAV para começar a sincronizar e explorar os seus ficheiros.';

  @override
  String get addFirstCloud => 'Adicionar primeira nuvem';

  @override
  String vaultOnRemote(String remote) {
    return 'COFRE EM $remote';
  }

  @override
  String get disconnectCloudTitle => 'Desligar nuvem';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Pretende desligar «$name»? As credenciais serão removidas do armazenamento seguro.';
  }

  @override
  String get disconnect => 'Desligar';

  @override
  String freeSpace(String space) {
    return '$space livres';
  }

  @override
  String get storage => 'Armazenamento';

  @override
  String get available => 'Disponível';

  @override
  String get exploreFiles => 'Explorar ficheiros';

  @override
  String get paneLeft => 'Esquerda';

  @override
  String get paneRight => 'Direita';

  @override
  String get folderName => 'Nome da pasta';

  @override
  String errorCreatingFolder(String error) {
    return 'Erro ao criar pasta: $error';
  }

  @override
  String get moveAction => 'Mover';

  @override
  String get copyAction => 'Copiar';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action de $count elementos para [$remote] iniciada...';
  }

  @override
  String errorTransferring(String error) {
    return 'Erro durante a transferência: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '«$name» copiado para a área de transferência';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count elementos copiados para a área de transferência';
  }

  @override
  String itemCutToClipboard(String name) {
    return '«$name» cortado (pronto para mover)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count elementos cortados (prontos para mover)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'Nenhum ficheiro selecionado para descarregar.';

  @override
  String downloadingItems(int count) {
    return 'A descarregar $count elementos...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count elementos descarregados com sucesso para «$path»';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Erro ao iniciar transferência: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'Eliminar $count elementos selecionados?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Tem a certeza de que deseja eliminar definitivamente $count elementos selecionados da nuvem?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count elementos eliminados';
  }

  @override
  String errorDeleting(String error) {
    return 'Erro durante a eliminação: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Carregamento concluído com sucesso';

  @override
  String errorUploading(String error) {
    return 'Erro durante o carregamento: $error';
  }

  @override
  String get folderUploadCompletedSuccess => 'Pasta carregada com sucesso';

  @override
  String errorFolderUploading(String error) {
    return 'Erro ao carregar pasta: $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'Os ficheiros já se encontram nesta pasta.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action de $count elementos para [$remote] iniciada...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Erro na transferência arrastar e largar: $error';
  }

  @override
  String get closeSelection => 'Fechar seleção';

  @override
  String itemsSelectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get deselectAll => 'Desmarcar tudo';

  @override
  String copyToRemote(String remote) {
    return 'Copiar para $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Mover para $remote';
  }

  @override
  String get moreActions => 'Mais ações';

  @override
  String get downloadSelected => 'Descarregar selecionados';

  @override
  String get copyToClipboard => 'Copiar para a área de transferência';

  @override
  String get cutToClipboard => 'Cortar para a área de transferência';

  @override
  String get selectCloud => 'Selecionar nuvem';

  @override
  String get closeSearch => 'Fechar pesquisa';

  @override
  String get uploadFromDevice => 'Carregar do dispositivo';

  @override
  String get moreOptions => 'Mais opções';

  @override
  String get viewGrid => 'Vista em grelha';

  @override
  String get viewList => 'Vista em lista';

  @override
  String get multiSelection => 'Seleção múltipla';

  @override
  String get sortNameAsc => 'Nome (A-Z)';

  @override
  String get sortNameDesc => 'Nome (Z-A)';

  @override
  String get sortSizeDesc => 'Tamanho (Maior -> Menor)';

  @override
  String get sortSizeAsc => 'Tamanho (Menor -> Maior)';

  @override
  String get sortDateDesc => 'Data (Mais recente primeiro)';

  @override
  String get disableDualPane => 'Desativar Commander (Painel único)';

  @override
  String get enableDualPane => 'Ativar Commander (Painel duplo)';

  @override
  String itemsInClipboard(int count) {
    return '$count elementos na área de transferência';
  }

  @override
  String get pasteHere => 'Colar aqui';

  @override
  String get noResults => 'Sem resultados';

  @override
  String noMatchingResults(String query) {
    return 'Nenhum ficheiro ou pasta corresponde a «$query»';
  }

  @override
  String get selectACloud => 'Selecione uma nuvem';

  @override
  String get selectCloudDescription =>
      'Selecione um fornecedor de nuvem no menu acima para explorar os seus ficheiros remotos.';

  @override
  String optionsForItem(String name) {
    return 'Opções para $name';
  }

  @override
  String get select => 'Selecionar';

  @override
  String get openWithSystemApp => 'Abrir com aplicação do sistema';

  @override
  String get downloadToLocal => 'Descarregar localmente';

  @override
  String get cut => 'Cortar (Mover)';

  @override
  String get copyPath => 'Copiar caminho';

  @override
  String get info => 'Informações';

  @override
  String generatingShareLink(String name) {
    return 'A gerar ligação para «$name»...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Erro na ligação pública: $error';
  }

  @override
  String get noLinkGenerated => 'Nenhuma ligação gerada pelo fornecedor.';

  @override
  String errorDownloading(String error) {
    return 'Erro durante a descarga: $error';
  }

  @override
  String get renameFolderTitle => 'Mudar o nome da pasta';

  @override
  String get renameFileTitle => 'Mudar o nome do ficheiro';

  @override
  String errorRenaming(String error) {
    return 'Erro ao mudar o nome: $error';
  }

  @override
  String get pathCopiedToClipboard =>
      'Caminho copiado para a área de transferência';

  @override
  String itemDetailsPath(String path) {
    return 'Caminho: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Tipo: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Tamanho: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Data de modificação: $date';
  }

  @override
  String get folder => 'Pasta';

  @override
  String get file => 'Ficheiro';

  @override
  String get selectCloudFirstLeft =>
      'Selecione primeiro uma nuvem no painel esquerdo.';

  @override
  String get selectCloudFirstRight =>
      'Selecione primeiro uma nuvem no painel direito.';

  @override
  String get selectDestinationCloudLeft =>
      'Selecione primeiro uma nuvem de destino no painel esquerdo.';

  @override
  String get selectDestinationCloudRight =>
      'Selecione primeiro uma nuvem de destino no painel direito.';

  @override
  String get noFilesToTransfer =>
      'Nenhum ficheiro presente ou selecionado para transferir.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action de $count elementos de [$src] para [$dst] iniciada...';
  }

  @override
  String get swapPanesTooltip => 'Trocar painéis (<->)';

  @override
  String get refreshBothPanesTooltip => 'Atualizar ambos os painéis';

  @override
  String get copyRight => 'Copiar para a direita ->';

  @override
  String get moveRight => 'Mover para a direita ->';

  @override
  String get copyLeft => '<- Copiar para a esquerda';

  @override
  String get moveLeft => '<- Mover para a esquerda';

  @override
  String copyRightWithCount(int count) {
    return 'Copiar para a direita ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Mover para a direita ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Copiar para a esquerda ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Mover para a esquerda ($count)';
  }

  @override
  String get deleteRuleTitle => 'Eliminar regra';

  @override
  String deleteRulePrompt(String name) {
    return 'Tem a certeza de que deseja eliminar a regra «$name»? Os ficheiros locais e na nuvem serão preservados.';
  }

  @override
  String get syncAll => 'Sincronizar tudo';

  @override
  String get newRuleTooltip => 'Nova regra';

  @override
  String get backupBannerTitle => 'Backup contínuo e sincronização na nuvem';

  @override
  String get backupBannerSubtitle =>
      'Configure sincronizações agendadas entre pastas locais e remotas.';

  @override
  String get noActiveRules => 'Nenhuma regra ativa';

  @override
  String get noActiveRulesSubtitle =>
      'Crie a sua primeira regra para efetuar cópias de segurança automáticas a partir do telemóvel para o Google Drive, Dropbox, SFTP ou outra nuvem.';

  @override
  String get createNewRule => 'Criar nova regra';

  @override
  String get ruleOptionsTooltip => 'Opções da regra';

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get statusWaiting => 'Pendente';

  @override
  String get statusInProgress => 'Em curso...';

  @override
  String get statusCompleted => 'Concluído';

  @override
  String get statusFailed => 'Erro';

  @override
  String get editRuleTitle => 'Editar regra de cópia de segurança';

  @override
  String get newRuleTitle => 'Nova regra de sincronização';

  @override
  String get ruleDialogSubtitle =>
      'Configure cópias de segurança automáticas entre uma pasta local e a nuvem.';

  @override
  String get ruleNameOptional => 'Nome da regra (opcional)';

  @override
  String get ruleNameHint => 'ex. Cópia Fotos DCIM ou Documentos Trabalho';

  @override
  String get sourceLocalFolder => 'Pasta local de origem';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM ou /home/utilizador/Imagens';

  @override
  String get browseFolders => 'Procurar pastas';

  @override
  String get selectLocalFolderError => 'Introduza ou selecione uma pasta local';

  @override
  String get noCloudsConfiguredSync =>
      'Nenhuma nuvem configurada. Configure uma conta a partir da Página Inicial antes de continuar.';

  @override
  String get remoteDestinationPath => 'Caminho remoto de destino';

  @override
  String get syncMode => 'Modo de sincronização';

  @override
  String get syncModeCopy => 'Backup incremental';

  @override
  String get syncModeCopyDesc =>
      'Carrega ficheiros novos e modificados preservando os ficheiros já existentes na nuvem.';

  @override
  String get syncModeSync => 'Sincronização espelho';

  @override
  String get syncModeSyncDesc =>
      'Torna o destino remoto idêntico à pasta local (ficheiros apagados localmente são removidos da nuvem).';

  @override
  String get syncFrequency => 'Frequência de execução';

  @override
  String get freqManual => 'Manual (apenas a pedido)';

  @override
  String get freq15Min => 'A cada 15 minutos';

  @override
  String get freq30Min => 'A cada 30 minutos';

  @override
  String get freqHourly => 'A cada hora';

  @override
  String get freq6Hours => 'A cada 6 horas';

  @override
  String get freq12Hours => 'A cada 12 horas';

  @override
  String get freqDaily => 'Todos os dias (24 horas)';

  @override
  String get activateRuleImmediately => 'Ativar regra imediatamente';

  @override
  String get activateRuleImmediatelyDesc =>
      'A sincronização será executada em segundo plano de acordo com o intervalo especificado';

  @override
  String get updateRule => 'Atualizar';

  @override
  String get saveRule => 'Guardar regra';

  @override
  String get selectCloudProvider => 'Selecionar fornecedor de nuvem:';

  @override
  String get cloudAccountName => 'Nome da conta na nuvem';

  @override
  String get cloudAccountNameHint =>
      'ex. GoogleDrive, TrabalhoDropbox (sem espaços)';

  @override
  String get enterNameError => 'Introduza um nome';

  @override
  String get noSpacesOrColons => 'Espaços e «:» não são permitidos';

  @override
  String get oauthMode => 'Modo Client ID (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Oficial / Recomendado)';

  @override
  String get oauthRclone => 'Rclone (Não recomendado - Quota partilhada)';

  @override
  String get oauthCustom => 'Client ID Pessoal (Avançado)';

  @override
  String get officialOauthTitle => 'Credenciais oficiais UnifyCloud';

  @override
  String get officialOauthDesc =>
      'Credenciais pré-configuradas para ligar imediatamente com quota dedicada e velocidade máxima.';

  @override
  String get rcloneOauthDesc =>
      'Chaves partilhadas de código aberto do Rclone. Podem atingir limites de quota ou originar erros 403 da Google.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination =>
      'Selecione a nuvem de destino para o cofre';

  @override
  String get vaultPasswordRequired =>
      'A palavra-passe de encriptação é obrigatória';

  @override
  String get vaultPasswordsDoNotMatch => 'As palavras-passe não coincidem';

  @override
  String errorAddingRemote(String error) {
    return 'Erro ao adicionar a nuvem: $error';
  }

  @override
  String get fileNameEncryption => 'Encriptação de nomes de ficheiros';

  @override
  String get encryptStandard =>
      'Padrão (Nomes de ficheiro totalmente encriptados - Recomendado)';

  @override
  String get encryptObscure => 'Ofuscação simples (Preserva as extensões)';

  @override
  String get encryptOff => 'Desativado (Nomes visíveis em texto simples)';

  @override
  String get encryptFolderNames => 'Encriptar também os nomes das pastas';

  @override
  String get encryptFolderNamesDesc =>
      'Oculta totalmente a estrutura de diretórios na nuvem';

  @override
  String get connectCloud => 'Ligar nuvem';

  @override
  String get reopenAuth => 'Reabrir';

  @override
  String get linkCopiedToClipboard =>
      'Ligação copiada para a área de transferência!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Não foi possível abrir o navegador: $error';
  }

  @override
  String get shareableLinkTitle => 'Ligação partilhável';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Qualquer pessoa com esta ligação poderá aceder a $item:';
  }

  @override
  String get open => 'Abrir';

  @override
  String activeTransfersCount(int count) {
    return '$count transferências ativas';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Fila de transferências ($count)';
  }

  @override
  String get noTransfersInProgress => 'Nenhuma transferência em curso';

  @override
  String get transfersEmptySubtitle =>
      'Todos os ficheiros descarregados ou carregados aparecerão aqui';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get appLockedTitle => 'Aplicação bloqueada';

  @override
  String get unlockWithBiometrics => 'Desbloquear com biometria';

  @override
  String get pinMustBe6Digits => 'O PIN deve ter exatamente 6 dígitos';

  @override
  String get pinIncorrect => 'Código PIN incorreto. Tente novamente.';

  @override
  String get pinsDoNotMatch => 'Os códigos PIN não coincidem. Tente novamente.';

  @override
  String get pinStepOld => 'Introduza o seu PIN atual para continuar.';

  @override
  String get pinStepNew => 'Introduza o seu novo PIN de 6 dígitos.';

  @override
  String get pinStepConfirm => 'Reintroduza o novo PIN para confirmação.';

  @override
  String get pinStepVerify => 'Introduza o seu PIN para confirmar a operação.';

  @override
  String get pinTitleSetup => 'Configurar PIN de segurança';

  @override
  String get pinTitleChange => 'Alterar PIN de segurança';

  @override
  String get pinTitleVerify => 'Verificação de segurança';

  @override
  String get pinContinue => 'Continuar';

  @override
  String get errorDetails => 'Detalhes do erro';

  @override
  String get errorDetailsCopied =>
      'Detalhes do erro copiados para a área de transferência';

  @override
  String get collapse => 'Recolher';

  @override
  String get expand => 'Expandir';

  @override
  String get copyError => 'Copiar erro';

  @override
  String get errorNetwork =>
      'Ligação ausente ou instável. Verifique a sua ligação à Internet e tente novamente.';

  @override
  String get errorDiskSpace =>
      'Espaço de armazenamento insuficiente ou disco cheio. Liberte memória para continuar.';

  @override
  String get errorAuthExpired =>
      'Sessão ou token expirado/revogado. Volte a ligar a sua conta.';

  @override
  String get errorNotFound =>
      'Elemento ou pasta não encontrado no fornecedor de nuvem.';

  @override
  String get errorPermissionDenied =>
      'Permissão recusada para executar esta operação na nuvem.';

  @override
  String get errorGeneric => 'Ocorreu um erro durante a operação.';
}
