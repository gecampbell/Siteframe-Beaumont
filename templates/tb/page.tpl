{* $Id: page.tpl,v 1.18 2005/12/12 22:14:21 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=0}
</head>
<body>
<div id="content">
{include file="header.tpl" head_type="page"}
{include file="breadcrumb.tpl"}

<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{* handle file attachments *}
{if $num_images eq 1}
    <div class="bigimage">
    {section name=i loop=$associated_files}
    {if $associated_files[i].file_mime_type eq "image"}
    <a href="javascript:popup('{$site_path}/file.php?id={$associated_files[i].file_id}&amp;template=imagepopup','image','height={$associated_files[i].image_y},width={$associated_files[i].image_x}');"  title="Click to view full-sized" ><img src="{thumbnail file=`$associated_files[i].file_path` type=`$associated_files[i].file_type` maxw=320}" alt="{$file_name}" height="{$im_h}" width="{$im_w}" /></a><br />
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
{include file="comments.tpl"}

</div>{* id="main" *}

<div id="menu">
{if $user.user_photo ne ""}
<a href="{$user.url}" title="Go to {$user.title}'s page"><img src="{thumbnail file=$user.user_photo type=$user.user_photo_type maxw=120}" alt="{$user.user_name}" style="margin-bottom:1em;"/></a>
{/if}
<p class="info">by <a href="{$user.url}">{$user.user_name}</a>
({$user.user_firstname} {$user.user_lastname})<br />
{$page_created|ydate:"$date_format $time_format"}<br />
in <a href="{$folder.url}">{$folder.folder_title}</a>
</p>

<ul>
{page_next page=$page_id folder=$page_folder_id}
<li>Next: <a href="{$page.url}">{$page.page_title}</a></li>
{/page_next}
{page_prev page=$page_id folder=$page_folder_id}
<li>Prev: <a href="{$page.url}">{$page.page_title}</a></li>
{/page_prev}
</ul>

{if $allow_ratings}
{include file="../rating.tpl" rating_class="Page"}
{/if}

<ul>
<li><big>Tags</big></li>
{section name=i loop=$tags}
<li><a href="{$tags[i].url}" rel="tag">{$tags[i].tag_name}</a></li>
{/section}
<li><small><a href="{$site_path}/tags.php">all tags</a></small></li>
</ul>

{include file="addtag.tpl" page_id=$page_id}
</div>{* id="menu" *}

{if $_editor}
    {menu name="action" link="$site_path/xml.php?c=Page&amp;id=$id" text="Export"}
{/if}
{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>