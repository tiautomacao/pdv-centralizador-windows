<?php
header('Content-Type: text/html; charset=utf-8');

// Report all PHP errors
error_reporting(E_ALL);

// Same as error_reporting(E_ALL);
ini_set('error_reporting', E_ALL);
 
$senhapadrao   = "wAFLY01";
//$conecta = mysql_connect("127.0.0.1", "root", "1234") or print (mysql_error()); 
//mysql_select_db("walinux", $conecta);

$mysqli = new mysqli("127.0.0.1", "root", "web123", "walinux");
/* check connection */
if ($mysqli->connect_error) {
    printf("FALHA NA CONEXAO: %s\n", $mysqli->connect_error);
    exit();
}
$mysqli->set_charset("utf8");


//trava por senha
$senhaws = $_POST['senhaws'];
?>
