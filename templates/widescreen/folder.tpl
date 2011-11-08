{* $Id: folder.tpl,v 1.10 2005/12/31 04:18:17 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** this displays a folder
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=1}
</head>
<body>
<div id="content">
{include file="header.tpl" head_type="folder"}

{menu name="action" link="$site_path/edit.php?c=Subscription&amp;sub_folder_id=$folder_id" text="Subscribe"}
{if $folder_allow_subfolders && $use_subfolders}
    {menu name="action"
          link="$site_path/edit.php?c=Folder&amp;folder_parent_id=$folder_id"
          text="New Subfolder"}
{/if}

<div id="main">
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div id="hello">
{$folder_text|default:"No folder info provided"}
</div>{* id="folder_info" *}
<div class="items">
{section name=item loop=$items}
{*include file="blog_item.tpl" page=$items[item]*}
{include file=$item_template page=$items[item]}
{/section}
</div>{* class="items" *}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
</div>{* class="main" *}

<div id="menu">
{include file="minisearch.tpl"}

{if $folder_allow_subfolders && $use_subfolders}
<ul>
<li><big>Subfolders</big></li>
{all class="Folder" parent=$folder_id}
<li><a href="{$folder.url}">{$folder.folder_title}</a></li>
{/all}
</ul>
{/if}

{calendar year=$year month=$month folder=$folder_id}
<ul>
<ul>
<li><big>Folder Archives</big></li>
{archives folder=$folder_id}
<li><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}&amp;f={$folder_id}">{$archive_date|date_format:"%B, %Y"}</a></li>
{/archives}
</ul>
<li><big>Links</big></li>
{random class="Link" num=10 user=$folder_user_id}
<li><a href="{$site_path}/link.php?id={$link.id}">{$link.link_text}</a></li>
{/random}
{if $cuser.id == $folder_user_id}
  <li>&raquo;&nbsp;<a href="{$site_path}/edit.php?c=Link">Add New Link</a></li>
{/if}
</ul>

<ul>
<li><big>Folder Owner</big></li>
<li><a href="{$user.url}">{$user.user_name}</a></li>
</ul>

<p><a href="{$rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="menu" *}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>
