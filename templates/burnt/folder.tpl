{* $Id: folder.tpl,v 1.6 2005/12/12 22:14:20 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** this displays a folder
*}
{include file="top.tpl"}

{menu name="action" link="$rss_url" text="RSS 2.0"}
{menu name="action" link="$site_path/edit.php?c=Subscription&amp;sub_folder_id=$folder_id" text="Subscribe"}
{if $folder_allow_subfolders && $use_subfolders}
    {menu name="action"
          link="$site_path/edit.php?c=Folder&amp;folder_parent_id=$folder_id"
          text="New Subfolder"}
{/if}

<div id="mightylinks">
<p><strong>Folder Info</strong></p>
<p>owner: <a href="{$user.url}">{$user.user_name}</a></p>
<p>&nbsp;</p>

{if $folder_allow_subfolders && $use_subfolders}
<ul>
<li><big>Subfolders</big></li>
{all class="Folder" parent=$folder_id}
<li><a href="{$folder.url}">{$folder.folder_title}</a></li>
{/all}
</ul>
{/if}

{calendar year=$year month=$month folder=$folder_id}
<p>&nbsp;</p>

<p><strong>Folder Archives</strong></p>
<p>
{archives folder=$folder_id}
<a href="{$site_path}/archive.php?y={$year}&amp;m={$month}&amp;f={$folder_id}">{$archive_date|date_format:"%B %Y"}</a><br />
{/archives}
</p>

</div>{* id="mightylinks" *}


<div class="text">
<h1><strong>{$folder_title}</strong></h1>
<p>{$folder_text|default:"No folder info provided"}</p>
<p>&nbsp;</p>

{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=item loop=$items}
{include file="blog_item.tpl" page=$items[item]}
{/section}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
</div>{* class="text" *}


{include file="bottom.tpl"}
