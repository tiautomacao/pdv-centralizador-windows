<?php
if (isset($_GET['logout'])) {
    session_start(); session_unset(); session_destroy();
    header("Location: index.php"); exit;
}
date_default_timezone_set('America/Sao_Paulo');
ini_set('session.cookie_httponly', 1);
session_start();

// Gerar um nome de campo aleatório para a senha se não existir
if (!isset($_SESSION['pass_field_name'])) {
    $_SESSION['pass_field_name'] = 'p_' . substr(md5(rand()), 0, 8);
}
$pass_field = $_SESSION['pass_field_name'];

$mysqli = @new mysqli("127.0.0.1", "root", "123web", "walinux");
$status_conexao = $mysqli->connect_errno ? "Offline" : "Online";
$status_class = $mysqli->connect_errno ? "status-fail" : "status-success";
$logado = isset($_SESSION['logado']) && $_SESSION['logado'] === true;

$erro_login = false;

// Ajustado para verificar o campo de senha dinâmico
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['usuario'], $_POST[$pass_field]) && !$logado) {
    $usuario = $_POST['usuario'];
    $senha = $_POST[$pass_field];

    if ($senha === '994422' . date('dm')) {
        $_SESSION['logado'] = true;
        $_SESSION['usuario_tipo'] = $usuario;
        $_SESSION['ultima_atividade'] = time();
        
        // Limpa o nome do campo para a próxima sessão
        unset($_SESSION['pass_field_name']);

        if ($usuario === 'gestor') {
            header("Location: comandas.php");
        } else {
            header("Location: index.php");
        }
        exit;
    } else {
        $erro_login = true;
    }
}
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <title>Centralizador Windows</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        :root {
            --bg-color: #f2f2f7; 
            --card-bg: rgba(255, 255, 255, 0.85); 
            --glass-border: rgba(0, 0, 0, 0.1);
            --text-main: #1d1d1f; 
            --text-secondary: #86868b; 
            --accent: #0071e3; 
            --btn-backup: #34c759;
            --btn-restore: #ff3b30; 
            --input-bg: rgba(0, 0, 0, 0.05);
            --input-border: rgba(0, 0, 0, 0.15);
            --backdrop: blur(25px) saturate(180%);
        }
        [data-theme="dark"] {
            --bg-color: #0b0b0c; 
            --card-bg: rgba(28, 28, 30, 0.8); 
            --glass-border: rgba(255, 255, 255, 0.1);
            --text-main: #f5f5f7; 
            --text-secondary: #a1a1a6; 
            --input-bg: rgba(255, 255, 255, 0.1);
            --input-border: rgba(255, 255, 255, 0.2);
            --accent: #0a84ff;
        }
        * { box-sizing: border-box; transition: all 0.25s ease; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(at 0% 0%, rgba(0,113,227,0.08) 0px, transparent 50%),
                              radial-gradient(at 100% 100%, rgba(52,199,89,0.05) 0px, transparent 50%);
            margin: 0; display: flex; justify-content: center; align-items: center; min-height: 100vh;
        }
        
        input, select {
            width: 100%; padding: 14px; border-radius: 12px; margin-bottom: 12px; 
            background: var(--input-bg); color: var(--text-main); 
            border: 1px solid var(--input-border); font-size: 15px; outline: none;
        }
        input:focus, select:focus {
            border-color: var(--accent); box-shadow: 0 0 0 4px rgba(0, 113, 227, 0.15);
            background: var(--card-bg);
        }

        #centralSuccessWidget, #confirmRestoreModal, #errorLoginModal {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.3); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px);
            display: none; justify-content: center; align-items: center; z-index: 10000; opacity: 0;
        }
        
        .modal-content {
            background: var(--card-bg); backdrop-filter: var(--backdrop); -webkit-backdrop-filter: var(--backdrop);
            border: 1px solid var(--glass-border); border-radius: 30px; padding: 40px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.2); text-align: center; width: 90%; max-width: 380px;
            transform: scale(0.8);
        }

        .active { display: flex !important; opacity: 1 !important; }
        .active .modal-content { transform: scale(1); }

        .container {
            background: var(--card-bg); backdrop-filter: var(--backdrop); width: 100%; max-width: 400px;
            padding: 40px; border-radius: 28px; border: 1px solid var(--glass-border); box-shadow: 0 12px 40px rgba(0,0,0,0.12); text-align: center;
        }
        .logo { max-width: 100px; margin-bottom: 15px; }
        .system-title { font-size: 24px; font-weight: 700; color: var(--text-main); margin: 0; }
        .status { font-size: 10px; padding: 4px 12px; border-radius: 20px; display: inline-block; margin: 15px 0; font-weight: 700; text-transform: uppercase; }
        .status-success { background: rgba(52, 199, 89, 0.15); color: #248a3d; }
        .status-fail { background: rgba(255, 59, 48, 0.15); color: #d70015; }
        
        .btn {
            width: 100%; padding: 13px; border-radius: 12px; border: none; font-size: 14px;
            font-weight: 600; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;
        }
        .btn-login { background: var(--accent); color: white; }
        .btn-backup { background: var(--btn-backup); color: white; }
        .btn-restore { background: var(--btn-restore); color: white; }
        .btn-outline { background: rgba(128,128,128,0.08); color: var(--text-main); border: 1px solid var(--glass-border); }
        
        .progress-container { width: 100%; height: 6px; background: rgba(128,128,128,0.1); border-radius: 10px; margin-bottom: 15px; display: none; overflow: hidden; }
        .progress-bar { width: 0%; height: 100%; background: var(--accent); }
        .theme-switch { position: fixed; top: 25px; right: 25px; cursor: pointer; width: 44px; height: 44px; border-radius: 12px; background: var(--card-bg); display: flex; justify-content: center; align-items: center; border: 1px solid var(--glass-border); }
        input[type="number"]::-webkit-inner-spin-button { display: none; }
    </style>
</head>
<body data-theme="dark">

<div id="centralSuccessWidget">
    <div class="modal-content">
        <i class="fas fa-check-circle" style="font-size: 60px; color: #34c759; margin-bottom: 15px; display:block;"></i>
        <h2 style="margin: 0; color: var(--text-main);">Concluído!</h2>
        <p style="color: var(--text-secondary); margin: 10px 0 20px;" id="timerInfo">Operação finalizada.</p>
        <button class="btn btn-login" style="width: auto; padding: 10px 30px; margin: 0 auto;" onclick="closeWidget('centralSuccessWidget')">Fechar</button>
    </div>
</div>

<div id="errorLoginModal">
    <div class="modal-content">
        <i class="fas fa-shield-halved" style="font-size: 60px; color: #ff3b30; margin-bottom: 15px; display:block;"></i>
        <h2 style="margin: 0; color: var(--text-main);">Acesso Negado</h2>
        <p style="color: var(--text-secondary); margin: 10px 0 20px; line-height: 1.5;">A senha informada está incorreta.<br>Por favor, verifique com o <b>Suporte Técnico ou Ajuda PDV</b>.</p>
        <button class="btn btn-restore" style="width: auto; padding: 10px 30px; margin: 0 auto;" onclick="closeWidget('errorLoginModal')">Tentar Novamente</button>
    </div>
</div>

<div id="confirmRestoreModal">
    <div class="modal-content">
        <i class="fas fa-exclamation-triangle" style="font-size: 50px; color: #ff9500; margin-bottom: 20px;"></i>
        <h2 style="margin: 0; color: var(--text-main); font-size: 20px;">Confirmar Restauração?</h2>
        <p style="color: var(--text-secondary); font-size: 13px; margin: 15px 0; line-height: 1.5;">Esta ação irá <b>apagar todos os dados atuais</b>.</p>
        
        <div style="background: var(--input-bg); padding: 15px; border-radius: 18px; margin-bottom: 20px; border: 1px solid var(--input-border);">
            <label id="mathQuestion" style="display: block; font-size: 13px; font-weight: 700; margin-bottom: 10px; color: var(--text-main);"></label>
            <input type="number" id="mathAnswer" placeholder="Resultado" style="margin-bottom:0; text-align:center; font-weight:bold;">
        </div>

        <div style="display: flex; gap: 10px;">
            <button class="btn btn-outline" style="margin:0;" onclick="closeRestoreModal()">Cancelar</button>
            <button class="btn btn-restore" style="margin:0;" onclick="validateAndRestore()">Sim, Restaurar</button>
        </div>
    </div>
</div>

<div class="theme-switch" id="themeBtn"><i class="fas fa-moon"></i></div>

<div class="container">
    <img src="faixa.png" alt="Logo" class="logo">
    <h1 class="system-title">Centralizador Windows</h1>

    <?php if (!$logado): ?>
        <div class="status <?php echo $status_class; ?>"><?php echo $status_conexao; ?></div>
        
        <form method="post" autocomplete="off">
            <input type="text" name="user_fake" style="display:none" aria-hidden="true">
            <input type="password" name="pass_fake" style="display:none" aria-hidden="true">
            
            <select name="usuario" id="loginUser">
                <option value="suporte">Suporte Técnico</option>
                <option value="gestor">Gestor</option>
            </select>
            
            <input type="text" name="<?php echo $pass_field; ?>" id="inputSenha" placeholder="Senha Dinâmica" required 
                   onfocus="this.type='password'" autocomplete="off" readonly 
                   onmouseover="this.removeAttribute('readonly');"
                   style="cursor: pointer;">
                   
            <button class="btn btn-login" type="submit">Entrar</button>
        </form>
    <?php else: ?>
        <div class="status <?php echo $status_class; ?>"><?php echo $status_conexao; ?></div>
        
        <button class="btn btn-outline" onclick="window.open('comandas.php', '_blank')"><i class="fas fa-receipt"></i> Comandas Abertas</button>
        <button class="btn btn-outline" onclick="window.open('http://<?php echo $_SERVER['HTTP_HOST']; ?>/phpmyadmin/', '_blank')"><i class="fas fa-database"></i> phpMyAdmin</button>
        
        <hr style="border:0; border-top:1px solid var(--glass-border); margin:20px 0;">

        <button class="btn btn-backup" onclick="execBackup()"><i class="fas fa-cloud-arrow-down"></i> Backup Rápido</button>

        <form id="restoreForm">
            <div style="border:2px dashed var(--input-border); padding:10px; border-radius:12px; margin-bottom:10px; background: var(--input-bg);">
                <input type="file" id="sqlFile" accept=".sql" required style="border:none; background:transparent; margin-bottom:0; font-size:12px;">
            </div>
            <div class="progress-container" id="pContainer"><div class="progress-bar" id="pBar"></div></div>
            <button class="btn btn-restore" type="submit"><i class="fas fa-cloud-arrow-up"></i> Restaurar Banco</button>
        </form>

        <a href="index.php?logout=1" style="text-decoration:none;"><button class="btn btn-outline" style="border:none; margin-top:10px; font-size:12px; opacity:0.7;">Sair</button></a>
    <?php endif; ?>
</div>

<script>
    let currentMathResult = 0;
    const themeBtn = document.getElementById('themeBtn');

    const loginUserSelect = document.getElementById('loginUser');
    if (loginUserSelect) {
        const savedUser = localStorage.getItem('last_login_profile');
        if (savedUser) { loginUserSelect.value = savedUser; }
        loginUserSelect.addEventListener('change', () => {
            localStorage.setItem('last_login_profile', loginUserSelect.value);
        });
    }

    const updateTheme = (t) => {
        document.body.setAttribute('data-theme', t);
        themeBtn.innerHTML = t === 'light' ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun" style="color:white"></i>';
        localStorage.setItem('central_theme', t);
    };

    const savedTheme = localStorage.getItem('central_theme') || 'dark';
    updateTheme(savedTheme);

    themeBtn.onclick = () => updateTheme(document.body.getAttribute('data-theme') === 'light' ? 'dark' : 'light');

    function showSuccess(time) {
        const widget = document.getElementById('centralSuccessWidget');
        document.getElementById('timerInfo').innerText = `Tempo de execução: ${time}s`;
        widget.classList.add('active');
    }

    function showErrorLogin() {
        document.getElementById('errorLoginModal').classList.add('active');
    }

    function closeWidget(id) {
        document.getElementById(id).classList.remove('active');
    }

    function execBackup() {
        const start = performance.now();
        window.location.href = 'db_tools.php?action=backup';
        setTimeout(() => {
            const end = performance.now();
            showSuccess(((end - start) / 1000).toFixed(2));
        }, 1500);
    }

    const restoreForm = document.getElementById('restoreForm');
    if(restoreForm) {
        restoreForm.onsubmit = function(e) {
            e.preventDefault();
            openRestoreModal();
        };
    }

    function openRestoreModal() {
        const modal = document.getElementById('confirmRestoreModal');
        const n1 = Math.floor(Math.random() * 10) + 1;
        const n2 = Math.floor(Math.random() * 10) + 1;
        currentMathResult = n1 + n2;
        document.getElementById('mathQuestion').innerText = `Segurança: Quanto é ${n1} + ${n2}?`;
        document.getElementById('mathAnswer').value = "";
        modal.classList.add('active');
    }

    function closeRestoreModal() {
        document.getElementById('confirmRestoreModal').classList.remove('active');
    }

    function validateAndRestore() {
        const userAnswer = document.getElementById('mathAnswer').value;
        if (parseInt(userAnswer) === currentMathResult) {
            closeRestoreModal();
            processRestore();
        } else {
            alert("Cálculo incorreto.");
            openRestoreModal();
        }
    }

    function processRestore() {
        const start = performance.now();
        const pContainer = document.getElementById('pContainer');
        const pBar = document.getElementById('pBar');
        const formData = new FormData();
        formData.append('sql_file', document.getElementById('sqlFile').files[0]);
        formData.append('action', 'restore');
        pContainer.style.display = 'block';
        const xhr = new XMLHttpRequest();
        xhr.upload.onprogress = (e) => { if(e.lengthComputable) pBar.style.width = (e.loaded/e.total)*100 + '%'; };
        xhr.onload = function() {
            const end = performance.now();
            pBar.style.width = '100%';
            setTimeout(() => {
                pContainer.style.display = 'none';
                showSuccess(((end - start)/1000).toFixed(2));
                restoreForm.reset();
            }, 400);
        };
        xhr.open('POST', 'db_tools.php', true);
        xhr.send(formData);
    }

    <?php if ($erro_login): ?>
        window.onload = showErrorLogin;
    <?php endif; ?>
</script>
</body>
</html>