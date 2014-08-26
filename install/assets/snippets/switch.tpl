//<?php
/**
 * switch
 * 
 * Roadway :)
 *
 * @category 	snippet
 * @version 	1
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@properties 
 * @internal	@modx_category lang
 * @internal    @installset base
 */


$Mlang = LANG::GetInstance();
$lang=(string)$Mlang->lang;
if ($name) return '[*'.$name.'_'.$lang.'*]';
echo $$lang;

