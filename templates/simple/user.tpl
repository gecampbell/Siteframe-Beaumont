{* $Id: user.tpl,v 1.42 2006/01/02 20:03:05 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

{* user action menu *}
{menu name="action" link="`$user.rss_url`" text="RSS 2.0"}
{if $cuser.id eq $user.id}
{menu name="action" link="$site_path/subscriptions.php?user=`$user.user_id`"
      text="Subscriptions"}
{menu name="action" link="$site_path/pwchange.php" text="Change Password"}
{menu name="action" link="$site_path/pwreset.php" text="Reset Password"}
{/if}

{* visitor view user menu *}
{menu name="user" link="$site_path/images.php?id=`$user.user_id`" text="Images"}
{menu name="user" link="$site_path/files.php?id=`$user.user_id`" text="Files"}
{menu name="user" link="$site_path/favorites.php?id=`$user.user_id`"
      text="Favorites"}
{menu name="user" link="$site_path/links.php?u=`$user.user_name`" text="Links"}
{menu name="user" link="$site_path/mail.php?to=`$user.user_id`" text="E-mail"}
{menu name="user" link="$site_path/edit.php?c=Memo&amp;memo_to_user_id=`$user.user_id`" 
      text="Memo"}
{menu name="user" text="Last signed on: "}

<h1>{if $is_favorite}<img src="{$site_path}/images/biggoldstar.jpg" alt="Favorite" />{/if}{$page_title}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}
<p class="menu">{menu name="user" sep=" | "}
{$user.last_login|ydate:"$date_format $time_format"}
</p>
{if $user.user_photo ne ""}
<img src="{thumbnail file=$user.user_photo type=$user.user_photo_type size=100}" alt="{$user.user_name}" style="float:right;"/>
{/if}

{$user.user_info}

{if $cuser.id == $user.id}
<p><small>Your API key is: {$user.user_hash}</small></p>
{/if}
{* recent pictures *}
<h2>Recent Images</h2>
<div class="thumbnails">
{recent class="File" image=1 user=$user.user_id}
  <div class="thumbnail">
  <a href="{$file.url}"><img src="{thumbnail file=$file.file_path type=$file.file_type size=100 center=true}" alt="{$file.file_name}" /></a>
  </div>
{/recent}
</div>

{* user's folders *}
<h2 style="clear:both;">Folders</h2>
<table class="list">
<tr>
    <th>Folder </th>
    <th>Created </th>
    <th>Action </th>
</tr>
{section name=i loop=$user_folders}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle name="f" values="odd,even"}">
<td><a href="{$user_folders[i].url}">{$user_folders[i].folder_title}</a><br />
{$user_folders[i].folder_text|strip_tags|truncate:100}</td>
<td style="white-space:nowrap;">{$user_folders[i].folder_created|ydate:"$date_format $time_format"}</td>
<td style="white-space:nowrap;width:100px;">
{if $user_folders[i]._editor}
  <a href="{$user_folders[i].edit_url}">Edit</a> |
  <a href="{$user_folders[i].delete_url}">Delete</a> 
{/if}
</td>
{/section}
</table>

{* user's recent pages *}
<h2 style="clear:both;">Recent Pages</h2>
<table class="list">
<tr>
    <th>Folder </th>
    <th>Created </th>
    <th>Action </th>
</tr>
{recent class="Page" user=$user.user_id num=10}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle name="p" values="odd,even"}">
<td><a href="{$page.url}">{$page.page_title}</a><br />
{$page.page_text|strip_tags|truncate:100}</td>
<td style="white-space:nowrap;">{$page.page_created|ydate:"$date_format $time_format"}</td>
<td style="white-space:nowrap;width:100px;">
{if $page._editor}
  <a href="{$page.edit_url}">Edit</a> |
  <a href="{$page.delete_url}">Delete</a> 
{/if}
</td>
{/recent}
</table>

{include file="../favorite.tpl"}

</div>{* class="content" *}

{assign var=_editor value=$user._owner}
{assign var=edit_url value=$user.edit_url}
{assign var=delete_url value=$user.delete_url}
{include file="footer.tpl"}
