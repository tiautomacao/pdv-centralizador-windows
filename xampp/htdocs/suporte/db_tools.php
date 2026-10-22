<?php
session_start();
$host = "127.0.0.1";
$user = "root";
$pass = "123web";
$db = "walinux";

// Caminhos do XAMPP - Verifique se o seu é exatamente este
$mysqldumpPath = "C:\\xampp\\mysql\\bin\\mysqldump.exe";
$mysqlPath = "C:\\xampp\\mysql\\bin\\mysql.exe";

$action = $_REQUEST['action'] ?? '';

if ($action == 'backup') {
    $filename = "backup_walinux_" . date("Y-m-d_H-i") . ".sql";
    
    // IMPORTANTE: No Windows/XAMPP, às vezes o redirecionamento '>' falha se não usarmos aspas duplas no caminho
    $command = "\"$mysqldumpPath\" -h $host -u $user -p$pass $db";
    
    // Vamos usar o método de captura direta para evitar erros de permissão de escrita de arquivo no servidor
    header('Content-Description: File Transfer');
    header("Content-Type: application/sql");
    header("Content-Disposition: attachment; filename=\"$filename\"");
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');

    // Executa e envia direto para o output (buffer do navegador)
    passthru($command);
    exit;

} elseif ($action == 'restore') {
    if (isset($_FILES['sql_file']) && $_FILES['sql_file']['error'] == 0) {
        $tmpName = $_FILES['sql_file']['tmp_name'];

        $mysqli = new mysqli($host, $user, $pass, $db);
        $result = $mysqli->query("SHOW TABLES");
        while ($row = $result->fetch_array()) {
            $mysqli->query("DROP TABLE IF EXISTS `".$row[0]."`");
        }
        $mysqli->close();

        $command = "\"$mysqlPath\" -h $host -u $user -p$pass $db < \"$tmpName\"";
        system($command, $retval);
        echo $retval === 0 ? "success" : "error";
    }
    exit;
}