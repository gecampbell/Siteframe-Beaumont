{* $Id: folder.tpl,v 1.27 2005/12/12 22:14:21 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** this displays a folder
*}
{include file="preamble.tpl"}
{include file="html_head.tpl" head_type="folder"}

{menu name="action" link="$rss_url" text="RSS 2.0"}
{menu name="action"
     link="$site_path/edit.php?c=Subscription&amp;sub_folder_id=$folder_id"
     text="Subscribe"}
{if $use_subfolders}
    {menu name="action"
          link="$site_path/edit.php?c=Folder&amp;folder_parent_id=$folder_id"
          text="New Subfolder"}
{/if}

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}

<div class="content">

<div class="main">
{include file="breadcrumb.tpl"}
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div class="folder_info">
{$folder_text|default:"No folder info provided"}
</div>{* class="folder_info" *}
<div class="items">
{section name=item loop=$items}
{include file="blog_item.tpl" page=$items[item]}
{/section}
</div>{* class="items" *}
</div>{* class="main" *}

<div class="pagemenu">
{calendar year=$year month=$month folder=$folder_id}
{include file="file:../subfolders.tpl"}
<div class="heading">Blogroll</div>
<p>
{random class="Link" num=10 user=$folder_user_id}
<a href="{$site_path}/link.php?id={$link.id}">{$link.link_text}</a><br />
{/random}
{if $cuser.id == $folder_user_id}
  <small>[<a href="{$site_path}/edit.php?c=Link">Add New Link</a>]</small>
{/if}
</p>
<div class="heading">Folder Archives</div>
<p>
{archives folder=$folder_id}
<a href="{$site_path}/archive.php?y={$year}&amp;m={$month}&amp;f={$folder_id}">{$archive_date|date_format:"%B, %Y"}</a><br />
{/archives}
<div class="heading">Folder Owner</div>
<p><a href="{$user.url}">{$user.user_name}</a></p>
</div>{* class="pagemenu" *}

</div>{* class="content" *}

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
{include file="footer.tpl"}
