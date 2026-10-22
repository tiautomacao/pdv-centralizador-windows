; ===================================================
; INSTALADOR CENTRALIZER WINDOWS + PRINT SERVER
; Autor: TI Automacao Comercial
; Versao: 2026.01.22.140
; ===================================================

; --- Inclusoes e Definicoes Globais ---
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "StrFunc.nsh"
${StrRep}
${StrTrimNewLines}
!addplugindir "Plugins\x86-unicode"

; --- Informacoes do Instalador ---
Name "Centralizer Windows"
OutFile "Instalador_PDV_Centralizador_PrintServer_v2026.01.22.140.exe"
InstallDir "C:\xampp"
RequestExecutionLevel admin
SetCompressor zlib
Unicode true

; --- DEFINICOES PARA O ATALHO ---
!define SHORTCUT_NAME "Painel Centralizador"
!define SHORTCUT_URL "http://localhost/suporte"
!define SHORTCUT_ICON "suporte.ico"

; --- Variaveis Globais para Pagina de Licenca ---
Var DialogoLicenca
Var InputCNPJ
Var InputMAC
Var LocalMacAddress
Var GlobalCNPJ

; --- Interface Grafica e Icones ---
!define MUI_ICON "suporte.ico"
!define MUI_UNICON "suporte.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "splash.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "splash.bmp"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

; --- Paginas do Instalador ---
!insertmacro MUI_PAGE_WELCOME
Page custom PaginaLicencaShow PaginaLicencaLeave "Ativação de Licença"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; --- Paginas do Desinstalador ---
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; --- Idioma ---
!insertmacro MUI_LANGUAGE "PortugueseBR"

; ===================================================
; FUNCOES DA PAGINA DE LICENCA (SUPABASE)
; ===================================================
Function PaginaLicencaShow
  # Obtem o MAC Address local
  nsExec::ExecToStack 'powershell -Command "Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true -and $_.MACAddress -ne $null } | Select-Object -First 1 | Select-Object -ExpandProperty MACAddress"'
  Pop $0
  Pop $LocalMacAddress
  ${StrTrimNewLines} $LocalMacAddress $LocalMacAddress

  ${If} $0 != 0
    MessageBox MB_OK|MB_ICONSTOP "Erro ao obter ID do Computador (MAC): Codigo $0"
    Abort
  ${EndIf}

  # Formata o MAC de : para -
  StrCpy $1 $LocalMacAddress
  ${StrRep} $LocalMacAddress $1 ":" "-"

  nsDialogs::Create 1018
  Pop $DialogoLicenca

  ${If} $DialogoLicenca == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 24u "Para continuar, identifique a licença do cliente abaixo.$\nUtilize o CNPJ ou o Código da Filial fornecido."
  
  ${NSD_CreateLabel} 0 35u 30% 12u "CNPJ ou Cód. Filial:"
  ${NSD_CreateText} 32% 33u 60% 12u ""
  Pop $InputCNPJ
  
  ${NSD_CreateLabel} 0 60u 30% 12u "MAC:"
  ${NSD_CreateText} 32% 58u 60% 12u "$LocalMacAddress"
  Pop $InputMAC
  EnableWindow $InputMAC 0

  nsDialogs::Show
FunctionEnd

Function PaginaLicencaLeave
  ${NSD_GetText} $InputCNPJ $R0
  StrCpy $GlobalCNPJ $R0 

  ${If} $R0 == ""
    MessageBox MB_OK|MB_ICONEXCLAMATION "Por favor, informe o CNPJ ou Código da Filial."
    Abort
  ${EndIf}

  !define SUPABASE_ANON_KEY "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1tcnd4ZmF1b3Zubmhud3prcWp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc3OTM5NzgsImV4cCI6MjA0MzM2OTk3OH0.-agBrqe0lIf5LtEsQ7lPHhwGtJChYHQXQyW2sHb8LMQ"

  SetOutPath "$TEMP"
  File "validar.ps1"
  File "registrar-mac.ps1"

  # Chama o script de validacao (Agora com apenas 3 parametros)
  nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\validar.ps1" "$R0" "${SUPABASE_ANON_KEY}" "$LocalMacAddress"'
  Pop $R4 
  StrCpy $R9 $R4 

  ${If} $R4 == 0
    # Licenca OK e MAC ja vinculado
    goto licencaOK
  ${ElseIf} $R4 == 4
    # Licenca OK mas sem MAC vinculado (Sera registrado na SecMain)
    goto licencaOK
  ${ElseIf} $R4 == 3
    MessageBox MB_OK|MB_ICONSTOP "Esta licença já está vinculada a outro computador!"
    Abort
  ${Else}
    MessageBox MB_OK|MB_ICONSTOP "Licença não encontrada ou erro de conexão com o servidor."
    Abort
  ${EndIf}
  
licencaOK:
FunctionEnd

