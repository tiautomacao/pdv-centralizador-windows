# registrar-mac.ps1 (Sincronizado com LICENCA_SERVER e Coluna 'mac')

param(
    [string]$CnpjCpf,
    [string]$MacAddress,
    [string]$ApiKey
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    # Headers para o Supabase REST API
    $headers = @{
        "apikey"        = $ApiKey
        "Authorization" = "Bearer $ApiKey"
        "Content-Type"  = "application/json"
        "Prefer"        = "return=minimal"
    }

    # Corpo: atualizando a coluna 'mac'
    $body = @{
        mac = $MacAddress
    } | ConvertTo-Json

    # 1. Tenta atualizar pelo CNPJ
    $uriCnpj = "https://mmrwxfauovnnhnwzkqjy.supabase.co/rest/v1/LICENCA_SERVER?cnpj=eq.$CnpjCpf"
    Invoke-RestMethod -Uri $uriCnpj -Method Patch -Headers $headers -Body $body

    # 2. Tenta atualizar pelo Código da Filial (Fallback)
    $uriFilial = "https://mmrwxfauovnnhnwzkqjy.supabase.co/rest/v1/LICENCA_SERVER?cod_filial=eq.$CnpjCpf"
    Invoke-RestMethod -Uri $uriFilial -Method Patch -Headers $headers -Body $body

    exit 0
}
catch {
    exit 1
}
