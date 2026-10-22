<?php
session_start();

// Configura o fuso horário para garantir que a comparação de tempo (30 min) seja precisa
date_default_timezone_set('America/Sao_Paulo');

if (!isset($_SESSION['logado']) || $_SESSION['logado'] !== true) {
    header("Location: index.php");
    exit;
}

$host = "127.0.0.1";
$user = "root";
$pass = "123web";
$db= "walinux";

$mysqli = new mysqli($host, $user, $pass, $db);
if ($mysqli->connect_error) {
    die("Erro ao conectar ao banco: " . $mysqli->connect_error);
}

if (isset($_GET['logout'])) {
    session_destroy();
    header("Location: index.php");
    exit;
}

$refresh_time = 60;

$data_inicio_filtro = isset($_GET['dt_ini']) ? $_GET['dt_ini'] : null;
$data_fim_filtro = isset($_GET['dt_fim']) ? $_GET['dt_fim'] : null;
$date_filter_clause = "";

if (!empty($data_inicio_filtro) || !empty($data_fim_filtro)) {
    if (!empty($data_inicio_filtro)) {
        $start_datetime = date('Y-m-d H:i:s', strtotime($data_inicio_filtro));
        $date_filter_clause .= " AND a.vend_dtabre >= '$start_datetime' ";
    }
    if (!empty($data_fim_filtro)) {
        $end_datetime = date('Y-m-d H:i:s', strtotime($data_fim_filtro));
        $date_filter_clause .= " AND a.vend_dtabre <= '$end_datetime' ";
    }
}

$query = "
SELECT T.tipo_atendimento, T.VALOR_PARCIAL, T.vend_dtabre, T.vend_nu_pessoas, T.NOME_CLIENTE, 
       T.COD_ECONOMICO, T.COD_FILIAL, T.vend_ticket_id, T._id, T.qtd_produtos, 
       T.vend_status, T.vend_dtultcons
FROM (
    SELECT
        SUM(vp.vprod_total) + ((a.vend_vl_servico + a.vend_vl_total) - a.vend_vl_desc) as VALOR_PARCIAL,
        a.vend_vl_taxa,
        CASE WHEN a.vend_nu_pessoas = 0 then 1 else a.vend_nu_pessoas end as vend_nu_pessoas,
        a._id,
        a.vend_pre_venda_h,
        a.vend_dtabre,
        a.vend_dtultcons,
        a.vend_vl_desc,
        a.vend_vl_servico,
        a.vend_vl_total,
        a.vend_status, a.vend_ticket_id,
        CASE
            WHEN c.cli_nome is not null THEN c.cli_nome
            WHEN a.vend_status = 'P' THEN a.vend_pre_venda_h
            WHEN a.vend_pre_venda_h is not null THEN a.vend_pre_venda_h
            ELSE '-'
        END AS NOME_CLIENTE,
        CASE
            WHEN a.vend_status IN ('PEDA', 'PEDE') THEN CONCAT('DELIVERY (', a._id,')')
            WHEN a.vend_status = 'P' THEN 'PRÉ-VENDA BALCÃO'
            ELSE CONCAT('CARTÃO/MESA (', a.vend_ticket_id ,')')
        END AS tipo_atendimento, 
        a.vend_empr_id as COD_ECONOMICO, 
        a.vend_loja_id as COD_FILIAL, 
        sum(vp.vprod_qtde) as qtd_produtos
    FROM walinux.venda a
    INNER JOIN venda_produto vp ON a._id = vp.vprod_vend_id
    LEFT JOIN cliente c ON a.vend_cli_id = c._id
    WHERE a.vend_status NOT IN ('R', 'C') AND vp.vprod_cancelado = 0
    $date_filter_clause
    GROUP BY a._id, c.cli_nome, a.vend_pre_venda_h, a.vend_dtabre, a.vend_dtultcons, a.vend_dtdesconto, a.vend_vl_desc,
    a.vend_vl_servico, a.vend_vl_total, a.vend_status, a.vend_vl_taxa, a.vend_nu_pessoas, a.vend_empr_id, a.vend_loja_id
) AS T
ORDER BY T.vend_ticket_id, T.tipo_atendimento ASC
";

