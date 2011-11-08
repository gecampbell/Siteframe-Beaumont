{* $Id: search.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** This template displays an input form
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Search Results</strong></p>
<p>Your search results are shown on this page.</p>
</div>

<div id="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{if $rss_url ne ""}
{menu name="action" text="RSS" link=$rss_url}
{/if}
{menu name="action" text="Advanced Search" link="$site_path/advanced.php"}

{if $error ne ""}<p class="error">{$error}</p>{/if}

{if $search_string ne ""}
<p class="error">{$num_results} result{if $num_results ne 1}s{/if} for <code>{$search_string}</code></p>
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
</div>{* class="text" *}

{include file="bottom.tpl"}