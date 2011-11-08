{* $Id: tags.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays all the pages that match a given tag
*}
{include file="top.tpl"}

{if $tag_sort ne "count"}
    {menu name="action" link="$site_path/tags.php?f=1" text="View in frequency order"}
{else}
    {menu name="action" link="$site_path/tags.php" text="View in alphabetic order"}
{/if}

{menu name="action" text="RSS Feed" link="$rss_url"}

<div id="mightylinks">
<p><strong>Tags</strong> are user-defined keywords or categories. This page shows all
the tags that are defined for this website; the size of the tag indicates its 
relative frequency.</p>
</div>{* id="menu" *}

<div class="text">
<h1>{$page_title|default:"No Title"}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<p>&nbsp;</p>

<div id="tags">
<p>
{tags num=200 sort=$tag_sort}
<span style="font-size:{math format="%d" equation="$percent*16+11"}px;"><a href="{$tag.url}">{$tag.tag_name}</a></span>
{/tags}</p>
</div>
</div>{* class="text" *}

{include file="bottom.tpl"}