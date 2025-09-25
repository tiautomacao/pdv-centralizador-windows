<?php
date_default_timezone_set('America/Sao_Paulo');

//Cria o log de todas ações criadas no arquivo strquery e strquerytransaction
function CreateLog($query,$ok,$erro,$origem)
{
	try 
	{
		//pasta padrao
		$pastaLog = './log';
		
		//criando a pasta de log
		if (!file_exists($pastaLog))
		   mkdir($pastaLog, 0777, true);
		
	 //se a pasta for maior que 500 MB faço uma limpeza para evitar estouro no rasp
	  ApagaArquivosAntigos();
	  
	  $tamanho = GetDirectorySize('log');
	  $query = $query;
		
	   $data = date('YmdH').'.txt';
	   $agora = date('d/m/Y H:i:s');
	   $name = 'log/'.$data;

  
	  
	  //Abrindo o arquivo
	  //$file = fopen($name, 'a');
	  
	  //Colocando o cabeçalho na query
	  $texto = "ORIGEM: ".$origem." \r\n";
	  $texto = $texto. "RESULTADO: ".$ok." \r\n";
	  $texto = $texto. "ERRO: ".$erro." \r\n";
	  $texto = $texto. "DATA: ".$agora." \r\n";
	  $texto = $texto."QUERY:".$query." \r\n";
	  $texto = $texto."*********************************************************************************************\r\n";
	  
	  //Escrendo o log
	  //fwrite($file, $texto);
	  
	  //Fechando a conexão
	  //fclose($file);  
	  
	  file_put_contents($name, $texto, FILE_APPEND);

	  //adicionado para notificar mudanca de status do venda_lock
	 if (strpos($query,'venda_lock') !==false){
		file_put_contents('log/notify.txt', $agora);
         }

          
    }
	catch (Exception $e){
    // echo 'Problemas na gravação do log: ',  $e->getMessage(), "\n";
	}
}

function GetDirectorySize($path){
    $bytestotal = 0;
    $path = realpath($path);
    if($path!==false && $path!='' && file_exists($path)){
        foreach(new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path, FilesystemIterator::SKIP_DOTS)) as $object){
            $bytestotal += $object->getSize();
        }
    }
    return $bytestotal;
}

function ApagaArquivosAntigos()
{
	$path = "log/";
	$diretorio = dir($path);
	$iterator = new FilesystemIterator($path, FilesystemIterator::SKIP_DOTS);
	$contador =  iterator_count($iterator);
	$tamanho = GetDirectorySize('log');
	
	//echo($tamanho);
	//Só entra aqui quando a pasta for maior ou igual a 500 MB
	if($tamanho >= 500000)
	{ 
		$numlinha = 0;	
		while($arquivo = $diretorio -> read()){
			
			if($contador > $numlinha)
			{	
			//apago todos os arquivos mais antigos deixando apenas os ultimos dois
			unlink('log/'.$arquivo);
			//echo($arquivo.'<br>');
			$numlinha = $numlinha+1;	
			}
			
		//echo $arquivo.' - '.date ("d/m/Y H:i:s", filemtime($arquivo)). "<br />";
		//echo $arquivo.' '. ' TAM:'.filesize('log/'.$arquivo). date('d/m/Y H:i:s', filemtime('log/'.$arquivo))."<br>";
		}
		$diretorio -> close();
	}
}
?>