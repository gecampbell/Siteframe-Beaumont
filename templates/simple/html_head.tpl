{* $Id: html_head.tpl,v 1.42 2005/12/31 23:36:39 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the <head> section of html
*}
<!-- site: {$site_name} -->
<head>
<title>{$page_title}</title>
<!-- META tags provide extra metadata for the page -->
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
{include file="../trackback.tpl"}
<link rel="stylesheet" type="text/css" href="{$site_path}/{$template_dir}/simple.css?v={$BUILD}" />
<script type="text/javascript" language="javascript" src="{$site_path}/javascript/siteframe.js"></script>
{if $cuser.user_editor && ($cuser.user_editor != "none")}
  {assign var=rich_text_editor value=$cuser.user_editor}
{/if}
{if $rte_enable && $rich_text_editor ne "" && $cuser.id}
<!-- using rich_text_editor={$rich_text_editor} -->
{include file="rte_head_$rich_text_editor.tpl"}
{/if}

{include file="../head_rss.tpl"}

<style type="text/css">
#header {ldelim} background: #f90 url({$site_path}/{$template_dir}/ne.gif) top right no-repeat; padding:0; text-align:left; {rdelim}
#header_title {ldelim} text-align:center; padding:10px; background: #f90 url({$site_path}/{$template_dir}/nw.gif) top left no-repeat; margin-right:20px; padding-left:20px; {rdelim}
</style>

</head>
<body>

<div id="bodydiv">

<div id="header">
<div id="header_title">
{if $head_type eq "folder"}
    <div id="tagline"><a href="{$site_url}">{$site_name}</a></div>
    <a href="{$url}">{$folder_title}</a>
{elseif $head_type eq "page"}
    <div id="tagline"><a href="{$site_url}">{$site_name}</a></div>
    <a href="{$folder.url}">{$folder.folder_title}</a>
{else}
    <a href="{$site_url}">{$site_name}</a>
    <div id="tagline">
    {$site_tagline}
    </div>
{/if}
</div>
</div>
<div class="top_menu">
<span style="float:right;">
    <a href="{$site_path}/login.php">{if $cuser.user_id}{lang name="prompt_logout"
}{else}{lang name="prompt_login"}{/if}</a> |
    {if !$cuser.user_id}
        <a href="{$site_path}/register.php">Register</a> |
    {/if}
    <a href="{$site_path}{if $url_rewriting}/adhoc/help{else}/text.php?id=help{/if}">Help</a> |
    <a href="{$site_path}/">Home</a>
</span>
{if $cuser.user_name ne ""}
    Welcome, <a href="{$cuser.url}">{$cuser.user_name}</a>!
{else}
    Greetings!
{/if}
</div>
<div id="central">
