<?php
/*
 * blowfish_secret para autenticação via cookie (DEVE ter 32+ caracteres)
 */
$cfg['blowfish_secret'] = 'a8k3jH7b2nC9pL1fG6dE4mS5tY2uI8oZ'; /* ALTERADO */

/*
 * Servers configuration
 */
$i = 0;

/*
 * First server
 */
$i++;

/* Authentication type and info */
$cfg['Servers'][$i]['auth_type'] = 'cookie'; /* ALTERADO para mostrar a tela de login */
// $cfg['Servers'][$i]['user'] = 'root';     // Comentado/Removido
// $cfg['Servers'][$i]['password'] = '';   // Comentado/Removido
$cfg['Servers'][$i]['extension'] = 'mysqli';
$cfg['Servers'][$i]['AllowNoPassword'] = false; /* ALTERADO por segurança */
$cfg['Lang'] = '';

/* Bind to the localhost ipv4 address and tcp */
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['connect_type'] = 'tcp';

/* User for advanced features */
// ... (o resto do arquivo continua igual) ...

?>