{* $Id: folder_gallery.tpl,v 1.2 2005/11/22 22:33:30 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
{assign var=page value=$items[item]}
<div class="blog_item">

{if $page.num_images}
{section name=i loop=$page.associated_files}
{if $page.associated_files[i].file_mime_type eq "image"}
<div class="gallery_image">
<a href="{$page.url}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type size=160 }" alt="" /></a>
</div>
{/if}
{/section}
{/if}

<h1>{$page.page_title}</h1>
{if $page.page_length>400}
<p>{$page.page_text|strip_tags|truncate:300}
<small>[<a href="{$page.url}">More</a>]</small></p>
{else}
{$page.page_text}
{/if}

<p class="info">
Posted by <a href="{$page.user.url}">{$page.user.user_name}</a>
in <a href="{$page.folder.url}">{$page.folder.folder_title}</a>
{$page.page_created|ydate:"on $date_format at $time_format"}
(<a href="{$page.url}">{numcomments class=Page id=$page.page_id} comments</a>)
</p>
<br style="clear:left;" />
</div>