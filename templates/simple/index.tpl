{* $Id: index.tpl,v 1.69 2005/12/19 06:01:40 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
**
** This template is used to generate the overall home page for the entire
** site (not just a weblog or photo album).
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<div class="content">

<div class="main">
    <div class="hello" style="clear:left;">
    {text name="home_page" default="<p>Welcome to $site_name</p>"}
    </div>
    <div class="items">
    {section name=item loop=$items}
    {include file=$item_template page=$items[item]}
    {/section}
    </div><!-- class="items" -->
</div><!-- class="main" -->
    
<div class="pagemenu">

{if $unread_msgs}
<p style="text-align:center;color:red;">
You have {$unread_msgs} unread memo{if $unread_msgs>1}s{/if}.<br />
[<a href="{$site_path}/memos.php">Click here to read {if $unread_msgs>1}them{else}it{/if}</a>]
</p>
{/if}

{calendar}

<div class="heading">
Getting Started
</div>
<p>
{if $cuser.id}
<a href="{$site_path}/login.php">Sign Off</a><br />
{else}
<a href="{$site_path}/register.php">Register</a> create an account<br />
<a href="{$site_path}/login.php">Sign On</a> authenticate<br />
{/if}
<a href="{$site_path}/edit.php?c=Folder">New Blog</a> build your site<br />
<a href="{$site_path}/edit.php?c=Page">New Page</a> write an entry<br />
<a href="{$site_path}/edit.php?c=Invitation">Invite</a> spread the word<br />
{if $cuser.id}
<a href="{$site_path}/memos.php">My Memos</a> online messages<br />
<a href="{$site_path}/subscriptions.php">My Subscriptions</a> notifications<br />
<a href="{$site_path}/favorites.php?id={$cuser.id}">My Favorites</a> favorite people<br />
{/if}
</p>

<div class="heading">Popular Tags</div>
<p>
{tags num=20}
{assign var=size value="`$percent*16+9`"}
<span style="font-size:{$size}px;"><a href="{$tag.url}">{$tag.tag_name}</a></span>
{/tags}
</p>

<div class="heading">New Folders</div>
<p>
{recent class="Folder" num=5}
<a href="{$folder.url}">{$folder.folder_title}</a><br />
{/recent}
</p>

<div class="heading">New Members</div>
<p>
{recent class="User" num=5}
<a href="{$user.url}">{$user.user_name}</a> {$user.user_firstname} {$user.user_lastname}<br />
{/recent}
</p>

<div class="heading">New Links</div>
<p>
{recent class="Link" num=5}
<a href="{$site_path}/link.php?id={$obj.id}">{$obj.link_text}</a><br />
{/recent}
</p>

<div class="heading">Archives</div>
<p>
{archives}
<a href="{$site_path}/archive.php?y={$year}&amp;m={$month}">{$archive_date|date_format:"%B, %Y"}</a><br />
{/archives}

<div class="heading">What's Going On?</div>
<p>
<a href="{$site_path}/search.php">Search</a><br />
<a href="{$site_path}/tags.php">Tags</a><br />
<a href="{$site_path}/users.php">List Users</a><br />
<a href="{$site_path}/groups.php">List Groups</a><br />
<a href="{$site_path}/folders.php">List Folders</a><br />
<a href="{$site_path}/feeds.php">List RSS Feeds</a><br />
<a href="{$site_path}/quotes.php">List Quotations</a><br />
<a href="{$site_path}/templates.php">List Templates</a><br />
<a href="{textlink name=about}">About Beaumont</a><br />
<a href="{textlink name=credits}">Credits</a><br />
{if $cuser.user_admin}
<a href="{$site_path}/admin.php">Administrator</a><br />
{/if}
</p>
{if $rss_enable}
<a href="{$site_rss_url}" title="RSS2.0 feed"><img src="{$site_path}/{$dir_images}/feed-icon16x16.png" alt="" />&nbsp;RSS 2.0</a><br />
<a href="http://add.my.yahoo.com/content?url={$site_url|escape:"url"}/{$site_rss_url|escape:"url"}"><img src="http://us.i1.yimg.com/us.yimg.com/i/us/my/addtomyyahoo4.gif" width="91" height="17" border="0" align=middle alt="Add to My Yahoo!"></a> <br/>
{/if}
<a href="http://siteframe.org" title="Powered by Siteframe"><img src="{$site_path}/{$dir_images}/siteframepower.gif" alt="Powered by Siteframe" style="margin-top:5px;"/></a>
<p>There have been {page_views days=1} page views in the last day.</p>
</div><!-- class="right" -->

</div><!-- class="content" -->

{include file="footer.tpl"}
