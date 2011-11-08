{* $Id: user.tpl,v 1.15 2006/01/02 20:03:05 glen Exp $
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

<h1>{if $is_favorite}<img src="{$site_path}/images/biggoldstar.jpg" alt="Favorite" />{/if}{$page_title}</h1>

{* user action menu *}
{if $cuser.id}
{menu name="action" link="$site_path/mail.php?to=`$user.user_id`" text="Send E-mail"}
{menu name="action" link="$site_path/edit.php?c=Memo&amp;memo_to_user_id=`$user.user_id`" 
      text="Send Memo"}
{/if}

<div id="main">

<div id="hello">
{$user.user_info|default:"No user information provided."}
{if $cuser.id == $user.id}
Your API key is: {$user.user_hash}
{/if}
</div>

{recent class="Page" user=$user.user_id num=10}
{include file="blog_item.tpl" page=$page}
{/recent}

</div>{* id="main" *}

<div id="menu">
{if $user.user_photo ne ""}
<img src="{thumbnail file=$user.user_photo type=$user.user_photo_type maxw=120}" alt="{$user.user_name}" style="margin-bottom:1em;"/>
{/if}
<ul>
<li><big>Folders</big></li>
{section name=i loop=$user_folders}
<li><a href="{$user_folders[i].url}">{$user_folders[i].folder_title}</a>
{$user_folders[i].folder_text|strip_tags|truncate:50}</li>
{/section}
</ul>

{* visitor view user menu *}
{menu name="user" link="$site_path/favorites.php?id=`$user.user_id`"
      text="Favorites"}
{menu name="user" link="$site_path/links.php?u=`$user.user_name`" text="Links"}
{if $cuser.id eq $user.id}
{menu name="user" link="$site_path/subscriptions.php?user=`$user.user_id`"
      text="My Subscriptions"}
{menu name="user" link="$site_path/pwchange.php" text="Change My Password"}
{menu name="user" link="$site_path/pwreset.php" text="Reset My Password"}
{/if}

{if $error ne ""}<p class="error">{$error}</p>{/if}
<ul>
<li><big>See also</big></li>
<li>{menu name="user" sep="</li><li>"}
</li>
<li>Last login: {$user.last_login|ydate:"$date_format $time_format"}</li>
</ul>
<p><a href="{$user.rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="menu" *}

{include file="../favorite.tpl"}

{assign var=_editor value=$user._owner}
{assign var=edit_url value=$user.edit_url}
{assign var=delete_url value=$user.delete_url}
{include file="footer.tpl"}
</div>
</body>
</html>
