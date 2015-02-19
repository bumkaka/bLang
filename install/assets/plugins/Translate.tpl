//<?php
/**
 * Translate plugin for Modx Evo
 * 
 * Bumkaka
 *
 * @category    plugin
 * @version     1.0
 * @author      Bumkaka <bumkaka@yandex.ru>
 * @internal    @properties &tvs=Строка с TV вида 6-ru->5-en,6-ru->5-en ;string;6-ru->5-en
 * @internal    @events OnBeforeDocFormSave,OnWebPageInit
 * @internal    @modx_category
 * @internal    @installset base
 */


require_once $modx->config['rb_base_dir'] . "modules/blang/helpers.php";

global $tmplvars;
$e =& $modx->event;
switch ($e->name) {
	case "OnBeforeDocFormSave":
	
	
	
	$tvTemp=explode(',',$tvs);
	foreach ($tvTemp as $value) {
		$tpl=explode('->',$value);
		if (!empty($tmplvars[$tpl[1]][1])) continue;
		$f = explode('-',$tpl[0]);
		$s = explode('-',$tpl[1]);
			 
		 
		$fields = array( 
			'35' => 'ta',
			'25' => 'pagetitle',
			'33' => 'menutitla',
			'27' => 'longtitle',
			'31' => 'introtext',
			'29' => 'description'
		);
		
		if (empty($_POST['tv'.$f[0]])) {
			saveTv($f[0],$_POST[ $fields[$f[0]] ]);
		}
		if (empty($tmplvars[$f[0]][1]) || !empty($_POST['tv'.$s[0]]) ) continue;
		
		$forSave = Translate($tmplvars[$f[0]][1],$f[1],$s[1]);  
		$forSave = str_replace('\"', '"', $forSave); 
		saveTv($s[0],$forSave);		
		//	die();
	}  
	
	break;
	
	case 'OnWebPageInit':
	
	if (!isset($_GET['translate'])) return;
	$MainLang = 'ru';
	require_once $modx->config['rb_base_dir'] . "modules/blang/lang.class.inc.php";
	$bLang = LANG::GetInstance();
	
	require_once $modx->config['rb_base_dir'] .'libs/resourse.php';
	$resourse=resourse::Instance($modx);
	
	
	$fields = array( 'pagetitle', 'menutitle','longtitle','introtext','description','content' );
	
	$ids = $modx->getChildIds(0);
	$langs = $bLang->langs;
	foreach($langs as $key=>$lang){ 
		if ($lang == $MainLang) unset($langs[$key]);
	}
	$langs = array_merge( array($MainLang) , $langs);
	
	$i = 0 ;
	foreach($ids as $id){
		$i++;
		//if ($i > 10) die();
		$resourse->document($id)->edit($id);
		echo '<br/>_________ ';
		echo 'Start resourse #'.$id.'<br/>';
		
		foreach($fields as $field){
			foreach($langs as $lang){
				
				$f = $resourse->get($field.'_'.$lang);
				$d = $resourse->get($field);
				$m = $resourse->get($field.'_'.$MainLang);
				$default = true;
				$current = true;
				
				
				$resourse->set($field, $resourse->get($field) );
				
				
				
				
				if ($lang == $MainLang){
					if (is_null($d) || empty($d)) $default = false;
					if (is_null($f) || empty($f)) $current = false;
					if ($default && !$current) {
						$resourse->set($field.'_'.$lang, $resourse->get($field));
						echo ' Set value from '.$field.'<br/>';
						continue;
					}
				}
				
				
				if (is_null($m) || empty($m)) $default = false;
				if (is_null($f) || empty($f) || $f == ' ') $current = false;
				if ($default && !$current) {
					$Translate = Translate($resourse->get($field.'_'.$MainLang),$MainLang,$lang);
					echo 'Tanslate value  '.$field.'_'.$lang.'<br/>';
					$resourse->set($field.'_'.$lang, $Translate  );
				}
				
				
			}
			
		}
		
		$resourse->save();
	}
	
	exit(0);
	die();
	break;
	
	
	default:
	break;
}