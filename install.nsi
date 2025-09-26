; ===================================================
; INSTALADOR CENTRALIZER WINDOWS - VERSAO FINAL
; Autor: TI Automacao Comercial
; Data: 27/08/2025
; ===================================================

; --- Inclusoes e Definicoes Globais ---
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "StrFunc.nsh"  ; Para manipulacao de strings (conversao do formato do MAC)
${StrRep}
!addplugindir "Plugins\x86-unicode" ; Aponta para a pasta dos plugins Unicode

; --- Informacoes do Instalador ---
Name "Centralizer Windows"
OutFile "Instalador_PDV_Centralizer_v3.0.exe"
InstallDir "C:\xampp"
RequestExecutionLevel admin
SetCompressor zlib

; --- Variaveis Globais para Pagina de Licenca ---
Var DialogoLicenca
Var InputCNPJ
Var InputToken
Var InputMAC
Var LocalMacAddress

; --- Interface Grafica e Icones ---
!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "splash.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "splash.bmp"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

; --- Paginas do Instalador ---
!insertmacro MUI_PAGE_WELCOME
Page custom PaginaLicencaShow PaginaLicencaLeave "License Access"
!insertmacro MUI_PAGE_COMPONENTS
#!insertmacro MUI_PAGE_DIRECTORY
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
  ; Usa PowerShell com WMI para capturar o MAC Address
  nsExec::ExecToStack 'powershell -Command "Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true -and $_.MACAddress -ne $null } | Select-Object -First 1 | Select-Object -ExpandProperty MACAddress"'
  Pop $0  ; Codigo de retorno
  Pop $LocalMacAddress  ; MAC Address

  ${If} $0 != 0
    MessageBox MB_OK|MB_ICONSTOP "Erro ao obter MAC Address: Codigo $0"
    Abort
  ${EndIf}

  ${If} $LocalMacAddress == ""
    MessageBox MB_OK|MB_ICONSTOP "Nenhum MAC Address encontrado. Verifique sua conexao de rede."
    Abort
  ${EndIf}

  ; Converte ":" para "-" para compatibilidade com formato esperado (ex.: Supabase)
  StrCpy $1 $LocalMacAddress
  ${StrRep} $LocalMacAddress $1 ":" "-"

  ; Cria a janela de dialogo
  nsDialogs::Create 1018
  Pop $DialogoLicenca
  ${If} $DialogoLicenca == error
    Abort
  ${EndIf}

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

  StrCmp $R0 "" erroCamposVazios
  StrCmp $R1 "" erroCamposVazios

  DetailPrint "Verificando licenca online..."
  
  !define SUPABASE_ANON_KEY "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVoeGFtYmdkamttZGdvYXJlenRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MjM2OTksImV4cCI6MjA1OTE5OTY5OX0.eWbosa73xQPofo4_nantz5gKlLPRFuiYBRcIu0fZTMg"

  SetOutPath "$TEMP"
  File "validar.ps1"
  File "registrar-mac.ps1"  ; Adiciona o script de registro

  ; Executa a validacao, passando o MAC local como argumento
  nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\validar.ps1" "$R0" "$R1" "${SUPABASE_ANON_KEY}" "$LocalMacAddress"'
  Pop $R4 ; Codigo de retorno do nsExec

  ; Armazena o resultado para usar depois na secao de instalacao
  StrCpy $R9 $R4 

  ${If} $R4 == 0
    DetailPrint "Licenca validada com sucesso!"
    goto licencaOK
  ${ElseIf} $R4 == 4
    DetailPrint "Primeiro acesso. A licenca sera vinculada a este computador."
    goto licencaOK
  ${ElseIf} $R4 == 1
    goto licencaInvalida
  ${ElseIf} $R4 == 3
    goto macInvalido
  ${Else}
    MessageBox MB_OK|MB_ICONSTOP "Erro de conexao! Nao foi possivel verificar a licenca."
    Abort
  ${EndIf}
  
macInvalido:
  MessageBox MB_OK|MB_ICONSTOP "Este computador nao esta autorizado. O MAC Address nao corresponde ao registrado para esta licenca."
  Abort

