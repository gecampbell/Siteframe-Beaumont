{* $Id: groups.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}
{menu name="action" link="$site_path/edit.php?c=Group" text="Create New Group"}

<div id="right-column">
{include file="searchbox.tpl"}
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/groups.php"}
{section name=cur loop=$groups}
<p class="blog_item">
<big><a href="{$groups[cur].url}">{$groups[cur].title}</a></big>
{$groups[cur].group_text|strip_tags|truncate:300}
<span class="info">
/ <a href="{$groups[cur].user.url}">{$groups[cur].user.user_name}</a>
/ {$groups[cur].group_created|ydate:"on $date_format at $time_format"}
</span>
</p>
{/section}
</div>{* id="main-copy" *}

{include file="footer.tpl"}