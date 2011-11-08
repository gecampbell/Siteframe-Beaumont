{* $Id: users.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
{section name=u loop=$users}
<p><big><a href="{$users[u].url}">{$users[u].user_name}</a> 
({$users[u].user_firstname} {$users[u].user_lastname})</big>
{$users[u].user_info|strip_tags|truncate:300}
<span class="info">
/ {$users[u].user_created|ydate:"Joined $date_format"}
/ {$users[u].last_login|ydate:"Last signed on $date_format"}
</span></p>
{/section}
</div>{* id="main-copy" *}

{include file="footer.tpl"}