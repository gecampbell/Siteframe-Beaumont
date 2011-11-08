{* $Id: folders.tpl,v 1.1 2005/12/21 05:53:31 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
&nbsp;
</div>{* id="sidebar" *}

<div id="content">
<h2>{lang name="class_File"}: {$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/folders.php"}
{section name=cur loop=$folders}
<p class="blog_item">
<big><a href="{$folders[cur].url}">{$folders[cur].folder_title}</a></big>
{$folders[cur].folder_text|strip_tags|truncate:300}
<span class="info">
/ <a href="{$folders[cur].user.url}">{$folders[cur].user.user_name}</a>
/ {$folders[cur].folder_created|ydate:"on $date_format at $time_format"}
</span>
</p>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}