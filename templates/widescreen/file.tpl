{* $Id: file.tpl,v 1.5 2005/12/12 22:14:21 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template displays a File object
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=0}
</head>
<body>
<div id="content">
{include file="header.tpl"}

<h1>{lang name="class_File"}: {$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{if $file_mime_type eq "image"}
<div class="bigimage">
<a href="javascript:popup('{$site_path}/file.php?id={$file_id}&amp;template=imagepopup','image','height={$image_y},width={$image_x}');"  title="Click to view full-sized" ><img src="{thumbnail file=$file_path type=$file_type maxw=500}" alt="{$file_name}" height="{$im_h}" width="{$im_w}" /></a>
<p>{$file_caption}</p>
</div>{* class="bigimage" *}
{else}
<big>[<a href="{$site_path}/{$file_path}" onclick="javascript:document.location='{$site_path}/download.php?id={$file_id}';return false;">Click here to download</a>]</big>
{/if}
</div>{* id="main" *}

<div id="menu">
<p>
{if $file_mime_type eq "image"}
    {if $exif_Model ne ""}{$exif_Model}<br />{/if}
    {if $exif_ExposureTime}
        {$exif_ExposureTime}" 
        {if $exif_FNumber}@f{$exif_FNumber/10|string_format:"%.1f"}{/if}<br />
    {/if}
{/if}
MIME Type "{$file_type}"<br />
Size {$file_size|number_format} bytes<br/>
{if $num_downloads}Downloaded {$num_downloads} times<br/>{/if}
</p>

<p>Pages that reference this file:<br />
{file_pages file=$id}
&bull;&nbsp;<a href="{$page.url}">{$page.page_title}</a><br />
{/file_pages}</p>

{if $file_copyright ne ""}
    <p>{$file_copyright}</p>
{else}
    <p>&copy;{$file_created|date_format:"%Y"},
    {$user.user_firstname} {$user.user_lastname}.</p>
{/if}
</div>

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>
