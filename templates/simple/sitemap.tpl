{* $Id: sitemap.tpl,v 1.3 2005/05/28 23:17:49 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** creates a site map
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
{section name=i loop=$folders}
    <div style="margin-left:{$folders[i].level}em">
    <strong><a href="{$folders[i].url}">{$folders[i].title}</a></strong>
    {$folders[i].folder_text|strip_tags|truncate}
    </div>
{/section}
</div>{* end class="content" *}

{include file="footer.tpl"}
