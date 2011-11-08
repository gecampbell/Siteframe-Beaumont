{* $Id: list.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/list.php?c=$class"}
<ul>
{section name=cur loop=$items}
<li><a href="{$items[cur].url}">{$items[cur].title}</a>
&bull;
{if $class ne "User"}
    <a href="{$items[cur].user.url}">{$items[cur].user.user_name}</a>
{/if}
</li>
{/section}
</ul>
</div>{* id="main-copy" *}

{include file="footer.tpl"}