{* $Id: tags.tpl,v 1.4 2006/01/01 21:46:36 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays all the pages that match a given tag
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=1}
</head>
<body>
<div id="content">
{include file="header.tpl"}

{if $tag_sort ne "count"}
    {menu name="action" link="$site_path/tags.php?f=1" text="View in frequency order"}
{else}
    {menu name="action" link="$site_path/tags.php" text="View in alphabetic order"}
{/if}

{menu name="action" text="RSS Feed" link="$rss_url"}

<h1>{$page_title|default:"No Title"}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
<p>Last week:
{tags num=50 days=7 sort=count}{if $tag._row_ gt 1}, {/if}
 <a href="{$tag.url}">{$tag.tag_name}</a>{/tags}
</p>
<p>Last month:
{tags num=50 days=31 sort=count}{if $tag._row_ gt 1}, {/if}
 <a href="{$tag.url}">{$tag.tag_name}</a>{/tags}
</p>
<div id="tags">
<p>
{tags num=200 sort=$tag_sort}
<span style="font-size:{math format="%d" equation="$percent*20+13"}px;"><a href="{$tag.url}">{$tag.tag_name}</a></span>
{/tags}</p>
</div>{* id="tags" *}
</div>{* id="main" *}

<div id="menu">
<strong>Tags</strong> are user-defined keywords or categories. This page shows all
the tags that are defined for this website; the size of the tag indicates its 
relative frequency.
</div>{* id="menu" *}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>