$result = $mysqli->query($query);
$comandas = $result->fetch_all(MYSQLI_ASSOC);

$query_detalhes = "SELECT vprod_vend_id, vprod_qtde, vprod_preco, vprod_total, vprod_dtlancamento FROM venda_produto WHERE vprod_cancelado = 0";
$res_detalhes = $mysqli->query($query_detalhes);
$produtos_venda = [];
while($det = $res_detalhes->fetch_assoc()) {
    $produtos_venda[$det['vprod_vend_id']][] = [
        'qtd' => $det['vprod_qtde'],
        'preco' => $det['vprod_preco'],
        'total' => $det['vprod_total'],
        'data' => date('d/m H:i:s', strtotime($det['vprod_dtlancamento']))
    ];
}
$mysqli->close();
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista Comandas</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        :root {
            --bg: #f5f5f7; --card-bg: rgba(255, 255, 255, 0.7); --header-bg: rgba(255, 255, 255, 0.85);
            --text-main: #1d1d1f; --text-sec: #86868b; --accent: #0071e3; --glass-border: rgba(0, 0, 0, 0.1);
            --card-delivery: rgba(255, 243, 176, 0.6); --card-cartao: rgba(160, 196, 255, 0.6); --card-prevenda: rgba(185, 251, 192, 0.6);
            --blur: blur(25px) saturate(180%);
            --warning-grad: linear-gradient(135deg, #ff9500, #ffcc00);
        }
        [data-theme="dark"] {
            --bg: #000000; --card-bg: rgba(28, 28, 30, 0.7); --header-bg: rgba(28, 28, 30, 0.85);
            --text-main: #f5f5f7; --text-sec: #a1a1a6; --accent: #0a84ff; --glass-border: rgba(255, 255, 255, 0.1);
            --card-delivery: rgba(100, 80, 0, 0.4); --card-cartao: rgba(0, 50, 120, 0.4); --card-prevenda: rgba(0, 80, 30, 0.4);
        }
        * { box-sizing: border-box; transition: background 0.3s, color 0.3s, padding 0.3s, max-height 0.4s ease, transform 0.2s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.2s ease, opacity 0.3s ease; }
        
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 0; background-color: var(--bg); color: var(--text-main); padding-top: 350px; }
        body.collapsed { padding-top: 158px; } 

        .header { position: fixed; top: 0; left: 0; width: 100%; background: var(--header-bg); backdrop-filter: var(--blur); -webkit-backdrop-filter: var(--blur); z-index: 1000; border-bottom: 1px solid var(--glass-border); padding-bottom: 15px; }
        .header-logo { position: absolute; top: 18px; left: 20px; font-size: 35px; color: var(--accent); background: rgba(128,128,128,0.1); width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: 15px; border: 1px solid var(--glass-border); }

        .top-nav { display: flex; justify-content: flex-end; align-items: center; padding: 12px 20px; gap: 12px; }
        .btn-icon { background: rgba(128,128,128,0.12); border: 1px solid var(--glass-border); width: 38px; height: 38px; border-radius: 50%; color: var(--text-main); cursor: pointer; display: flex; align-items: center; justify-content: center; }
        .logout-btn { background: #ff3b30; color: white; border: none; padding: 8px 18px; border-radius: 20px; font-weight: 600; cursor: pointer; }
        
        .header-content { text-align: center; width: 100%; }
        h1 { font-size: 24px; margin: 0; font-weight: 700; }
        .subtitle { font-size: 13px; color: var(--text-sec); display: block; margin-bottom: 15px; }

        .collapsible-area { overflow: hidden; max-height: 800px; opacity: 1; padding: 0 10px; }
        body.collapsed .collapsible-area { max-height: 0; opacity: 0; pointer-events: none; }

        .filter-row { display: flex; justify-content: center; align-items: center; gap: 15px; flex-wrap: wrap; margin-bottom: 15px; padding: 0 20px; }
        .search-input { flex: 1; max-width: 300px; padding: 10px 15px; background: rgba(128,128,128,0.1); border: 1px solid var(--glass-border); border-radius: 12px; color: var(--text-main); outline: none; }

        .date-filter-group { display: flex; justify-content: center; align-items: flex-end; gap: 10px; margin-bottom: 15px; flex-wrap: wrap; }
        input[type="datetime-local"] { background: rgba(128,128,128,0.1); border: 1px solid var(--glass-border); border-radius: 10px; color: var(--text-main); padding: 8px; font-size: 12px; }

        .scroll-container { display: block; width: 100%; overflow-x: auto; scrollbar-width: none; padding: 5px 15px; }
        .filters, .summary-bar { display: flex; flex-wrap: nowrap; gap: 8px; width: max-content; margin: 0 auto; }
        
        .filter-btn { padding: 8px 16px; border-radius: 18px; border: 1px solid var(--glass-border); background: rgba(128,128,128,0.08); color: var(--text-sec); cursor: pointer; font-size: 13px; font-weight: 500; }
        .filter-btn.active { background: var(--accent); color: white; border-color: var(--accent); }

        .summary-item { background: var(--card-bg); padding: 12px 10px; border-radius: 14px; border: 1px solid var(--glass-border); text-align: center; min-width: 120px; }
        .summary-value { display: block; font-weight: 800; font-size: 16px; color: var(--accent); margin-top: 4px; }
        .summary-label { font-size: 9px; color: var(--text-sec); text-transform: uppercase; font-weight: 600; }

        .cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; padding: 16px 16px 80px 16px; }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card { 
            background: var(--card-bg); 
            border-radius: 24px; 
            padding: 15px; 
            border: 1px solid var(--glass-border); 
            text-align: center; 
            min-height: 200px; 
            display: flex; 
            flex-direction: column; 
            justify-content: space-between; 
            cursor: pointer;
            will-change: transform, opacity;
            animation: fadeInUp 0.4s ease forwards;
            position: relative;
            overflow: hidden;
        }

        .glass-effect {
            backdrop-filter: blur(12px) saturate(160%);
            -webkit-backdrop-filter: blur(12px) saturate(160%);
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
        }

        .status-tktp { background: rgba(255, 204, 0, 0.45) !important; }
        .status-delay { background: rgba(255, 59, 48, 0.4) !important; }

        /* Chanfros Alinhados */
        .card.status-tktp::after, .card.status-delay::after {
            content: attr(data-status-label);
            position: absolute;
            top: 10px;
            left: -25px;
            width: 100px;
            padding: 2px 0;
            transform: rotate(-45deg);
            text-align: center;
            font-size: 10px;
            font-weight: 900;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            z-index: 5;
        }
        .card.status-tktp::after { background: #ffcc00; color: #000; }
        .card.status-delay::after { background: #ff3b30; color: #fff; }

        .card.hidden { display: none !important; opacity: 0; transform: scale(0.9); }
        .card:hover { transform: scale(1.05); box-shadow: 0 10px 30px rgba(0,0,0,0.2); z-index: 10; }
        .card:active { transform: scale(0.98); }

        .card.delivery { background: var(--card-delivery); }
        .card.cartao { background: var(--card-cartao); }
        .card.prevenda { background: var(--card-prevenda); }
        .value-p { font-size: 26px; font-weight: 800; color: var(--accent); margin: 0; }

        .time-label { display: block; font-size: 11px; color: var(--accent); font-weight: 700; margin-top: 4px; }

        .info-floating {
            position: fixed; bottom: 25px; right: 25px; 
            background: var(--warning-grad);
            padding: 12px 20px; border-radius: 50px;
            font-size: 12px; color: #000; font-weight: 800; z-index: 900;
            box-shadow: 0 8px 32px rgba(255, 149, 0, 0.4);
            display: flex; align-items: center; gap: 8px;
        }

        .modal-overlay { 
            position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
            background: rgba(0,0,0,0.5); backdrop-filter: blur(0px); 
            display: none; justify-content: center; align-items: center; z-index: 2000; 
            transition: backdrop-filter 0.3s ease, background 0.3s ease;
        }
        .modal-overlay.active { display: flex; backdrop-filter: blur(10px); }

        @keyframes modalShow {
            from { opacity: 0; transform: scale(0.7) translateY(30px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        @keyframes modalHide {
            from { opacity: 1; transform: scale(1) translateY(0); }
            to { opacity: 0; transform: scale(0.8) translateY(20px); }
        }

        .modal-view { 
            background: var(--card-bg); border-radius: 28px; padding: 30px; 
            width: 92%; max-width: 460px; position: relative; border: 1px solid var(--glass-border); 
            color: var(--text-main); animation: modalShow 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
            overflow: hidden;
        }

        .modal-overlay.modal-closing .modal-view {
            animation: modalHide 0.25s ease forwards;
        }
        .modal-overlay.modal-closing {
            backdrop-filter: blur(0px);
            background: rgba(0,0,0,0);
        }

        .close-modal { position: absolute; top: 20px; right: 20px; font-size: 28px; cursor: pointer; color: var(--text-sec); z-index: 2100; }
        
        #m-tipo {
            display: block; text-align: center; background: rgba(128, 128, 128, 0.1);
            backdrop-filter: blur(10px); border: 1px solid var(--glass-border);
            padding: 12px; border-radius: 14px; font-size: 14px !important;
            color: var(--accent) !important; text-transform: uppercase;
            margin: 0 40px 10px 40px; letter-spacing: 1px;
        }

        #m-cliente { text-align: center; display: block; font-size: 22px; margin-top: 5px; }
        #m-data-abertura { text-align: center; margin: 8px 0 15px 0; }

        .modal-alert {
            background: var(--warning-grad); color: #000; padding: 8px 12px; border-radius: 12px;
            font-size: 11px; font-weight: 700; margin: 10px 0;
            display: flex; align-items: center; justify-content: center; gap: 6px;
        }

        .progress-bar-container { position: fixed; bottom: 0; left: 0; width: 100%; height: 4px; background: rgba(128,128,128,0.15); z-index: 1100; }
        .progress-bar { height: 100%; background: var(--accent); width: 0%; }
        .btn-round { width: 40px; height: 40px; border-radius: 50%; border: none; display: flex; align-items: center; justify-content: center; cursor: pointer; color: white; }
        .btn-blue { background: var(--accent); }
        .btn-red { background: #ff3b30; }
        #btnClearFilters { display: none; }
    </style>
</head>
<body data-theme="dark">

<div class="info-floating">
    <i class="fas fa-info-circle"></i> VALOR PARCIAL SEM TAXAS E ACRÉSCIMOS
</div>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal-view">
        <span class="close-modal" onclick="closeModal()">&times;</span>
        <h2 id="m-tipo"></h2>
        <strong id="m-cliente"></strong>
        <div id="m-data-abertura" style="font-size: 11px; color: var(--text-sec); font-weight: 600;"></div>
        
        <div class="modal-alert">
            <i class="fas fa-exclamation-triangle"></i> VALOR PARCIAL SEM TAXAS E ACRÉSCIMOS
        </div>

        <div id="m-lista" style="max-height: 300px; overflow-y: auto; margin: 15px 0;"></div>
        <div style="text-align: right; font-size: 24px; font-weight: 800; color: var(--accent);">Total: <span id="m-total"></span></div>
    </div>
</div>

<div class="header">
    <div class="header-logo"><i class="fas fa-receipt"></i></div>
    <div class="top-nav">
        <button class="btn-icon" id="toggleFilters"><i class="fas fa-chevron-up" id="toggleIcon"></i></button>
        <button class="btn-icon" id="theme-toggle"><i class="fas fa-sun"></i></button>
        <form method="get" style="margin:0"><button class="logout-btn" type="submit" name="logout">Sair</button></form>
    </div>

    <div class="header-content">
        <h1>Lista Comandas</h1>
        <span class="subtitle">somente em aberto</span>
        
        <div class="collapsible-area" id="collapsibleArea">
            <form method="get" id="filterForm" class="date-filter-group">
                <input type="datetime-local" name="dt_ini" id="dt_ini" value="<?php echo $data_inicio_filtro; ?>">
                <input type="datetime-local" name="dt_fim" id="dt_fim" value="<?php echo $data_fim_filtro; ?>">
                <button type="submit" class="btn-round btn-blue"><i class="fas fa-search"></i></button>
                <button type="button" class="btn-round btn-red" id="btnClearFilters" onclick="clearFilters()"><i class="fas fa-broom"></i></button>
            </form>

            <div class="filter-row">
                <div class="scroll-container" style="justify-content: flex-start; width: auto;">
                    <div class="filters">
                        <button class="filter-btn active" data-filter="todas">Todas</button>
                        <button class="filter-btn" data-filter="cartao">Mesa/Cartão</button>
                        <button class="filter-btn" data-filter="delivery">Delivery</button>
                        <button class="filter-btn" data-filter="prevenda">Pré-Venda</button>
                    </div>
                </div>
                <input type="text" id="searchInput" class="search-input" placeholder="Buscar cliente...">
            </div>

            <div class="scroll-container">
                <div class="summary-bar">
                    <div class="summary-item"><span class="summary-label">Total Geral</span><span class="summary-value" id="valor-total">R$ 0,00</span></div>
                    <div class="summary-item"><span class="summary-label">Comandas</span><span class="summary-value" id="total-comandas">0</span></div>
                    <div class="summary-item"><span class="summary-label">Total Itens</span><span class="summary-value" id="total-produtos">0</span></div>
                    <div class="summary-item"><span class="summary-label">Filial</span><span class="summary-value" id="resumo-filial">---</span></div>
                    <div class="summary-item"><span class="summary-label">Grupo Econ.</span><span class="summary-value" id="resumo-econ">---</span></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="cards">
    <?php foreach ($comandas as $index => $c): 
        $tipo = $c['tipo_atendimento'];
        $status = $c['vend_status'];
        
        // CORREÇÃO: Usando fuso horário de Brasília para o cálculo da pausa
        $dt_ult_ts = strtotime($c['vend_dtultcons']);
        $agora = time(); 
        $inatividade_minutos = ($agora - $dt_ult_ts) / 60;

        $status_color_class = "";
        $label_status = "";

        if ($status == "TKTP") {
            $status_color_class = "status-tktp glass-effect";
            $label_status = "CONTA";
        } elseif ($inatividade_minutos >= 30) {
            $status_color_class = "status-delay glass-effect";
            $label_status = "PAUSA";
        }

        $classe_base = (stripos($tipo, 'DELIVERY') !== false) ? 'delivery' : ((stripos($tipo, 'PRÉ-VENDA') !== false) ? 'prevenda' : 'cartao');
        $prods_json = json_encode($produtos_venda[$c['_id']] ?? []);
        $data_ab = date('d/m/Y H:i:s', strtotime($c['vend_dtabre']));
    ?>
    <div class="card <?php echo $classe_base . ' ' . $status_color_class; ?>" 
         id="card-<?php echo $c['_id']; ?>"
         style="animation-delay: <?php echo ($index * 0.03); ?>s"
         data-status-label="<?php echo $label_status; ?>"
         data-id="<?php echo $c['_id']; ?>"
         data-tipo="<?php echo $classe_base; ?>" 
         data-search="<?php echo strtolower($c['NOME_CLIENTE'] . ' ' . $tipo); ?>"
         data-valor="<?php echo $c['VALOR_PARCIAL']; ?>"
         data-qtd="<?php echo $c['qtd_produtos']; ?>"
         data-filial="<?php echo $c['COD_FILIAL']; ?>"
         data-econ="<?php echo $c['COD_ECONOMICO']; ?>"
         data-dtabre="<?php echo $c['vend_dtabre']; ?>"
         onclick='openModal("<?php echo addslashes($c['NOME_CLIENTE']); ?>", "<?php echo $tipo; ?>", "<?php echo number_format($c['VALOR_PARCIAL'], 2, ',', '.'); ?>", <?php echo $prods_json; ?>, "<?php echo $data_ab; ?>", "<?php echo $c['_id']; ?>")'>
        <div>
            <h3><?php echo $tipo; ?></h3>
            <small><?php echo $c['NOME_CLIENTE']; ?></small>
        </div>
        <div>
            <p class="value-p">R$ <?php echo number_format($c['VALOR_PARCIAL'], 2, ',', '.'); ?></p>
            <div style="font-size:12px; color:var(--text-sec);">Itens: <?php echo number_format($c['qtd_produtos'], 3, ',', '.'); ?></div>
        </div>
        <div style="font-size:10px; color:var(--text-sec); margin-top:10px;"><i class="far fa-clock"></i> <?php echo $data_ab; ?></div>
    </div>
    <?php endforeach; ?>
</div>

<div class="progress-bar-container"><div class="progress-bar" id="progressBar"></div></div>

<script>
function clearFilters() {
    document.getElementById('dt_ini').value = '';
    document.getElementById('dt_fim').value = '';
    document.getElementById('searchInput').value = '';
    document.querySelector('.filter-btn[data-filter="todas"]').click();
    window.location.href = window.location.pathname;
}

function checkBroomVisibility() {
    const dt_ini = document.getElementById('dt_ini').value;
    const dt_fim = document.getElementById('dt_fim').value;
    const search = document.getElementById('searchInput').value;
    const filterActive = document.querySelector('.filter-btn.active').dataset.filter !== 'todas';
    const broom = document.getElementById('btnClearFilters');
    broom.style.display = (dt_ini || dt_fim || search || filterActive) ? 'flex' : 'none';
}

function openModal(cliente, tipo, total, produtos, dataAbertura, idComanda) {
    const overlay = document.getElementById('modalOverlay');
    const modalView = overlay.querySelector('.modal-view');
    modalView.classList.remove('status-tktp', 'status-delay', 'glass-effect');
    overlay.classList.remove('modal-closing');
    document.getElementById('m-cliente').innerText = cliente;
    document.getElementById('m-tipo').innerText = tipo;
    document.getElementById('m-total').innerText = 'R$ ' + total;

    const card = document.getElementById('card-' + idComanda);
    const dtAbreRaw = card.dataset.dtabre;
    const dataInicio = new Date(dtAbreRaw);
    const agora = new Date();
    const diffMs = agora - dataInicio;
    const diffHrs = Math.floor(diffMs / 3600000);
    const diffMins = Math.floor((diffMs % 3600000) / 60000);
    const tempoAberto = `${diffHrs}h ${diffMins}min em aberto`;

    document.getElementById('m-data-abertura').innerHTML = `
        <div><i class="far fa-calendar-alt"></i> Abertura: ${dataAbertura}</div>
        <div class="time-label"><i class="far fa-clock"></i> ${tempoAberto}</div>
    `;
    
    localStorage.setItem('setupflow-open-modal', idComanda);

    const lista = document.getElementById('m-lista');
    lista.innerHTML = (produtos && produtos.length > 0) ? produtos.map((p, index) => `
        <div style="padding:12px 0; border-bottom:1px solid rgba(128,128,128,0.1)">
            <div style="display:flex; justify-content:space-between; font-weight:600;">
                <span>Item ${String(index + 1).padStart(2, '0')}</span>
                <span>R$ ${parseFloat(p.total).toLocaleString('pt-BR', {minimumFractionDigits:2})}</span>
            </div>
            <div style="font-size:11px; color:var(--text-sec); display:flex; justify-content:space-between; margin-top:4px;">
                <span>Qtd: ${parseFloat(p.qtd).toLocaleString('pt-BR', {minimumFractionDigits:3})} x R$ ${parseFloat(p.preco).toLocaleString('pt-BR', {minimumFractionDigits:2})}</span>
                <span><i class="far fa-clock"></i> ${p.data}</span>
            </div>
        </div>
    `).join('') : '<p>Nenhum item.</p>';
    overlay.classList.add('active');
}

function closeModal() { 
    const overlay = document.getElementById('modalOverlay');
    overlay.classList.add('modal-closing');
    setTimeout(() => {
        overlay.classList.remove('active');
        overlay.classList.remove('modal-closing');
        localStorage.removeItem('setupflow-open-modal');
    }, 250);
}

window.onclick = (e) => { if (e.target == document.getElementById('modalOverlay')) closeModal(); };

function applyFilters() {
    const type = document.querySelector('.filter-btn.active').dataset.filter;
    const term = document.getElementById('searchInput').value.toLowerCase();
    let vTotal = 0, qComandas = 0, qProds = 0, lastFilial = "---", lastEcon = "---";

    document.querySelectorAll('.card').forEach(card => {
        const matchesType = (type === 'todas' || card.dataset.tipo === type);
        const matchesSearch = card.dataset.search.includes(term);
        
        if (matchesType && matchesSearch) {
            card.style.display = 'flex';
            card.classList.remove('hidden');
            vTotal += parseFloat(card.dataset.valor || 0);
            qProds += parseFloat(card.dataset.qtd || 0);
            qComandas++;
            lastFilial = card.dataset.filial;
            lastEcon = card.dataset.econ;
        } else { 
            card.classList.add('hidden');
            setTimeout(() => { if(card.classList.contains('hidden')) card.style.display = 'none'; }, 200);
        }
    });
    
    document.getElementById('valor-total').innerText = 'R$ ' + vTotal.toLocaleString('pt-BR', {minimumFractionDigits:2});
    document.getElementById('total-comandas').innerText = qComandas;
    document.getElementById('total-produtos').innerText = qProds.toLocaleString('pt-BR', {minimumFractionDigits: 3});
    document.getElementById('resumo-filial').innerText = lastFilial;
    document.getElementById('resumo-econ').innerText = lastEcon;
    checkBroomVisibility();
}

document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.onclick = () => {
        document.querySelector('.filter-btn.active').classList.remove('active');
        btn.classList.add('active');
        applyFilters();
    };
});

document.getElementById('searchInput').oninput = applyFilters;
document.getElementById('dt_ini').onchange = checkBroomVisibility;
document.getElementById('dt_fim').onchange = checkBroomVisibility;

document.getElementById('toggleFilters').onclick = function() {
    const isCollapsed = document.body.classList.toggle('collapsed');
    document.getElementById('toggleIcon').className = isCollapsed ? 'fas fa-chevron-down' : 'fas fa-chevron-up';
    localStorage.setItem('setupflow-collapsed', isCollapsed);
};

document.getElementById('theme-toggle').onclick = () => {
    const theme = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.body.setAttribute('data-theme', theme);
    localStorage.setItem('setupflow-theme', theme);
};

window.onload = () => {
    const theme = localStorage.getItem('setupflow-theme') || 'dark';
    document.body.setAttribute('data-theme', theme);
    if(localStorage.getItem('setupflow-collapsed') === 'true') document.body.classList.add('collapsed');
    
    applyFilters();

    // RESTAURA A POSIÇÃO DO SCROLL APÓS O REFRESH
    const scrollPos = localStorage.getItem('setupflow-scroll');
    if (scrollPos) {
        window.scrollTo(0, parseInt(scrollPos));
        localStorage.removeItem('setupflow-scroll'); // Limpa para não influenciar navegação manual
    }

    const openId = localStorage.getItem('setupflow-open-modal');
    if (openId) {
        const targetCard = document.getElementById('card-' + openId);
        if (targetCard) targetCard.click();
    }

    const REFRESH_INTERVAL = 60 * 1000;
    let start = Date.now();
    setInterval(() => {
        let elapsed = Date.now() - start;
        let p = (elapsed / REFRESH_INTERVAL) * 100;
        if (p >= 100) {
            // SALVA A POSIÇÃO DO SCROLL ANTES DE RECARREGAR
            localStorage.setItem('setupflow-scroll', window.scrollY);
            window.location.reload();
        } else {
            document.getElementById('progressBar').style.width = p + '%';
        }
    }, 100);
};
</script>
</body>
</html>