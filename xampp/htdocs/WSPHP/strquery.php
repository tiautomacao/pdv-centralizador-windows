<?php 
$retorno = "false";
require_once('conecta.php');
require_once('functions.php');

if($senhapadrao != $senhaws)
	$retorno = $senhaws.'ERRO';
else
{
	$query = $_POST['query'];
	$consulta = $_POST['isconsulta'];
	$ret = array();
	$resultados = "";
	$erroQ = "NENHUM";
	$origem = "strquery.php";
	//$query = str_replace('\r\n',"",$query);
	
	if($consulta == "1" || $consulta == "true")
	{
	        $result = $mysqli->query($query);	
		//$result = $mysqli->multi_query($query);
		$linhas = $mysqli->affected_rows;
		if($linhas > 0)
		{
			while($post = mysqli_fetch_assoc($result))
			{	
			  $ret[] = array('resultado'=>$post);
			  $retorno = $ret;
			}
			$resultados = "CONSULTA ".$linhas." LINHAS AFETADAS";
		}
		else
		{
			$ret[0]['id'] = "0";
			$ret[0]['msg'] = $mysqli->error;
			$ret[0]['linhas_afetadas'] = $linhas;
			$ret[0]['query'] = $query;
			$retorno = $ret;
			$resultados = "CONSULTA NENHUMA LINHA AFETADA";	
			$erroQ = $mysqli->error;		
		}
 	}
	else
	{
		//$mysqli->query($query); alterado em 2016-01-20
		$mysqli->multi_query($query);
		$result = $mysqli->insert_id;		

			$linhas = $mysqli->affected_rows;
			
			if($linhas >= 0)
			{
				$ret[0]['id'] = $result;
				$ret[0]['msg'] = "OK";
				$ret[0]['linhas_afetadas'] = $linhas;
				$ret[0]['query'] = $query;
				$retorno = $ret;
				$resultados = "GRAVAÇÃO 1 LINHA AFETADA";	
			}
			else
			{
				$ret[0]['id'] = "0";
			    $ret[0]['msg'] = $mysqli->error;
				$ret[0]['linhas_afetadas'] = $linhas;
				$ret[0]['query'] = $query;
				$retorno = $ret;
				$resultados = "GRAVAÇÃO NENHUMA LINHA AFETADA";	
				$erroQ = $mysqli->error;
			}
	}
	
	
	//mysql_query($query);
	//$row = mysql_fetch_array($result);
	//$result = mysql_query($query_select);
	//mysqli_free_result($result); 
	$mysqli->close();
}
//$retorno = htmlentities($retorno,ENT_QUOTES);
echo json_encode($retorno);

//Gravando log
//CreateLog($query,$resultados,$erroQ,$origem);
?>