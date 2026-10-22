# validar.ps1 (Versão Final: Tabela LICENCA_SERVER e Coluna 'mac')

param(
    [string]$CnpjCpf,
    [string]$ApiKey,
    [string]$LocalMacAddress
)

# Força o uso de TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$CnpjCpf = $CnpjCpf -replace '\.', '' -replace '/', '' -replace '-', ''

try {
    $headers = @{
        "apikey" = $ApiKey
    }

    # --- Tentativa 1: Busca por CNPJ ---
    $uri = "https://mmrwxfauovnnhnwzkqjy.supabase.co/rest/v1/LICENCA_SERVER?select=mac&cnpj=eq.$CnpjCpf&ativo=is.true"
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers

    # --- Tentativa 2: Fallback por Código da Filial ---
    if ($null -eq $response -or $response.Count -eq 0) {
        $uriFilial = "https://mmrwxfauovnnhnwzkqjy.supabase.co/rest/v1/LICENCA_SERVER?select=mac&cod_filial=eq.$CnpjCpf&ativo=is.true"
        $response = Invoke-RestMethod -Uri $uriFilial -Method Get -Headers $headers
    }

    # Validação final: se não encontrou em nenhum dos campos
    if ($null -eq $response -or $response.Count -eq 0) {
        exit 1
    }

    # A coluna agora chama-se 'mac'
    $dbMacAddress = $response[0].mac

    # Se a licença existe mas não tem MAC vinculado
    if ([string]::IsNullOrEmpty($dbMacAddress)) {
        exit 4
    }

    # Se o MAC coincide
    if ($dbMacAddress -eq $LocalMacAddress) {
        exit 0
    }

    # Se o MAC é diferente
    if ($dbMacAddress -ne $LocalMacAddress) {
        exit 3
    }
}
catch {
    exit 2
}
