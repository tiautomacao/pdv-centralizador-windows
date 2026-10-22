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
; NOME DO ARQUIVO ATUALIZADO ABAIXO
OutFile "Instalador_PDV_Centralizador_PrintServer_v2026.01.22.140.exe"
InstallDir "C:\xampp"
RequestExecutionLevel admin
SetCompressor zlib

; --- DEFINICOES PARA O ATALHO ---
!define SHORTCUT_NAME "Painel Centralizador"
!define SHORTCUT_URL "http://localhost/suporte"
!define SHORTCUT_ICON "suporte.ico"

; --- Variaveis Globais para Pagina de Licenca ---
Var DialogoLicenca
Var InputCNPJ
Var InputToken
Var InputMAC
Var LocalMacAddress
Var GlobalCNPJ
Var GlobalToken

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
Page custom PaginaLicencaShow PaginaLicencaLeave "License Access"
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
  nsExec::ExecToStack 'powershell -Command "Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true -and $_.MACAddress -ne $null } | Select-Object -First 1 | Select-Object -ExpandProperty MACAddress"'
  Pop $0
  Pop $LocalMacAddress
  ${StrTrimNewLines} $LocalMacAddress $LocalMacAddress

  ${If} $0 != 0
    MessageBox MB_OK|MB_ICONSTOP "Erro ao obter MAC Address: Codigo $0"
    Abort
  ${EndIf}

  StrCpy $1 $LocalMacAddress
  ${StrRep} $LocalMacAddress $1 ":" "-"

  nsDialogs::Create 1018
  Pop $DialogoLicenca

  ${NSD_CreateLabel} 0 0 100% 12 "Por favor, insira os dados da sua licenca para continuar."
  ${NSD_CreateLabel} 0 30 20% 12 "CNPJ:"
  ${NSD_CreateText} 22% 28 70% 14u ""
  Pop $InputCNPJ
  
  ${NSD_CreateLabel} 0 55 20% 12 "Token de Acesso:"
  ${NSD_CreateText} 22% 53 70% 14u ""
  Pop $InputToken
  
  ${NSD_CreateLabel} 0 80 20% 12 "MAC Address:"
  ${NSD_CreateText} 22% 78 70% 14u ""
  Pop $InputMAC
  ${NSD_SetText} $InputMAC $LocalMacAddress
  EnableWindow $InputMAC 0

  nsDialogs::Show
FunctionEnd

Function PaginaLicencaLeave
  ${NSD_GetText} $InputCNPJ $R0
  ${NSD_GetText} $InputToken $R1
  StrCpy $GlobalCNPJ $R0 
  StrCpy $GlobalToken $R1

  !define SUPABASE_ANON_KEY "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVoeGFtYmdkamttZGdvYXJlenRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MjM2OTksImV4cCI6MjA1OTE5OTY5OX0.eWbosa73xQPofo4_nantz5gKlLPRFuiYBRcIu0fZTMg"

  SetOutPath "$TEMP"
  File "validar.ps1"
  File "registrar-mac.ps1"

  nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\validar.ps1" "$R0" "$R1" "${SUPABASE_ANON_KEY}" "$LocalMacAddress"'
  Pop $R4 
  StrCpy $R9 $R4 

  ${If} $R4 == 0
    goto licencaOK
  ${ElseIf} $R4 == 4
    goto licencaOK
  ${Else}
    MessageBox MB_OK|MB_ICONSTOP "Erro de licenca ou conexao!"
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
  ; --- Arquivos XAMPP ---
  SetOutPath "$INSTDIR"
  File /r "xampp\*.*"
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

  ; --- Registro do MAC no Supabase ---
  ${If} $R9 == 4
      SetOutPath "$TEMP"
      File "registrar-mac.ps1"
      nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\registrar-mac.ps1" -CnpjCpf "$GlobalCNPJ" -TokenAcesso "$GlobalToken" -MacAddress "$LocalMacAddress" -ApiKey "${SUPABASE_ANON_KEY}"'
  ${EndIf}
SectionEnd

Section "Criar Atalhos" SecShortcut
  SetShellVarContext current

  ; --- Atalhos na Area de Trabalho ---
  ; Painel Centralizador (URL)
  StrCpy $R0 "$DESKTOP\${SHORTCUT_NAME}.url"
  WriteINIStr $R0 "InternetShortcut" "URL" "${SHORTCUT_URL}"
  WriteINIStr $R0 "InternetShortcut" "IconFile" "$INSTDIR\${SHORTCUT_ICON}"
  WriteINIStr $R0 "InternetShortcut" "IconIndex" "0"

  ; PrintServer (Executavel)
  CreateShortcut "$DESKTOP\PrintServer.lnk" "C:\PrintServerTI\ServerPrintProducao.exe"

  ; --- NOVO: Atalho no Menu Iniciar ---
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
  ExecWait 'sc start MySQL' ; Nota: sc stop seria o correto aqui, ajustado abaixo
  ExecWait 'sc stop MySQL'
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k uninstall'
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --remove'
  
  ; Remove arquivos adicionados
  Delete "$WINDIR\System32\mswinlog.txt"
  Delete "$WINDIR\SysWOW64\mswinlog.txt"
  RMDir /r "C:\PrintServerTI"
  
  ; Remove XAMPP e Icones
  Delete "$INSTDIR\${SHORTCUT_ICON}"
  RMDir /r "$INSTDIR"
  
  ; Remove atalhos
  Delete "$DESKTOP\${SHORTCUT_NAME}.url"
  Delete "$DESKTOP\PrintServer.lnk"
  Delete "$SMPROGRAMS\PrintServer.lnk"
SectionEnd