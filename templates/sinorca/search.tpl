{* $Id: search.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $search_string ne ""}
<p class="error">{$num_results} result{if $num_results ne 1}s{/if} for <strong>{$search_string}</strong></p>
{/if}
{* search results, if any *}
{section name=i loop=$search_results}
<p><strong><a href="{$search_results[i].url}">{$search_results[i].title}</a></strong>
({$search_results[i].search_score|string_format:"%.2f"})<br />
<span class="info">{lang name="class_`$search_results[i].class`"} &bull;
{$search_results[i].created|ydate:"$date_format"}</span></p>
{/section}
{* search form, always *}
<div class="searchform">
{$search_form}
</div>
</div>{* id="main-copy" *}

{include file="footer.tpl"}