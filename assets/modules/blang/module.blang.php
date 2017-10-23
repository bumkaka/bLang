<?php
if (IN_MANAGER_MODE != "true" || empty($modx) || !($modx instanceof DocumentParser)) {
    die("<b>INCLUDE_ORDERING_ERROR</b><br /><br />Please use the MODX Content Manager instead of accessing this file directly.");
}
if (!$modx->hasPermission('exec_module')) {
    header("location: " . $modx->getManagerPath() . "?a=106");
}

$langs = explode(',', $langs);

$moduleurl = 'index.php?a=112&id=' . $_GET['id'] . '&';
$action = isset($_GET['action']) ? $_GET['action'] : 'home';
$data = array('moduleurl' => $moduleurl, 'manager_theme' => $modx->config['manager_theme'], 'session' => $_SESSION, 'action' => $action, 'selected' => array($action => 'selected'));


$table = $modx->getFullTableName('blang');

//Подключаем обработку шаблонов через DocLister
include_once(MODX_BASE_PATH . 'assets/snippets/DocLister/lib/DLTemplate.class.php');
require_once 'translate/src/Translation.php';
require_once 'translate/src/Translator.php';
require_once 'translate/src/Exception.php';
$tpl = DLTemplate::getInstance($modx);


switch ($action) {
    case 'home':
        foreach ($langs as $lang) {
            $data['lang_columns'] .= '{ fillspace:true,id:"' . $lang . '", editor:"text",	  name:"' . $lang . '",  header:"' . $lang . '",},';
            $data['lang_input'] .= '{view: "text",  name: "' . $lang . '", label: "' . $lang . '"},';
        }
        $template = '@CODE:' . file_get_contents(dirname(__FILE__) . '/templates/home.tpl');
        $outTpl = $tpl->parseChunk($template, $data);


        break;

    case 'getData':
        $sql = "select * from " . $table;
        $q = $modx->db->query($sql);
        $outData = $modx->db->makeArray($q);

        foreach ($outData as $key => $val) {
//            $outData[$key]['name'] = '[(__'.$outData[$key]['name'].')]';
        }

        break;
    case 'translate':

        $data = $_POST;

        $newData = [];

        $fromLanguage = '';
        $str = '';
        foreach ($langs as $lang) {
            if (!empty($data[$lang])) {
                $fromLanguage = $lang;
                $str = $data[$lang];
            }
        }



        foreach ($langs as $lang) {
            if ($lang == $fromLanguage || !empty($data[$lang])) {
                continue;
            }
            $transLang = $lang;
            $transFromLanguage = $fromLanguage;
            switch ($lang) {
                case 'ua':
                    $transLang = 'uk';
                    break;
            }
            switch ($fromLanguage) {
                case 'ua':
                    $transFromLanguage = 'uk';
                    break;
            }



            $translator = new Yandex\Translate\Translator($yandexKey);
            $translation = $translator->translate($str, $transFromLanguage . '-' . $transLang);
            $newData[$lang] = (string) $translation;
        }
        $newData[$fromLanguage] = $str;


        $outData = $newData;


        break;
    case 'save':

        $data = [];
        foreach ($_POST as $key => $item) {
            if ($key == 'webix_operation') {
                continue;
            }
            $data[$key] = $modx->db->escape($item);
        }
        if (!empty($_POST['webix_operation']) && $_POST['webix_operation'] == 'delete') {
            $modx->db->delete($table, 'id = ' . (int)$_POST['id']);
        } else if (empty($_POST['id'])) {
            $modx->db->insert($data, $table);
        } else {

            $resp = $modx->db->update($data, $table, 'id = ' . (int)$_POST['id']);


        }
        break;
}


if (!is_null($outTpl)) {
    $headerTpl = '@CODE:' . file_get_contents(dirname(__FILE__) . '/templates/header.tpl');
    $footerTpl = '@CODE:' . file_get_contents(dirname(__FILE__) . '/templates/footer.tpl');
    $output = $tpl->parseChunk($headerTpl, $data) . $outTpl . $tpl->parseChunk($footerTpl, $data);
} else {
    header('Content-type: application/json');
    $output = json_encode($outData, JSON_UNESCAPED_UNICODE);
}
echo $output;
