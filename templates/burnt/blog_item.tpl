{* $Id: blog_item.tpl,v 1.3 2005/11/26 18:46:19 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays a single item in blog format
*}
<p><strong>{$page.page_title}.</strong></p>
<p class="excerpt">
{section name=i loop=$page.associated_files}
{if $page.associated_files[i].file_mime_type eq "image"}
<a href="{$page.url}" title="This page has image attachment(s)"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type size=42 center=TRUE}" alt="" class="blog_image" height="{$im_h}" width="{$im_w}"/></a>
{/if}
{/section}
{$page.page_text|strip_tags|truncate:300}</p>
<p style="clear:left;"><small><a href="{$page.url}">Link</a> | <a href="{$page.user.url}" title="By {$page.user.user_firstname} {$page.user.user_lastname}">{$page.user.user_name}</a> | <a href="{$page.folder.url}" title="In folder {$page.folder.title}">{$page.folder.title}</a> | {$page.page_created|ydate:"$date_format $time_format"}</small></p>
<p>&nbsp;</p>