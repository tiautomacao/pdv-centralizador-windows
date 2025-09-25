<?php 
$retorno = "false";
require_once('conecta.php');
require_once('functions.php');
if($senhapadrao != $senhaws)
	$retorno = "Senha WS invalida";
else
{
	$query = $_POST['query'];
	$consulta = $_POST['isconsulta'];
	$ret = array();
	$erroMostra = "";
	$resultados = "";
	$erroQ = "NENHUM";
	$origem = "strqueryTransaction.php";
	
	//Quebrando uma query separada por ; em várias queryes
	$pedacos = explode(";",$query);

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
		$queryerror = false;
		// PERCORRE O ARRAY E EXECUTA AS QUERY'S
		$mysqli->autocommit(FALSE);
		foreach ($pedacos as $sqlquery) {
			$result = $mysqli->query($sqlquery);
		    if (!$result)
			{ 
			 $queryerror = true;
			 $erroMostra = $mysqli->error;
			}
		}
		
		// SE NÃO TIVER ERROS
		if (!$queryerror)
		{
			$mysqli->commit();
			$row = mysqli_fetch_assoc($result);
			$ret[0]['id'] = $row["vendaid"];
			$ret[0]['msg'] = "OK";
			$ret[0]['linhas_afetadas'] = "1";
			$ret[0]['query'] = $query;
			$retorno = $ret;
			$resultados = "GRAVAÇÃO 1 LINHA AFETADA";	
		}
		// SE TIVER ERROS
		else
		{
			$mysqli->rollback();
			$ret[0]['id'] = "0";
			$ret[0]['msg'] = $erroMostra;
			$ret[0]['linhas_afetadas'] = "0";
			$ret[0]['query'] = $query;
			$retorno = $ret;
			$resultados = "GRAVAÇÃO NENHUMA LINHA AFETADA";	
			$erroQ = $erroMostra;			
		}				
	}
	$mysqli->close();
}

echo json_encode($retorno);	

//Gravando log
CreateLog($query,$resultados,$erroQ,$origem);
?>