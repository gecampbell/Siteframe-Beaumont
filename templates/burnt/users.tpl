{* $Id: users.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
These are all the users registered on the site.
</div>

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{if $error ne ""}<p class="error">{$error}</p>{/if}

{section name=u loop=$users}
<p><a href="{$users[u].url}">{$users[u].user_name}</a> 
({$users[u].user_firstname} {$users[u].user_lastname})
{$users[u].user_info|strip_tags|truncate:300}<br />
Joined {$users[u].user_created|ydate:"$date_format"} |
Last signed on {$users[u].last_login|ydate:"$date_format"}
</p>
{/section}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
</div>{* class="text" *}

{include file="bottom.tpl"}