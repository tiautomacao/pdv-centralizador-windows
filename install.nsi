; ===================================================
; INSTALADOR CENTRALIZADOR WINDOWS - VERSÃO FINAL
; Autor: TI Automação Comercial
; Data: 27/08/2025
; ===================================================

; --- Inclusões e Definições Globais ---
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!addplugindir "Plugins\x86-unicode" ; Aponta para a pasta dos plugins Unicode

; --- Informações do Instalador ---
Name "Centralizador Windows"
OutFile "Instalador_PDV_Centralizador_v3.0.exe"
InstallDir "C:\xampp"
RequestExecutionLevel admin
SetCompressor zlib

; --- Variáveis Globais para a Página de Licença ---
Var DialogoLicenca
Var InputCNPJ
Var InputToken

; --- Interface Gráfica e Ícones ---
!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "splash.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "splash.bmp"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

; --- Páginas do Instalador ---
!insertmacro MUI_PAGE_WELCOME
Page custom PaginaLicencaShow PaginaLicencaLeave "Licença de Acesso"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; --- Páginas do Desinstalador ---
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; --- Idioma ---
!insertmacro MUI_LANGUAGE "PortugueseBR"

; ===================================================
; FUNÇÕES DA PÁGINA DE LICENÇA (SUPABASE)
; ===================================================
Function PaginaLicencaShow
  nsDialogs::Create 1018
  Pop $DialogoLicenca
  ${If} $DialogoLicenca == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 12 "Por favor, insira os dados da sua licença para continuar."
  ${NSD_CreateLabel} 0 30 20% 12 "CNPJ:"
  ${NSD_CreateText} 22% 28 70% 14u ""
  Pop $InputCNPJ
  
  ${NSD_CreateLabel} 0 55 20% 12 "Token de Acesso:"
  ${NSD_CreateText} 22% 53 70% 14u ""
  Pop $InputToken

  nsDialogs::Show
FunctionEnd

Function PaginaLicencaLeave
  ${NSD_GetText} $InputCNPJ $R0
  ${NSD_GetText} $InputToken $R1

  StrCmp $R0 "" erroCamposVazios
  StrCmp $R1 "" erroCamposVazios

  DetailPrint "Verificando licença online com Supabase..."
  
  !define SUPABASE_ANON_KEY "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVoeGFtYmdkamttZGdvYXJlenRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MjM2OTksImV4cCI6MjA1OTE5OTY5OX0.eWbosa73xQPofo4_nantz5gKlLPRFuiYBRcIu0fZTMg"

  SetOutPath "$TEMP"
  File "validar.ps1"

  nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\validar.ps1" $R0 $R1 "${SUPABASE_ANON_KEY}"'
  Pop $R4 ; Retorno do nsExec

  ${If} $R4 == 0
    DetailPrint "Licença Supabase validada com sucesso!"
    goto licencaOK
  ${ElseIf} $R4 == 1
    goto licencaInvalida
  ${Else}
    MessageBox MB_OK|MB_ICONSTOP "Erro de conexão! Não foi possível verificar a licença. Verifique sua internet."
    Abort
  ${EndIf}
  
  licencaInvalida:
  MessageBox MB_OK|MB_ICONSTOP "Licença inválida! Verifique seu CNPJ e Token de Acesso ou contate o suporte."
  Abort

  erroCamposVazios:
  MessageBox MB_OK|MB_ICONSTOP "Por favor, preencha ambos os campos: CNPJ e Token."
  Abort
  
  licencaOK:
FunctionEnd

; ===================================================
; SEÇÕES DE INSTALAÇÃO
; ===================================================
LangString DESC_SecPrereq ${LANG_PORTUGUESEBR} "Instala pré-requisitos essenciais (Microsoft VC++)."
LangString DESC_SecMain ${LANG_PORTUGUESEBR} "Instala o servidor XAMPP e os arquivos do sistema."
LangString DESC_SecShortcut ${LANG_PORTUGUESEBR} "Cria um atalho na Área de Trabalho."

Section "Pré-requisitos (VC++)" SecPrereq
  SectionIn RO
  DetailPrint "Instalando Microsoft VC++ Redistributable..."
  SetOutPath "$PLUGINSDIR"
  File "VC_redist.x64.exe"
  ExecWait '"$PLUGINSDIR\VC_redist.x64.exe" /install /quiet /norestart'
SectionEnd

Section "Sistema XAMPP" SecMain
  DetailPrint "Copiando arquivos do sistema. Isso pode levar alguns minutos..."
  SetOutPath "$INSTDIR"
  File /r "xampp\*.*"
  DetailPrint "Registrando serviço do Apache..."
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k install'
  DetailPrint "Registrando serviço do MySQL..."
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --install'
  DetailPrint "Iniciando serviços..."
  ExecWait 'net start Apache2.4'
  ExecWait 'net start MySQL'
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Criar Atalho na Área de Trabalho" SecShortcut
  CreateShortcut "$DESKTOP\Painel XAMPP.lnk" "$INSTDIR\xampp-control.exe" "" "$INSTDIR\xampp-control.exe" 0
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPrereq} $(DESC_SecPrereq)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcut} $(DESC_SecShortcut)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ===================================================
; FUNÇÃO PARA EXECUTAR NO FINAL DA INSTALAÇÃO
; ===================================================
Function LaunchLink
  ExecShell "open" "$INSTDIR\xampp-control.exe"
FunctionEnd

; ===================================================
; SEÇÃO DO DESINSTALADOR
; ===================================================
Section "Uninstall"
  DetailPrint "Parando e removendo serviços..."
  ExecWait 'net stop Apache2.4'
  ExecWait 'net stop MySQL'
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k uninstall'
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --remove'
  DetailPrint "Removendo arquivos..."
  RMDir /r "$INSTDIR"
  DetailPrint "Removendo atalhos..."
  Delete "$DESKTOP\Painel XAMPP.lnk"
SectionEnd