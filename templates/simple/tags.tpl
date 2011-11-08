{* $Id: tags.tpl,v 1.14 2005/11/18 03:15:50 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays all the pages that match a given tag
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

{menu name="action" text="RSS Feed" link="$rss_url"}

{if $tag_sort ne "count"}
    {menu name="action" link="$site_path/tags.php?f=1" text="View in frequency order"}
{else}
    {menu name="action" link="$site_path/tags.php" text="View in alphabetic order"}
{/if}

<h1>{$page_title|default:"No Title"}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div class="taglist">
<p>
{tags num=200 sort=$tag_sort}
{assign var=size value="`$percent*23+9`"}
<span style="font-size:{$size}px;"><a href="{$tag.url}">{$tag.tag_name}</a></span>
{/tags}</p>
</div>

<p><em>Tags</em> are user-defined keywords or categories. This page shows all
the tags that are defined for this website; the size of the tag indicates its 
relative frequency.
</p>

</div><!-- class="content" -->

{include file="footer.tpl"}
