# validar.ps1 (Corrigido com a ordem correta)

# O bloco de parâmetros foi movido para o topo do script, como é exigido.
param(
    [string]$CnpjCpf,
    [string]$TokenAcesso,
    [string]$ApiKey,
    [string]$LocalMacAddress
)

# A linha que força o TLS 1.2 agora vem DEPOIS dos parâmetros.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    $uri = "https://uhxambgdjkmdgoarezto.supabase.co/rest/v1/licencas?select=mac_vinculado&cnpj_cpf=eq.$CnpjCpf&token_acesso=eq.$TokenAcesso&ativo=is.true"
    
    $headers = @{
        "apikey" = $ApiKey
    }

    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers

    if ($null -eq $response -or $response.Count -eq 0) {
        exit 1
    }

    $dbMacAddress = $response[0].mac_vinculado

    if ([string]::IsNullOrEmpty($dbMacAddress)) {
        exit 4
    }

    if ($dbMacAddress -eq $LocalMacAddress) {
        exit 0
    }

    if ($dbMacAddress -ne $LocalMacAddress) {
        exit 3
    }
}
catch {
    exit 2
}