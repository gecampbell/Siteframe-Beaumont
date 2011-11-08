{* $Id: blog_item.tpl,v 1.7 2005/11/28 01:08:34 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
{if $page.num_attachments}
<div class="blog_images">
{section name=i loop=$page.associated_files max=1}
{if $page.associated_files[i].is_image}
<a href="{$page.url}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type maxw=100 center=0}" alt="" class="blog_image" /></a>
{else}
<a href="{$page.url}"><img src="{$site_path}/images/icon_file.jpg" alt="" class="blog_image" /></a>
{/if}
{/section}
</div>
{/if}
<p class="blog_item"><big><a href="{$page.url}">{$page.page_title}</a></big>
{$page.page_text|strip_tags|truncate:400}<br />
<span class="info">
<a href="{$page.url}">{numcomments class=Page id=$page.page_id} comment(s)</a>
/ <a href="{$page.user.url}">{$page.user.user_name}</a>
/ <a href="{$page.folder.url}">{$page.folder.folder_title}</a>
/ {$page.page_created|ydate:"on $date_format at $time_format"}
</span>
</p>
