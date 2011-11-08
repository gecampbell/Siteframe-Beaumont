{* $Id: html_head.tpl,v 1.10 2006/01/18 00:32:36 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the <head> section of html
*}
<!-- site: {$site_name} -->
<title>{$page_title}</title>
<!-- META tags provide extra metadata for the page -->
<meta http-equiv="content-type" content="text/html; charset={$charset}" />
<meta name="generator" content="Siteframe Beaumont {$VERSION}({$BUILD})" />
<meta name="description" content="{$site_tagline}" />
<meta name="copyright" content="{$site_copyright}" />
<meta name="revisit-after" content="1 days" />
<meta name="dc.title" content="{$site_name}" />
<meta name="dc.creator.e-mail" content="{$site_email}" />
<meta name="dc.format" content="multipart/mixed" />
<meta name="dc.identifier" scheme="uri" content="{$site_url}" />
<meta name="dc.language" scheme="rfc1766" content="{$lang_default}" />
<meta name="dc.relation.ispartof" content="{$site_url}" />
{include file="../trackback.tpl"}
<link rel="stylesheet" type="text/css" href="{$site_path}/{$template_dir}/ws.css?v={$BUILD}" />
<style type="text/css">
#header {ldelim} background: #eee url({$widescreen_header_background_image|default:"$site_path/$template_dir/duck.jpg"}) top right no-repeat; height:90px;{rdelim}
</style>
{if $widescreen_css}<link rel="stylesheet" type="text/css" href="{$widescreen_css}" />{/if}
<script type="text/javascript" src="{$site_path}/javascript/siteframe.js"></script>
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
