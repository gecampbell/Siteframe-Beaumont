{* $Id: blog_item.tpl,v 1.15 2005/12/10 04:23:33 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
<div class="blog_item">

{if $page.num_images}
<div class="blog_images">
{section name=i loop=$page.associated_files}
{if $page.associated_files[i].file_mime_type eq "image"}
<a href="{$page.url}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type size=100}" alt="" class="blog_image" /></a>
{/if}
{/section}
</div>
{/if}

<h1><a href="{$page.url}">{$page.page_title}</a></h1>
<p>{$page.page_text|strip_tags|truncate:300}
<small>[<a href="{$page.url}">More</a>]</small></p>
<p class="info">
Posted by <a href="{$page.user.url}">{$page.user.user_name}</a>
in <a href="{$page.folder.url}">{$page.folder.folder_title}</a>
{$page.page_created|ydate:"on $date_format at $time_format"}
(<a href="{$page.url}">{numcomments class=Page id=$page.page_id} comments</a>)
</p>
</div>