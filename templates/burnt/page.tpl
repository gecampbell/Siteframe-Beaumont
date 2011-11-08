{* $Id: page.tpl,v 1.2 2005/11/24 19:17:39 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl" subtitle=$page.folder.title}

<div id="mightylinks"> 
<p class="info">by <a href="{$user.url}">{$user.user_name}</a>
({$user.user_firstname} {$user.user_lastname})<br />
in <a href="{$folder.url}">{$folder.folder_title}</a>
</p>
<p>&nbsp;</p>
{page_next page=$page_id folder=$page_folder_id}
<p>Next: <a href="{$page.url}">{$page.page_title}</a></p>
{/page_next}
{page_prev page=$page_id folder=$page_folder_id}
<p>Prev: <a href="{$page.url}">{$page.page_title}</a></p>
{/page_prev}
<p>&nbsp;</p>

{if $allow_ratings}
{include file="../rating.tpl" rating_class="Page"}
<p>&nbsp;</p>
{/if}

<p><strong>Tags</strong></p>
{section name=i loop=$tags}
<p><a href="{$tags[i].url}" rel="tag">{$tags[i].tag_name}</a></p>
{/section}
<p>[<a href="{$site_path}/tags.php">all tags</a>]</p>
<p>&nbsp;</p>

{include file="addtag.tpl" page_id=$page_id}
</div>

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<h2><strong>{$page_created|ydate:"$date_format $time_format"}</strong></h2>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{* handle file attachments *}
{if $num_images eq 1 && $num_attachments eq 1}
    <div class="bigimage">
    {section name=i loop=$associated_files}
    {if $associated_files[i].file_mime_type eq "image"}
    <a href="javascript:popup('{$site_path}/file.php?id={$associated_files[i].file_id}&amp;template=imagepopup','image','height={$associated_files[i].image_y},width={$associated_files[i].image_x}');"  title="Click to view full-sized" ><img src="{thumbnail file=`$associated_files[i].file_path` type=`$associated_files[i].file_type` maxw=400}" alt="{$file_name}" height="{$im_h}" width="{$im_w}" /></a><br />
    {$associated_files[i].file_caption}
    (<a href="{$associated_files[i].url}">more info</a>)
    {/if}
    {/section}
    </div>
{elseif $num_attachments gt 0}
    <div class="attachments">
    {section name=i loop=$associated_files}
    <div class="file">
    <div class="icon">
    {if $associated_files[i].file_mime_type eq "image"}
    <a href="{$associated_files[i].url}"><img src="{thumbnail file=$associated_files[i].file_path type=$associated_files[i].file_type size=72}" alt="{$associated_files[i].file_name}" height="{$im_h}" width="{$im_w}" /></a>
    {elseif $associated_files[i].file_mime_type eq "audio"}
    <a href="{$associated_files[i].url}"><img src="{$site_path}/images/audio.jpg" alt="audio file" /></a>
    {else}
    <a href="{$associated_files[i].url}"><img src="{$site_path}/images/icon_file.jpg" alt="file attachment" /></a>
    {/if}
    </div>{* class="icon" *}
    {$associated_files[i].file_caption|default:$associated_files[i].file_original_name}
    </div>{* class="file" *}
    {/section}
    <br style="clear:left;"/>
    </div>{* class="attachments" *}
{/if}

{$page_text}

{include file="comments.tpl"}

</div>{* class="text" *}

{include file="bottom.tpl"}