{* $Id: group.tpl,v 1.6 2005/12/31 04:28:41 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Group Members</strong></p>
{section name=u loop=$users}
<p>{if $_editor}
<a href="{$site_path}/api.php?api_key={$cuser.user_hash}&amp;v=1&amp;m=RemoveUserFromGroup&amp;user={$users[u].id}&amp;group={$group_id}&amp;bounce=1"><img src="{$site_path}/images/icon_delete.jpg" alt="" style="margin-bottom:0;" /></a>
{/if}
<a href="{$users[u].url}">{$users[u].user_name}</a> 
    ({$users[u].user_firstname} {$users[u].user_lastname})</p>
{sectionelse}
<p>No members yet</p>
{/section}
<p>&nbsp;</p>

<p><strong>Group Owner</strong></p>
<p><a href="{$user.url}">{$user.user_name}</a></p>
</div>{* id="mightylinks" *}

<div class="text">
{menu name="action" text="All Groups" link="$site_path/groups.php"}
{menu name="action" text="RSS 2.0" link="$rss_url"}
{* action menu options *}
{if $cuser.user_id}
    {if $group_open}
    {menu name="action" text="Join Group" link="$REQUEST_URI&amp;op=join"}
    {/if}
    {menu name="action" text="Leave Group" link="$REQUEST_URI&amp;op=leave"}
    {menu name="action" text="Send E-mail" link="$site_path/mail.php?group=$group_id"}
{/if}

<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{if $error ne ""}<p class="error">{$error}</p>{/if}
<div id="hello">
{$group_text}
</div>

{* recent group activity *}
{section name=gr loop=$group_recent}
{include file="blog_item.tpl" page=$group_recent[gr]}
{/section}
{if $_editor}
<p>&nbsp;</p>
<form name="addmembers" id="addmembers" action="{$site_path}/group.php" method="get">
<label>Add Members To Group</label>
<input type="hidden" name="id" value="{$group_id}" />
<input type="text" name="add" />
<input type="submit" value="Add Members" />
</form>
{/if}
</div>{* class="text" *}

{include file="bottom.tpl"}