{* $Id: blog_item.tpl,v 1.15 2005/11/18 05:06:21 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
<p class="blog_item">
{if $page.num_images}
<div class="blog_images">
{section name=i loop=$page.associated_files max=1}
{if $page.associated_files[i].file_mime_type eq "image"}
<a href="{$page.url}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type maxw=100 center=0}" alt="" class="blog_image" /></a>
{/if}
{/section}
</div>
{/if}
<big><a href="{$page.url}">{$page.page_title}</a></big>
{$page.page_text|strip_tags|truncate:300}
<small><a href="{$page.url}">More</a></small>
<span class="info">
/ <a href="{$page.user.url}">{$page.user.user_name}</a>
/ <a href="{$page.folder.url}">{$page.folder.folder_title}</a>
/ {$page.page_created|ydate:"on $date_format at $time_format"}
</span>
</p>
