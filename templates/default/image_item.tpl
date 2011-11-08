{* $Id: image_item.tpl,v 1.1 2005/12/03 14:16:58 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
<p class="image_item">
{if $page.num_images}
    {section name=i loop=$page.associated_files max=1}
    {if $page.associated_files[i].file_mime_type eq "image"}
    <a href="{$page.url}" title="{$page.title}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type size=100 center=TRUE}" alt="" class="blog_image" /></a>
    {/if}
    {/section}
{elseif $page.num_attachments}
    <a href="{$page.url}" title="This page has file attachment(s)"><img src="{$site_path}/images/icon_file.jpg" alt=""/></a>
    <br />
    <a href="{$page.url}">{$page.page_title}</a>
{else}
    <a href="{$page.url}">{$page.page_title}</a>
{/if}
</p>
