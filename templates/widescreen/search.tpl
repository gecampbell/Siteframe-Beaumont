{* $Id: search.tpl,v 1.2 2005/12/05 00:05:27 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** This template displays an input form
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=0}
</head>
<body>
<div id="content">
{include file="header.tpl"}

<h1>{$page_title}</h1>

{if $rss_url ne ""}
{menu name="action" text="RSS" link=$rss_url}
{/if}
{menu name="action" text="Advanced Search" link="$site_path/advanced.php"}

{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{if $search_string ne ""}
<p class="error">{$num_results} result{if $num_results ne 1}s{/if} for <strong>{$search_string}</strong></p>
{/if}

{* search results, if any *}
{section name=i loop=$search_results}
<p style="line-height:120%;"><strong><a href="{$search_results[i].url}">{$search_results[i].title}</a></strong>
({$search_results[i].search_score|string_format:"%.2f"})<br />
<span class="info">{lang name="class_`$search_results[i].class`"} /
{$search_results[i].created|ydate:"$date_format"}</span>
</p>
{/section}

{* search form, always *}
<div class="searchform">
{$search_form}
</div>
</div>

{include file="footer.tpl"}
</div>
</body>
</html>
