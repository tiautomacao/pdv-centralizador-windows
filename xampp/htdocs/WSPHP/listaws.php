<?php
$pagina = $_GET["op"];
$descr = "";
$destino = "";
$mostra1 = "style='display:none'";
$mostra2 = "style='display:none'";
$mostra3 = "style='display:none'";
$mostra4 = "style='display:none'";
$mostra5 = "style='display:none'";
$mostra6 = "style='display:none'";
$mostra7 = "style='display:none'";

if($pagina == "excluirvenda")
{
	$descr = "deleta uma venda que foi baixada pelo tablet";
	$mostra5 = "";
}
else if($pagina == "getusuario")
{
	$descr = "Devolve true se o usuário passado como parametro já estiver marcado na base de dados";
	$mostra1 = "";
}
else if($pagina == "getvendas")
{
	$descr = "Devolve todos dados da tabela venda com os produtos de cada venda";
}
else if($pagina == "getvendasimpressao")
{
	$descr = "Devolve todos dados da tabela venda_impressao";
}
else if($pagina == "setusuario")
{
	$descr = "Marca o usuário como Checado na base de dados";
	$mostra1 = "";
	$mostra2 = "";
	$mostra3 = "";
}
else if($pagina == "setvenda")
{
	$descr = "Insere uma venda com os itens na tabela venda e venda_produto";
	$mostra4 = "";
}
else if($pagina == "verificavenda")
{
	$descr = "Devolve true se a venda passada como parametro existir na base de dados";
	$mostra5 = "";
}
else if($pagina == "strquery")
{
	$descr = "Executa uma consulta na base de dados baseado na query passada como parametro";
	$mostra6 = "";
	$mostra7 = "";
}
else if($pagina == "strqueryTransaction")
{
	$descr = "Executa uma consulta na base de dados baseado na query passada como parametro de forma transacionada";
	$mostra6 = "";
	$mostra7 = "";
}
?>


<html>

    <head><link rel="alternate" type="text/xml" href="/WSTabletOFF/integrator.asmx?disco" />

    <style type="text/css">
    
		BODY { color: #000000; background-color: white; font-family: Verdana; margin-left: 0px; margin-top: 0px; }
		#content { margin-left: 30px; font-size: .70em; padding-bottom: 2em; }
		A:link { color: #336699; font-weight: bold; text-decoration: underline; }
		A:visited { color: #6699cc; font-weight: bold; text-decoration: underline; }
		A:active { color: #336699; font-weight: bold; text-decoration: underline; }
		A:hover { color: cc3300; font-weight: bold; text-decoration: underline; }
		P { color: #000000; margin-top: 0px; margin-bottom: 12px; font-family: Verdana; }
		pre { background-color: #e5e5cc; padding: 5px; font-family: Courier New; font-size: x-small; margin-top: -5px; border: 1px #f0f0e0 solid; }
		td { color: #000000; font-family: Verdana; font-size: .7em; }
		h2 { font-size: 1.5em; font-weight: bold; margin-top: 25px; margin-bottom: 10px; border-top: 1px solid #003366; margin-left: -15px; color: #003366; }
		h3 { font-size: 1.1em; color: #000000; margin-left: -15px; margin-top: 10px; margin-bottom: 10px; }
		ul { margin-top: 10px; margin-left: 20px; }
		ol { margin-top: 10px; margin-left: 20px; }
		li { margin-top: 10px; color: #000000; }
		font.value { color: darkblue; font: bold; }
		font.key { color: darkgreen; font: bold; }
		font.error { color: darkred; font: bold; }
		.heading1 { color: #ffffff; font-family: Tahoma; font-size: 26px; font-weight: normal; background-color: #003366; margin-top: 0px; margin-bottom: 0px; margin-left: -30px; padding-top: 10px; padding-bottom: 3px; padding-left: 15px; width: 105%; }
		.button { background-color: #dcdcdc; font-family: Verdana; font-size: 1em; border-top: #cccccc 1px solid; border-bottom: #666666 1px solid; border-left: #cccccc 1px solid; border-right: #666666 1px solid; }
		.frmheader { color: #000000; background: #dcdcdc; font-family: Verdana; font-size: .7em; font-weight: normal; border-bottom: 1px solid #dcdcdc; padding-top: 2px; padding-bottom: 2px; }
		.frmtext { font-family: Verdana; font-size: .7em; margin-top: 8px; margin-bottom: 0px; margin-left: 32px; }
		.frmInput { font-family: Verdana; font-size: 1em; }
		.intro { margin-left: -15px; }
           
    </style>

    <title>
	WSPHP
</title></head>

  <body>

    <div id="content">

      <p class="heading1">integrator</p><br>

      

      

      <span>
          <p class="intro">Clique <a href="index.php">aqui</a> para obter uma lista completa das operacoes.</p>
          <h2><?php echo($pagina)?></h2>
          <p class="intro"><?php echo($descr)?></p>

          <h3>Testar</h3>
          
          Para testar a operacao usando o protocolo HTTP POST, clique no botao 'Chamar'.



                      <form target="_blank" action='<?php echo($pagina).'.php'?>' method="POST">                      
                        
                          <table cellspacing="0" cellpadding="4" frame="box" bordercolor="#dcdcdc" rules="none" style="border-collapse: collapse;">
                          <tr>
	<td class="frmHeader" background="#dcdcdc" style="border-right: 2px solid white;">Parametro</td>
	<td class="frmHeader" background="#dcdcdc">Valor</td>
</tr>

                         <tr <?php echo($mostra1)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">idusuario:</td>
                            <td><input class="frmInput" type="text" size="50" name="idusuario"></td>
                          </tr>
                          <tr <?php echo($mostra2)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">nomeusuario:</td>
                            <td><input class="frmInput" type="text" size="50" name="nomeusuario"></td>
                          </tr>
                           <tr <?php echo($mostra3)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">ativo:</td>
                            <td><input class="frmInput" type="text" size="50" name="ativo"></td>
                          </tr>
                           <tr <?php echo($mostra4)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">venda:</td>
                            <td><input class="frmInput" type="text" size="50" name="venda"></td>
                          </tr>
                          <tr <?php echo($mostra5)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">nomeprevenda:</td>
                            <td><input class="frmInput" type="text" size="50" name="nomeprevenda"></td>
                          </tr>
                          <tr <?php echo($mostra6)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">query:</td>
                            <td><textarea name="query" cols="120" rows="25" class="frmInput"></textarea></td>
                          </tr>
                           <tr <?php echo($mostra7)?>>
                            <td class="frmText" style="color: #000000; font-weight: normal;">isconsulta:</td>
                            <td><input class="frmInput" type="text" size="50" name="isconsulta"></td>
                          </tr>
                          <tr>
                            <td class="frmText" style="color: #000000; font-weight: normal;">senhaws:</td>
                            <td><input class="frmInput" type="text" size="50" name="senhaws"></td>
                          </tr>
                        
                        <tr>
                          <td></td>
                          <td align="right"> <input type="submit" value="Chamar" class="button"></td>
                        </tr>
                        </table>
                      

                    </form>
                  <span>
      </span>
      </span>
  </body>
</html>
