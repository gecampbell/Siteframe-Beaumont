{* $Id: header.tpl,v 1.16 2006/05/18 17:47:05 glen Exp $
** Page header
*}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>{$site_name} - {$page_title}</title>
<link href="{$site_path}/{$template_dir}/style.css" rel="stylesheet" type="text/css" />
<link href="{$site_path}/{$template_dir}/siteframe.css?v={$BUILD}" rel="stylesheet" type="text/css" />
<meta http-equiv="content-type" content="text/html; charset={$charset}" />
<meta name="generator" content="Siteframe Beaumont {$VERSION}({$BUILD})" />
<meta name="copyright" content="{$site_copyright}" />
<meta name="revisit-after" content="1 days" />
<meta name="dc.title" content="{$site_name}" />
<meta name="dc.creator.e-mail" content="{$site_email}" />
<meta name="dc.format" content="multipart/mixed" />
<meta name="dc.identifier" scheme="uri" content="{$site_url}" />
<meta name="dc.language" scheme="rfc1766" content="{$lang_default}" />
<meta name="dc.relation.ispartof" content="{$site_url}" />
<script type="text/javascript" language="javascript" src="{$site_path}/javascript/siteframe.js"></script>
{if $cuser.user_editor && ($cuser.user_editor != "none")}
  {assign var=rich_text_editor value=$cuser.user_editor}
{/if}
{if $cuser.user_editor && ($cuser.user_editor != "none")}
  {assign var=rich_text_editor value=$cuser.user_editor}
{/if}
{if $rte_enable && $rich_text_editor ne "" && $cuser.id}
<!-- using rich_text_editor={$rich_text_editor} -->
{include file="rte_head_$rich_text_editor.tpl"}
{/if}
{include file="../head_rss.tpl"}
{include file="../trackback.tpl"}
</head>
<body>
<div id="container">

	<div id="header">
	  <h1>{$title|default:"$site_name"}</h1>
	  <p>{$subtitle|default:$site_tagline|strip_tags|truncate:50}</p>
	  	<form name="searchform" id="searchform" method="get" action="{$site_path}/search.php">
	  	<input type="text" name="q" value="Search..." onfocus="this.style.color='black';this.value='';"/>
	  	<input class=" button" type="submit" name="Submit" value="GO" />
	  </form>
	</div>{* id="header" *}
	
	<div id="navigation"> 
		<ul id="navlist">
			<li><a href="{$site_path}/">Home</a></li>
			{if $script ne "setup.php"}
			{all class=Folder parent=0}
			<li><a href="{$folder.url}">{$folder.title}</a></li>
			{/all}
			{/if}
			<br />
            {if $cuser.id}
            <li><a href="{$cuser.url}">My Page</a></li>
            <li><a href="{$site_path}/login.php">Sign Off</a></li>
            <li><a href="{$site_path}/edit.php?c=Invitation">Invite</a></li>
            {else}
            <li><a href="{$site_path}/login.php">Sign On</a></li>
            <li><a href="{$site_path}/register.php">Register</a></li>
            {/if}
		</ul>
    </div>{* id="navigation" *}
