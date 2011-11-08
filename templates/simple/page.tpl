{* $Id: page.tpl,v 1.67 2005/12/12 22:14:21 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl" head_type="page" rte_enable=0}

{include file="breadcrumb.tpl" folder_id=$page_folder_id breadcrumb_final=$page_title}

<h1>{$page_title}</h1>

<div class="content">

{if $error ne ""}<p class="error">{$error}</p>{/if}

<p class="author">by <a href="{$user.url}">{$user.user_name}</a>
({$user.user_firstname} {$user.user_lastname})
</p>
<p class="dateline">{$page_created|ydate:"$date_format $time_format"}</a></p>

{* handle file attachments *}
{if $num_images eq 1}
    <div class="bigimage">
    {section name=i loop=$associated_files}
    {if $associated_files[i].file_mime_type eq "image"}
    <a href="javascript:popup('{$site_path}/file.php?id={$associated_files[i].file_id}&amp;template=imagepopup','image','height={$associated_files[i].image_y},width={$associated_files[i].image_x}');"  title="Click to view full-sized" ><img src="{thumbnail file=`$associated_files[i].file_path` type=`$associated_files[i].file_type` maxw=500}" alt="{$file_name}" height="{$im_h}" width="{$im_w}" /></a><br />
    {$associated_files[i].file_caption}
    (<a href="{$associated_files[i].url}">more info</a>)
    {/if}
    {/section}
    </div>
{elseif $num_attachments gt 1}
    <div class="imagelist">
    {section name=i loop=$associated_files}
    {if $associated_files[i].file_mime_type eq "image"}
    <div class="image">
    <a href="{$associated_files[i].url}"><img src="{thumbnail file=$associated_files[i].file_path type=$associated_files[i].file_type size=300}" alt="{$associated_files[i].file_name}" height="{$im_h}" width="{$im_w}" /></a>
    </div><!-- class="image" -->
    {/if}
    {/section}
    </div><!-- class="imagelist" -->
{/if}

{$page_text}

{include file="../attachments.tpl"}

<div class="pageinfo">
{if $allow_ratings}
{include file="../rating.tpl" rating_class="Page"}
<br />
{/if}
Tags: 
{section name=i loop=$tags}
<a href="{$tags[i].url}" rel="tag">{$tags[i].tag_name}</a>,
{/section}
<a href="{$site_path}/tags.php"><em>all tags</em></a>.
{include file="addtag.tpl" page_id=$page_id}
{page_next page=$page_id folder=$page_folder_id}
<br />Next entry: <a href="{$page.url}">{$page.page_title}</a>
{/page_next}
{page_prev page=$page_id folder=$page_folder_id}
<br />Previous entry: <a href="{$page.url}">{$page.page_title}</a>
{/page_prev}
</div><!-- class="pageinfo" -->

</div><!-- class="content" -->

{include file="comments.tpl"}
{if $_editor}
    {menu name="action" link="$site_path/xml.php?c=Page&amp;id=$id" text="Export"}
{/if}
{include file="footer.tpl"}