licencaInvalida:
  MessageBox MB_OK|MB_ICONSTOP "Licenca invalida! Verifique seu CNPJ e Token de Acesso ou contate suporte."
  Abort

erroCamposVazios:
  MessageBox MB_OK|MB_ICONSTOP "Por favor, preencha ambos os campos: CNPJ e Token."
  Abort
  
licencaOK:
  ; Funcao termina sem 'Abort', permitindo a instalacao continuar
FunctionEnd

; ===================================================
; SECOES DE INSTALACAO
; ===================================================
LangString DESC_SecPrereq ${LANG_PORTUGUESEBR} "Instala pre-requisitos essenciais (Microsoft VC++)."
LangString DESC_SecMain ${LANG_PORTUGUESEBR} "Instala o servidor XAMPP e os arquivos do sistema."
LangString DESC_SecShortcut ${LANG_PORTUGUESEBR} "Cria um atalho na area de trabalho."

Section "Pre-requisitos (VC++)" SecPrereq
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
  DetailPrint "Registrando servico do Apache..."
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k install'
  DetailPrint "Registrando servico do MySQL..."
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --install'
  DetailPrint "Iniciando servicos..."
  ExecWait 'net start Apache2.4'
  ExecWait 'net start MySQL'
  WriteUninstaller "$INSTDIR\uninstall.exe"

; --- LOGICA DE REGISTRO DO MAC ---
; Executa somente se a validacao retornou codigo 4 (primeiro acesso)
${If} $R9 == 4
    DetailPrint "Registrando o MAC Address deste computador na licenca..."
    DetailPrint "Validation return code (R9): $R9"
    SetOutPath "$TEMP"
    File "registrar-mac.ps1"

    ; Le os valores do CNPJ e Token diretamente dos campos de texto
    ${NSD_GetText} $InputCNPJ $R0
    ${NSD_GetText} $InputToken $R1
    
    ; Debug: Log dos parametros antes da execucao
    DetailPrint "Parameters - CNPJ: $R0, Token: $R1, MAC: $LocalMacAddress, API Key: ${SUPABASE_ANON_KEY}"
    
    ; Executa o registro, capturando o codigo de retorno e saida
    nsExec::ExecToStack 'powershell.exe -ExecutionPolicy Bypass -File "$TEMP\registrar-mac.ps1" -CnpjCpf "$R0" -TokenAcesso "$R1" -MacAddress "$LocalMacAddress" -ApiKey "${SUPABASE_ANON_KEY}"'
    Pop $0  ; Codigo de retorno
    Pop $1  ; Saida (se houver)

    DetailPrint "PowerShell execution return code: $0"
    DetailPrint "PowerShell output: $1"

    ${If} $0 != 0
      DetailPrint "Erro registrando MAC Address. Return code: $0, Output: $1"
    ${Else}
      DetailPrint "Registro concluido com sucesso."
    ${EndIf}
${Else}
    DetailPrint "Nenhum registro necessario. R9 value: $R9"
${EndIf}

SectionEnd

Section "Criar Atalho na Area de Trabalho" SecShortcut
  CreateShortcut "$DESKTOP\Painel XAMPP.lnk" "$INSTDIR\xampp-control.exe" "" "$INSTDIR\xampp-control.exe" 0
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPrereq} $(DESC_SecPrereq)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcut} $(DESC_SecShortcut)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ===================================================
; FUNCAO PARA EXECUTAR NO FINAL DA INSTALACAO
; ===================================================
Function LaunchLink
  ExecShell "open" "$INSTDIR\xampp-control.exe"
FunctionEnd

; ===================================================
; SECAO DO DESINSTALADOR
; ===================================================
Section "Uninstall"
  DetailPrint "Parando e removendo servicos..."
  ExecWait 'net stop Apache2.4'
  ExecWait 'net stop MySQL'
  ExecWait '"$INSTDIR\apache\bin\httpd.exe" -k uninstall'
  ExecWait '"$INSTDIR\mysql\bin\mysqld.exe" --remove'
  DetailPrint "Removendo arquivos..."
  RMDir /r "$INSTDIR"
  DetailPrint "Removendo atalhos..."
  Delete "$DESKTOP\Painel XAMPP.lnk"
SectionEnd