//<?php
/**
 * BLang
 * 
 * just make MODx evo is easy
 *
 * @category    plugin
 * @version     0.6
 * @author		Bumkaka
 * @internal    @properties;
 * @internal    @events OnLoadWebPageCache,OnLoadWebDocument
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








require_once MODX_BASE_PATH.'assets/modules/blang/lang.class.inc.php';
$Lang = LANG::GetInstance('ru',array('ru','ua','en'), array('ru'=>'','ua'=>'ua/','en'=>'en/'));
$lang=(string)$Lang->lang;

$access = $modx->getTemplateVar('access_'.$lang, '*', $modx->documentIdentifier);
if ($access['value']=='0') $this->sendForward( $modx->config['site_url'].$modx->config['_root'], 'HTTP/1.0 404 Not Found');


/*
* for bAuth
*/
$_SESSION['_root'] = $modx->config['_root'];

