$cnpj_cpf = $args[0]
$token_acesso = $args[1]
$api_key = $args[2]

$url = "https://uhxambgdjkmdgoarezto.supabase.co/rest/v1/licencas?cnpj_cpf=eq.$cnpj_cpf&token_acesso=eq.$token_acesso&ativo=is.true&apikey=$api_key"

try {
    $response = Invoke-WebRequest -Uri $url -Method Get
    if ($response.StatusCode -eq 200) {
        $content = $response.Content
        if ($content -eq '[]') {
            # Credenciais inválidas (API retornou array vazio)
            exit 1
        } else {
            # Credenciais válidas (API retornou dados)
            exit 0
        }
    } else {
        # Erro de conexão ou servidor
        exit 2
    }
} catch {
    # Erro de rede ou outro erro
    exit 2
}