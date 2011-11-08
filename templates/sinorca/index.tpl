{* $Id: index.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $
** index.tpl for "leaves" theme
*}
{include file="header.tpl"}

<div id="right-column">
{include file="searchbox.tpl"}
<h3>Menu</h3>
<ul>
  <li><a href="{$site_path}/edit.php?c=Folder">New Folder</a></li>
  <li><a href="{$site_path}/edit.php?c=Page">New Page</a></li>
  <li><a href="{$site_path}/edit.php?c=Group">New Group</a></li>
  <li><a href="{$site_path}/users.php">Users</a></li>
  <li><a href="{$site_path}/tags.php">Tags</a></li>
</ul>

<h3>New Folders</h3>
<ul>
{recent class="Folder" num=10}
<li><a href="{$folder.url}">{$folder.title}</a></li>
{/recent}
</ul>

<h3>New Users</h3>
<ul>
{recent class="User" num=5}
<li><a href="{$user.url}">{$user.title}</a></li>
{/recent}
</ul>

<h3>New Groups</h3>
<ul>
{recent class="Group" num=5}
<li><a href="{$group.url}">{$group.title}</a></li>
{/recent}
</ul>

<h3>Archives</h3>
<ul>
{archives}
<li><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}">{$archive_date|date_format:"%B, %Y"}</a></li>
{/archives}
</ul>

<p><a href="{$site_rss_url}" title="RSS 2.0 feed"><img src="{$site_path}/{$dir_images}/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="right-column" *}

<div id="main-copy">
<div id="hello">
{text name="home_page" default="<p>Welcome to $site_name</p>"}
</div>
{section name=item loop=$items}
{include file=$item_template page=$items[item]}
{/section}
</div>{* id="main-copy" *}

{include file="footer.tpl"}