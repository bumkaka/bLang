V 0.6 

function mergeSettingsContent($content) {
	if (strpos($content, '[(') === false)
		return $content;
	$replace= array ();
	$matches= array ();
	if (preg_match_all('~\[\(([a-zA-Z0-9\_]*?)\)\]~', $content, $matches)) {
		$settingsCount= count($matches[1]);
		for ($i= 0; $i < $settingsCount; $i++) {
			if (array_key_exists($matches[1][$i], $this->config)){
				$content= str_replace($matches[0][$i], $this->config[$matches[1][$i]], $content);
			}
		}
	}
	return $content;
}	
	
	
	
	
	
	
	# MODx EVO Lang Pack By Bumkaka

## Installing
- - -


#### 1)  Add folowing rows in `.htaccess` before: `# For Friendly URLs` 
	RewriteRule ^([a-z]{2})$ $1/ [R=301,L]
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteRule ^([a-z]{2})/(.*)$ index.php?q=$2&lang=$1 [L,QSA]



# Use
- - -

### Examples

Language selecting 
```
<select name="countries" id="select_" onchange="window.location.href = $(this).val()">
    <option value='(ru_url)' [!if?is=`[!lang!]:=:ru` &then=`selected`!]>Русский</option>
    <option value='(en_url)' [!if?is=`[!lang!]:=:en` &then=`selected`!]>English</option>
</select>
```


EForm
```
[!eForm? 
&to=`bumkaka@yandex.ru`
&formid=`QaForm` 
&subject=`Вопрос с сайта` 
&tpl=`eQaForm_(lang)` 
&report=`eQaReport` 
&gotoid=`[*id*]` 
&vericode=`0` 
&language=`[[switch?ru=`russian-UTF8` &en=`english`]]`
!] 
```

Wayfinder
```
[[Wayfinder? &startId=`0` &outerClass=`menu` &level=`1` &firstClass=`first` &rowTpl=`MenuRowTpl`]]
```
tpl-`MenuRowTpl`:
```
<li [+wf.classes+] id="id[+wf.docid+]">
	<a href="(root)[~[+wf.docid+]~]" title="[[switch?ru=`[+pagetitle_ru+]` &en=`[+pagetitle_en+]` &fr=`[+pagetitle_fr+]`]]">
	[[switch?
		&ru=`[[if?is=`[+menutitle_ru+]:=:` &then=`[+pagetitle_ru+]` &else=`[+menutitle_ru+]`]]` 
		&en=`[[if?is=`[+menutitle_en+]:=:` &then=`[+pagetitle_en+]` &else=`[+menutitle_en+]`]]` 
		&fr=`[[if?is=`[+menutitle_fr+]:=:` &then=`[+pagetitle_fr+]` &else=`[+menutitle_fr+]`]]
	`]]
</a>[+wf.wrapper+]</li>

```