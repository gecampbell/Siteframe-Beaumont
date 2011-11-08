{* $Id: images.tpl,v 1.3 2005/03/13 00:33:45 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}
</div><!-- class="content" -->

<div class="images">
    {section name=im loop=$user_images}
    <div class="image">
        <a href="{$user_images[im].url}"><img src="{thumbnail file=$user_images[im].file_path size=120 type=$user_images[im].file_type}" /></a>
    </div>
    {/section}
</div>

{include file="paginator.tpl" curpage=$page numpages=$num_pages}

{include file="footer.tpl"}