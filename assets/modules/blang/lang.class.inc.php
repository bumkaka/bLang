<?php

/**
* Plugin for MODx EVO LANG
* Created by Bumkaka from http://modx.im
* 
* Change log
	- add default root 
		* http://site.com/ru/index.html - lang root
		* http://site.com/index.html - default root
*
*/


if ( ! class_exists( 'LANG' ) )
{
  class LANG
	{
		private $MODX = NULL;
		public $default_lang='ru';
		public $langs=array('ru','ua','en');
		public  $roots=array('ru'=>'','ua'=>'ua/','en'=>'en/');
		public  $lang;
		public  $root;
		private $prefix = '_';
		
		
		public function InListLang()
			{
				$curr = $_GET['lang'];
				$result = false;
				
				foreach($this->langs as $key=>$value){
					if ($value == $curr) $result = true;
				}
				
				return $result;
			}

		 private function Initialise( $default_lang,$langs,$roots )
		{ 
			$this->default_lang = empty($default_lang)?$this->default_lang :$default_lang;
			$this->langs = empty($langs)?$this->langs:$langs;
			$this->roots = empty($roots)?$this->roots:$roots;
			
			
			global $modx;
			$this->MODX = &$modx;
			$this->lang = $_GET['lang'];
			$id = $modx->documentIdentifier;

			$InListLang = $this->InListLang();
			
			if (!$InListLang && !empty($_GET['lang'])) {
				$_GET['lang'] = $this->default_lang;
				$modx->sendErrorPage();
			}
			$config['lang'] = $this->lang = $InListLang ? $this->lang : $this->default_lang;
			$config['root'] = $this->root = $InListLang ? $this->roots[$this->lang] : $this->roots[$this->default_lang];
			
			foreach($this->langs as $key=>$value){
			  
				if ($this->MODX->config['site_start'] != $id){
					$config[$value.'_url'] = $this->roots[$value].'[~'.$id.'~]';
				} else {
					$config[$value.'_url'] = $this->roots[$value];
				}
			}
			
			foreach($config as $key=>$value){
					$this->MODX->config[ $this->prefix.$key] = $value;
			}
			
			
			$_LANG = parse_ini_string($this->MODX->getChunk($this->lang));
			if ( !empty($_LANG) ){
				foreach($_LANG as $key=>$value){
					$this->MODX->config['__'.$key] = $value;
				}
			}
			
			
			/**/
			//$this->MODX->config['l'] = $this->lang;
		}
	    
	
		private function __construct( $default_lang,$langs,$roots )
		{
		  $this->Initialise( $default_lang,$langs,$roots );
		}

		public static function GetInstance( $default_lang='',$langs='',$roots='' )
		{
		  if ( ! isset( self::$theirInstance ) )
		  {
			$c = __CLASS__;
			self::$theirInstance = new $c( $default_lang,$langs,$roots );
		  }

		  return self::$theirInstance;
		}

		private final function __clone()
		{
		  throw new Exception('Clone is not allowed on singleton (LANG).');
		}

		private static $theirInstance;
	
	}	
}
?>
