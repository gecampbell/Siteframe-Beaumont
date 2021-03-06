{* $Id: tags.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}
{if $tag_sort ne "count"}
    {menu name="action" link="$site_path/tags.php?f=1" text="View in frequency order"}
{else}
    {menu name="action" link="$site_path/tags.php" text="View in alphabetic order"}
{/if}

<div id="right-column">
{include file="searchbox.tpl"}
<p><strong>Tags</strong> are user-defined keywords or categories. This page shows all
the tags that are defined for this website; the size of the tag indicates its 
relative frequency.</p>
<p><a href="{$rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div id="tags">
<p>
{tags num=200 sort=$tag_sort}
<span style="font-size:{math format="%d" equation="$percent*20+11"}px;"><a href="{$tag.url}">{$tag.tag_name}</a></span>
{/tags}</p>
</div>{* id="tags" *}
</div>{* id="main-copy" *}

{include file="footer.tpl"}