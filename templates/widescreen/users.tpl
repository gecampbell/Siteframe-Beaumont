{* $Id: users.tpl,v 1.3 2005/12/06 23:10:03 glen Exp $
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
{$users[u].user_info|strip_tags|truncate:300}
<span class="info">
  Joined {$users[u].user_created|ydate:"$date_format"}
/ Last signed on {$users[u].last_login|ydate:"$date_format"}
</span></p>
{/section}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
</div>{* id="main" *}

{include file="footer.tpl"}
</div>
</body>
</html>
