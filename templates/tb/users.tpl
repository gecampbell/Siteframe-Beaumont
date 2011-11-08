{* $Id: users.tpl,v 1.5 2005/12/01 04:15:08 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
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
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{section name=u loop=$users}
<p><big><a href="{$users[u].url}">{$users[u].user_name}</a> 
({$users[u].user_firstname} {$users[u].user_lastname})</big>
{$users[u].user_info|strip_tags|truncate:300}<br />
<span class="info">
/ {$users[u].user_created|ydate:"Joined $date_format"}
/ {$users[u].last_login|ydate:"Last signed on $date_format"}
</span></p>
{/section}
</div>{* id="main" *}


{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
{include file="footer.tpl"}
</div>
</body>
</html>
