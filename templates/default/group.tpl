{* $Id: group.tpl,v 1.11 2005/12/31 04:28:41 glen Exp $
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

<h1>{$page_title}</h1>

<div id="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div id="main">
<div id="hello">
{$group_text}
</div>

{* recent group activity *}
{section name=gr loop=$group_recent}
{include file="blog_item.tpl" page=$group_recent[gr]}
{/section}
{if $_editor}
<form name="addmembers" id="addmembers" action="{$site_path}/group.php?id={$group_id}" method="get">
<label>Add Members To Group</label>
<input type="hidden" name="id" value="{$group_id}" />
<input type="text" name="add" />
<input type="submit" value="Add Members" />
</form>
{/if}
</div>{* id="main" *}

<div id="menu">
<ul>
<li><big>Group Members</big></li>
{section name=u loop=$users}
<li>{if $_editor}
<a href="{$site_path}/api.php?api_key={$cuser.user_hash}&amp;v=1&amp;m=RemoveUserFromGroup&amp;user={$users[u].id}&amp;group={$group_id}&amp;bounce=1"><img src="{$site_path}/images/icon_delete.jpg" alt="" /></a>
{/if}
<a href="{$users[u].url}">{$users[u].user_name}</a> 
    ({$users[u].user_firstname} {$users[u].user_lastname})</li>
{sectionelse}
<li>No members yet</li>
{/section}
</ul>
<ul>
<li><big>Group Owner</big></li>
<li><a href="{$user.url}">{$user.user_name}</a></li>
</ul>
</div>

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>