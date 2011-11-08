{* $Id: user.tpl,v 1.3 2006/01/02 20:03:05 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

{* user action menu *}
{menu name="action" link="`$user.rss_url`" text="RSS 2.0"}
{if $cuser.id}
{menu name="action" link="$site_path/mail.php?to=`$user.user_id`" text="Send E-mail"}
{menu name="action" link="$site_path/edit.php?c=Memo&amp;memo_to_user_id=`$user.user_id`" 
      text="Send Memo"}
{/if}

<div id="mightylinks">
{if $user.user_photo ne ""}
<img src="{thumbnail file=$user.user_photo type=$user.user_photo_type size=100}" alt="{$user.user_name}" style="margin-bottom:1em;"/>
{/if}
<p><strong>Folders</strong></p>
<p>
{section name=i loop=$user_folders}
<p><a href="{$user_folders[i].url}">{$user_folders[i].folder_title}</a>
{$user_folders[i].folder_text|strip_tags|truncate:50}</p>
{/section}
<p>&nbsp;</p>

{* visitor view user menu *}
{menu name="user" link="$site_path/favorites.php?id=`$user.user_id`"
      text="Favorites"}
{menu name="user" link="$site_path/links.php?u=`$user.user_name`" text="Links"}
{if $cuser.id eq $user.id}
{menu name="user" link="$site_path/subscriptions.php?user=`$user.user_id`"
      text="Subscriptions"}
{menu name="user" link="$site_path/pwchange.php" text="Change My Password"}
{menu name="user" link="$site_path/pwreset.php" text="Reset My Password"}
{/if}

{if $error ne ""}<p class="error">{$error}</p>{/if}
<p><strong>Also</strong></p>
<p>{menu name="user" sep="<br />"}</p>
<p>Last login: {$user.last_login|ydate:"$date_format $time_format"}</p>
</div>{* id="mightylinks" *}

<div class="text">
<h1>{if $is_favorite}<img src="{$site_path}/images/biggoldstar.jpg" alt="Favorite" style="float:right;"/>{/if}<strong>{$page_title}</strong></h1>

{$user.user_info|default:"<p>No user info provided</p>"}
{if $cuser.id == $user.id}
<p>&raquo;&nbsp;<a href="javascript:toggle('uinfo');">Private Information</a></p>
<div id="uinfo" style="display:none; background:white; padding:3px;">
<p>Your API key is: {$user.user_hash}</p></div>
{/if}
<p>&nbsp;</p>
{recent class="Page" user=$user.user_id num=10}
{include file="blog_item.tpl" page=$page}
{/recent}

</div>{* class="text" *}

{include file="../favorite.tpl"}

{assign var=_editor value=$user._owner}
{assign var=edit_url value=$user.edit_url}
{assign var=delete_url value=$user.delete_url}
{include file="bottom.tpl"}