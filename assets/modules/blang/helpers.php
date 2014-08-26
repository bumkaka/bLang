<?php

	function Translate($str,$in1,$in2) {  
		$url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20131221T225123Z.6c3348e391afd517.7750896acb4560efdacc1109a1ebf5bd51d3f749";
		
		$params['text'] = $str;
		$params['lang'] = $in2;
		$params['format'] = 'html';
		$params['options'] = 1;
		
		$Headers = array(
			'User-Agent' => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; Media Center PC 4.0; .NET CLR 2.0.50727)",
			'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
			'Accept-Language' => "ru,en-us;q=0.7,en;q=0.3",
			'Accept-Encoding' => "gzip,deflate",
			'Accept-Charset' => "windows-1251,utf-8;q=0.7,*;q=0.7",
			'Keep-Alive' => '300',
			'Connection' => 'keep-alive',
		);
		
		if(!function_exists('curl_init')) {
			$response = file_get_contents($url.'&'.http_build_query($params));
			$R = json_decode( $response ,true);
			return $R['text'];
		} else {
			$res = curl_init();
			
			$options = array(
				CURLOPT_URL => $url.'&'.http_build_query($params),
				CURLOPT_HTTPHEADER => $Headers,
				CURLOPT_RETURNTRANSFER => true,
				CURLOPT_CONNECTTIMEOUT => 30,
				
			);
			
			curl_setopt_array($res, $options);
			$r = curl_exec($res);
			$response = json_decode($r,true);
			curl_close($res);
			echo $url.'&'.http_build_query($params);
			return $response['text'][0]; 
		}
		
	}  
	

	function saveTv($id, $str){
		global $tmplvars;
		
		if (is_array($tmplvars[$id])) {
			$tmplvars[$id][1]=$str;return;
		} else {    
			foreach($tmplvars as $key=>$value){
				if ($value==$id){
					unset($tmplvars[$key]);
					$tmplvars[$id]=array('0'=>$id,'1'=>$str);
				}
				
			}
		}
		
	}



?>