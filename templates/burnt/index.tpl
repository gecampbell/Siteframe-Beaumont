{* $Id: index.tpl,v 1.3 2005/11/27 04:17:14 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
**
** This template is used to generate the overall home page for the entire
** site (not just a weblog or photo album).
*}
{include file="top.tpl"}

<div id="mightylinks"> 
  {if $cuser.id}
  {if $unread_msgs}
  <p style="color:red;">
  <strong>You have {$unread_msgs} unread memo{if $unread_msgs>1}s{/if}.</strong><br />
  <a href="{$site_path}/memos.php">Click here to read {if $unread_msgs>1}them{else}it{/if}</a>
  </p>
  <p>&nbsp;</p>
  {/if}

  <p><strong>My Stuff</strong></p>
  <p><a href="{$site_path}/user.php">My Page</a></p>
  <p><a href="{$site_path}/favorites.php">My Favorites</a></p>
  <p><a href="{$site_path}/subscriptions.php">My Subscriptions</a></p>
  <p><a href="{$site_path}/memos.php">My Memos</a></p>
  <p>&nbsp;</p>
  {/if}
<p><strong>New Users</strong></p>
<p>
{recent class="User" num=5}
<a href="{$user.url}">{$user.user_name}</a><br />
{/recent}
</p>
<p>&nbsp;</p>

<p><strong>New Folders</strong></p>
<p>
{recent class="Folder" num=5}
<a href="{$folder.url}">{$folder.title}</a> {$folder.folder_text|strip_tags|truncate:40}<br />
{/recent}
</p>
<p>&nbsp;</p>

<p><strong>New Groups</strong></p>
<p>
{recent class="Group" num=5}
<a href="{$group.url}">{$group.title}</a> {$group.group_text|strip_tags|truncate:40}<br />
{/recent}
</p>
<p>&nbsp;</p>

</div>{* id="mightylinks" *}

<div class="text">
<h1><strong>{$site_tagline|default:"Welcome"}</strong></h1>
<h2><strong>{$smarty.now|date_format:"$date_format $time_format"}.</strong></h2>
<p>&nbsp;</p>

{section name=item loop=$items}
{include file=$item_template page=$items[item]}
{/section}
</div>{* class="text" *}

{include file="bottom.tpl"}