; ===================================================
; SECOES DE INSTALACAO
; ===================================================
Section "Pre-requisitos (VC++)" SecPrereq
  SectionIn RO
  SetOutPath "$PLUGINSDIR"
  File "VC_redist.x64.exe"
  ExecWait '"$PLUGINSDIR\VC_redist.x64.exe" /install /quiet /norestart'
SectionEnd

Section "Sistema Principal e Servicos" SecMain
  ; --- Parar servicos se ja existirem para destravar arquivos/DLLs ---
  ExecWait 'net stop Apache2.4'
  ExecWait 'net stop MySQL'

  ; --- Arquivos XAMPP (Copia com protecao total do banco de dados) ---
  ; Se ja existir instalacao com dados, NUNCA sobrescreve ibdata1 nem bases existentes!
  ${If} ${FileExists} "$INSTDIR\mysql\data\ibdata1"
    ; Copia todo o XAMPP exceto a pasta mysql\data
    SetOutPath "$INSTDIR"
    File /r /x "data" "xampp\*.*"
    
    ; Da pasta mysql\data, garante apenas o banco walinux se ele ainda nao existir
    ${IfNot} ${FileExists} "$INSTDIR\mysql\data\walinux\*.*"
      SetOutPath "$INSTDIR\mysql\data\walinux"
      File /r "xampp\mysql\data\walinux\*.*"
    ${EndIf}
  ${Else}
    ; Primeira instalacao do computador: instala tudo incluindo data
    SetOutPath "$INSTDIR"
    File /r "xampp\*.*"
  ${EndIf}
  File "${SHORTCUT_ICON}"

  ; --- PASTA PRINT SERVER ---
  SetOutPath "C:\PrintServerTI"
  File /r "PrintServerTI\*.*"

  ; --- ARQUIVOS MSWINLOG (SYSTEM32 E SYSWOW64) ---
  SetOutPath "$WINDIR\System32"
  File "mswinlog.txt"
  
  ${If} ${FileExists} "$WINDIR\SysWOW64"
    SetOutPath "$WINDIR\SysWOW64"
    File "mswinlog.txt"
  ${EndIf}

  ; --- Configuracao de Servicos ---
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k install'
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --install'
  ExecWait 'sc start Apache2.4'
  ExecWait 'sc start MySQL'
  
  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; --- Registro do MAC (Se for licenca nova/nao vinculada) ---
  ${If} $R9 == 4
      SetOutPath "$TEMP"
      File "registrar-mac.ps1"
      nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\registrar-mac.ps1" -CnpjCpf "$GlobalCNPJ" -MacAddress "$LocalMacAddress" -ApiKey "${SUPABASE_ANON_KEY}"'
  ${EndIf}
SectionEnd

Section "Criar Atalhos" SecShortcut
  SetShellVarContext current

  ; --- Atalhos na Area de Trabalho ---
  StrCpy $R0 "$DESKTOP\${SHORTCUT_NAME}.url"
  WriteINIStr $R0 "InternetShortcut" "URL" "${SHORTCUT_URL}"
  WriteINIStr $R0 "InternetShortcut" "IconFile" "$INSTDIR\${SHORTCUT_ICON}"
  WriteINIStr $R0 "InternetShortcut" "IconIndex" "0"

  CreateShortcut "$DESKTOP\PrintServer.lnk" "C:\PrintServerTI\ServerPrintProducao.exe"
  CreateShortcut "$SMPROGRAMS\PrintServer.lnk" "C:\PrintServerTI\ServerPrintProducao.exe"

  System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
SectionEnd

; --- Descricoes ---
LangString DESC_SecPrereq ${LANG_PORTUGUESEBR} "Microsoft VC++ Redistributable."
LangString DESC_SecMain ${LANG_PORTUGUESEBR} "XAMPP, PrintServer e Logs."
LangString DESC_SecShortcut ${LANG_PORTUGUESEBR} "Atalhos no Desktop e Menu Iniciar."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPrereq} $(DESC_SecPrereq)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcut} $(DESC_SecShortcut)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function LaunchLink
  ExecShell "open" "$INSTDIR\monitorarBackupCentralizador.exe"
FunctionEnd

; ===================================================
; SECAO DO DESINSTALADOR
; ===================================================
Section "Uninstall"
  SetShellVarContext current

  ; Para e remove servicos
  ExecWait 'sc stop Apache2.4'
  ExecWait 'sc stop MySQL'
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k uninstall'
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --remove'
  
  ; Remove arquivos adicionados
  Delete "$WINDIR\System32\mswinlog.txt"
  Delete "$WINDIR\SysWOW64\mswinlog.txt"
  RMDir /r "C:\PrintServerTI"
  
  Delete "$INSTDIR\${SHORTCUT_ICON}"
  RMDir /r "$INSTDIR"
  
  Delete "$DESKTOP\${SHORTCUT_NAME}.url"
  Delete "$DESKTOP\PrintServer.lnk"
  Delete "$SMPROGRAMS\PrintServer.lnk"
SectionEnd
