{* $Id: favorites.tpl,v 1.2 2005/12/11 00:12:45 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Favorite Users</strong></p>
{section name=u loop=$users}
<p><a href="{$users[u].url}">{$users[u].user_name}</a></p>
{sectionelse}
<p>You have not selected any favorite users.</p>
{/section}
</div>{* id="mightylinks" *}

<div class="text">
{menu name="action" text="RSS 2.0" link="$rss_url"}
<h1><strong>{$page_title}</strong></h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<p>&nbsp;</p>
{section name=item loop=$fav_recent}
{include file="blog_item.tpl" page=$fav_recent[item]}
{sectionelse}
<p>There has been no recent activity by your favorite users.</p>
{/section}
</div>{* class="text" *}

{include file="bottom.tpl"}