{* $Id: list.tpl,v 1.1 2005/12/21 18:38:05 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
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
</div>{* id="content" *}

{include file="footer.tpl"}