# registrar-mac.ps1 (VERSÃO CORRIGIDA)

# O bloco de parâmetros foi movido para o topo, como é exigido.
param(
    [string]$CnpjCpf,
    [string]$TokenAcesso,
    [string]$MacAddress,
    [string]$ApiKey
)

# A linha que força o TLS 1.2 agora vem DEPOIS dos parâmetros.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    $uri = "https://uhxambgdjkmdgoarezto.supabase.co/rest/v1/licencas?cnpj_cpf=eq.$CnpjCpf&token_acesso=eq.$TokenAcesso"

    $body = @{
        mac_vinculado = $MacAddress
    } | ConvertTo-Json

    $headers = @{
        "apikey"        = $ApiKey
        "Authorization" = "Bearer $ApiKey"
        "Content-Type"  = "application/json"
        "Prefer"        = "return=minimal"
    }

    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    exit 0
}
catch {
    exit 1
}