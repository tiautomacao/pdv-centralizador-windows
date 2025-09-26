; teste_mac_wmi.nsi
Name "Teste MAC Address com WMI"
OutFile "Teste_MAC_WMI.exe"
RequestExecutionLevel user
!include "LogicLib.nsh" ; Suporte para ${If}, ${Else}, etc.

Section "Main"
  ; Executa PowerShell para capturar o MAC Address do primeiro adaptador ativo
  nsExec::ExecToStack 'powershell -Command "Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true -and $_.MACAddress -ne $null } | Select-Object -First 1 | Select-Object -ExpandProperty MACAddress"'
  Pop $0  ; Código de retorno (0 = sucesso)
  Pop $1  ; MAC Address

  ${If} $0 != 0
    MessageBox MB_OK|MB_ICONSTOP "Erro ao executar o comando PowerShell: Código $0"
    Abort
  ${EndIf}

  ${If} $1 == ""
    MessageBox MB_OK|MB_ICONSTOP "Nenhum MAC Address encontrado. Verifique se há adaptadores de rede ativos."
    Abort
  ${EndIf}

  ; Exibe o MAC Address
  MessageBox MB_OK|MB_ICONINFORMATION "MAC Address encontrado: $1"
SectionEnd