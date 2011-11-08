{* $Id: header.tpl,v 1.4 2006/01/05 18:01:20 glen Exp $
** Page header
*}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

<head>
<title>{$page_title}</title>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
<link rel="stylesheet" type="text/css"
      href="{$site_path}/{$template_dir}/images/style.css" />
<link rel="stylesheet" type="text/css" 
      href="{$site_path}/{$template_dir}/siteframe.css?v={$BUILD}" />
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
			{$site_name}
			<h2>{$site_tagline}</h2>
		</div>{* id="header" *}
		
		<div id="horizontal">
            <span style="float:right;">
            {if $cuser.id}
                <a href="{$site_path}/user.php">My Page</a>
                <a href="{$site_path}/login.php">Sign Out</a>
            {else}
                <a href="{$site_path}/register.php">Register</a>
                <a href="{$site_path}/login.php">Sign In</a>
            {/if}
            </span>
		    <a href="{$site_path}/">Home</a>
            {all class=Folder parent=0}
            <a href="{$folder.url}">{$folder.title}</a>
            {/all}
		</div>{* id="horizontal" *}
