{* $Id: blog_item.tpl,v 1.5 2005/11/22 22:33:30 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
<p class="blog_item">
{if $page.num_images}
    <div class="blog_images">
    {section name=i loop=$page.associated_files max=1}
    {if $page.associated_files[i].file_mime_type eq "image"}
    <a href="{$page.url}" title="This page has image attachment(s)"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type maxw=200}" alt="" class="blog_image" /></a>
    {/if}
    {/section}
    </div>
{elseif $page.num_attachments}
    <div class="blog_images">
    <a href="{$page.url}" title="This page has file attachment(s)"><img src="{$site_path}/images/icon_file.jpg" alt=""/></a>
    </div>
{/if}
<big><a href="{$page.url}">{$page.page_title}</a></big>
{$page.page_text|strip_tags|truncate:300}
<br /><span class="info">
<a href="{$page.url}">{numcomments class=Page id=$page.page_id} comment(s)</a>
: <a href="{$page.user.url}">{$page.user.user_name}</a>
: <a href="{$page.folder.url}">{$page.folder.folder_title}</a>
: {$page.page_created|ydate:"on $date_format at $time_format"}
</span>
</p>
