//<?php
/**
 * BLang
 * 
 * just make MODx evo is easy
 *
 * @category    plugin
 * @version     0.6
 * @author		Bumkaka
 * @internal    @properties &fields=Поля для перевода;string;pagetitle,longtitle,menutitle,introtext,content &translate=Автоперевод (1/0);string;0 &languages=Языки;string;ru,en,ua &root=Главный язык;string;ru &yandexKey=Клю для yandex api;string;
 * @internal    @events OnLoadWebPageCache,OnLoadWebDocument,OnDocFormSave
 * @internal    @modx_category BLang
 * @internal    @installset base
 */

/*
*	plugin BLang
*	From pack "Multilanguage"
*
*   Author: Bumkaka (find me at bumkaka.com)
*	skype: 	bumkaka2
*	email:  bumkaka@yandex.ru
*
*	date: 	14/06/2014
*	version:0.6
*/


if (!function_exists('prepareLang')){
    function prepareLang($lang){
        switch ($lang){
            case 'ua':
                $lang = 'uk';
                break;
        }
        return $lang;
    }
}
if (!function_exists('crawlerDetect')){
	function crawlerDetect(){
		$BotList = array('Googlebot', 'Baiduspider', 'ia_archiver',
        'R6_FeedFetcher', 'NetcraftSurveyAgent',
        'bingbot', 'facebookexternalhit', 'PrintfulBot',
        'msnbot', 'Twitterbot', 'UnwindFetchor',
        'urlresolver', 'Butterfly', 'TweetmemeBot', 'tweet','Yammybot', 'Openbot', 'Yahoo', 'Slurp',  'Lycos',  'AltaVista', 'Teoma', 'Gigabot', 'Googlebot-Mobile', "alexa", "froogle",  "inktomi", "looksmart", "URL_Spider_SQL", "Firefly",
						 "NationalDirectory", "Ask","Jeeves", "TECNOSEEK", "InfoSeek", "WebFindBot", "girafabot", "crawler",
						 "www.galaxy.com", "Googlebot/2.1", "Google", "Scooter", "James Bond",
						  "appie", "FAST", "WebBug", "Spade", "ZyBorg", "rabaz", "Feedfetcher-Google",
						 "TechnoratiSnoop", "Rankivabot", "Mediapartners-Google", "Sogou","spider", "MJ12bot",
						 "Yandex/", "YaDirectBot", "StackRambler","DotBot","dotbot","LinkedInBot");
		$agent = strtolower($_SERVER['HTTP_USER_AGENT']);
		foreach($BotList as $bot) {
			if(strpos(  $agent , strtolower($bot) ) !==false) {
				return $bot;
			}
		}
		return false;
	}
}

$e =& $modx->event;
$modx->config['agent'] = $_SERVER['HTTP_USER_AGENT'];

$fields = isset($fields)?$fields:'';
$translate = isset($translate)?$translate:0;
$languages = isset($languages)?explode(',',$languages):'';
$root = isset($root)?$root:'ru';
$yandexKey = isset($yandexKey)?$yandexKey:'';


if ($e->name == 'OnDocFormSave' && $translate == 1 ) {

require_once MODX_BASE_PATH.'assets/modules/blang/translate/src/Translation.php';
require_once MODX_BASE_PATH.'assets/modules/blang/translate/src/Translator.php';
require_once MODX_BASE_PATH.'assets/modules/blang/translate/src/Exception.php';
require_once MODX_BASE_PATH.'assets/lib/MODxAPI/modResource.php';



$sql = "select * from ".$modx->getFullTableName('site_tmplvars');
$q = $modx->db->query($sql);
$resp = $modx->db->makeArray($q);

$tvs = [];
foreach ($resp as $re) {

$tvs[$re['name']] = 'tv'.$re['id'];
}


$data = [];
$fields = explode(',',$fields);



if(empty($_POST[$tvs['pagetitle_'.$root]]) && !empty($_POST['pagetitle'])){
$_POST[$tvs['pagetitle_'.$root]] = $_POST['pagetitle'];
$data['pagetitle_'.$root] = $_POST['pagetitle'];
}

$translator = new Yandex\Translate\Translator($yandexKey);

if(is_array($languages)){
foreach ($languages as $lang) {
if($lang == $root){ continue;}
foreach ($fields as $field) {


if(empty($_POST[$tvs[$field.'_'.$root]]) || !empty($_POST[$tvs[$field.'_'.$lang]])){continue;}

$translation = $translator->translate($_POST[$tvs[$field.'_'.$root]], prepareLang($root) . '-' . prepareLang($lang));
$data[$field.'_'.$lang] = (string) $translation;
}
}
}
$doc = new modResource($modx);
$doc->edit((int) $id);
foreach ($data as $key => $value) {
$doc->set($key,$value);
}
$doc->save(false,false);
}
if ($e->name == 'OnLoadWebDocument' && !crawlerDetect()) {
$l = explode('-',$_SERVER['HTTP_ACCEPT_LANGUAGE'])	;


if ( empty( $_COOKIE['deflang'])){
if ( strtolower( $l[0] ) !='ru' && strtolower( $l[0] ) !='ua'){
$_GET['lang'] = 'en';
} else {
$_GET['lang'] = 'ru';
}
setcookie('deflang', $_GET['lang'] , time() + 10000000, '/');
$modx->sendRedirect( 'http://'.$_SERVER['HTTP_HOST'].'/'.($_GET['lang']=='en'?'en/'.$_GET['q']:$_GET['q']) );

}
}

$languageUrls = [];
foreach ($languages as $language) {
if($language == $root){
$languageUrls[$language] = '';
}
else{
$languageUrls[$language] = $language.'/';
}
}
require_once MODX_BASE_PATH.'assets/modules/blang/lang.class.inc.php';
$Lang = LANG::GetInstance($root,$languages, $languageUrls);
$lang=(string)$Lang->lang;

$access = $modx->getTemplateVar('access_'.$lang, '*', $modx->documentIdentifier);
if ($access['value']=='0') $this->sendForward( $modx->config['site_url'].$modx->config['_root'], 'HTTP/1.0 404 Not Found');


/*
* for bAuth
*/
$_SESSION['_root'] = $modx->config['_root'];

