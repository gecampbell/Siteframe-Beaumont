<div id="menu">
{if $unread_msgs}
<p style="text-align:center;color:red;">
You have {$unread_msgs} unread memo{if $unread_msgs>1}s{/if}.<br />
[<a href="{$site_path}/memos.php">Click here to read {if $unread_msgs>1}them{else}it{/if}</a>]
</p>
{/if}
{include file="minisearch.tpl"}
{if !$cuser.id}
<ul>
<li><big>Get started!</big></li>
<li><a href="{$site_path}/register.php">Register<span> create an account</span></a></li>
<li><a href="{$site_path}/login.php">Sign On<span> authenticate</span></a></li>
</ul>
{/if}
<ul>
<li><big>Join in!</big></li>
<li><a href="{$site_path}/edit.php?c=Folder">New Folder<span> build your site</span></a></li>
<li><a href="{$site_path}/edit.php?c=Page">New Page<span> write an entry</span></a></li>
<li><a href="{$site_path}/edit.php?c=Group">New Group<span> get together</span></a></li>
<li><a href="{$site_path}/edit.php?c=Invitation">Invite<span> spread the word</span></a></li>
<li><a href="{$site_path}/memos.php">My Memos<span> online messages</span></a></li>
<li><a href="{$site_path}/subscriptions.php">My Subscriptions<span> notifications</span></a></li>
<li><a href="{$site_path}/favorites.php?id={$cuser.id}">My Favorites<span> favorite people</span></a></li>
</ul>
<ul>
<li><big>Things to do</big></li>
<li><a href="{$site_path}/search.php">Search<span> find something</span></a></li>
<li><a href="{$site_path}/tags.php">Tags<span> keyword list</span></a></li>
<li><a href="{$site_path}/users.php">Users<span> who's who?</span></a></li>
<li><a href="{$site_path}/groups.php">Groups<span> member groups</span></a></li>
<li><a href="{$site_path}/folders.php">Folders<span> user sites</span></a></li>
<li><a href="{$site_path}/feeds.php">RSS<span> syndicated content</span></a></li>
<li><a href="{$site_path}/quotes.php">Quotes<span> something memorable</span></a></li>
<li><a href="{$site_path}/templates.php">Templates<span> look & feel</span></a></li>
<li><a href="{textlink name=about}">About<span> learn something</span></a></li>
<li><a href="{textlink name=credits}">Credits<span> who done it?</span></a></li>
{if $cuser.user_admin}
<li><a href="{$site_path}/admin.php">Administrator</a></li>
{/if}
</ul>

<ul>
<li><big>New Folders</big></li>
{recent class="Folder" num=10}
<li><a href="{$folder.url}">{$folder.folder_title}</a></li>
{/recent}
</ul>

<ul>
<li><big>New Users</big></li>
{recent class="User" num=5}
<li><a href="{$user.url}">{$user.user_name}</a></li>
{/recent}
</ul>

<ul>
<li><big>Archives</big></li>
{archives}
<li><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}">{$archive_date|date_format:"%B, %Y"}</a></li>
{/archives}
</ul>

<ul>
{if $rss_enable}
<li><a href="{$site_rss_url}" title="RSS2.0 feed"><img src="{$site_path}/{$dir_images}/feed-icon16x16.png" alt="" />&nbsp;RSS 2.0</a></li>
<li><a href="http://www.feedvalidator.org/check.cgi?url={$site_rss_url}"><img src="{$site_path}/images/valid-rss.png" alt="[Valid RSS]" title="Validate my RSS feed" /></a></li>
<li><a href="http://add.my.yahoo.com/content?url={$site_url|escape:"url"}/{$site_rss_url|escape:"url"}"><img src="http://us.i1.yimg.com/us.yimg.com/i/us/my/addtomyyahoo4.gif" width="91" height="17" border="0" align=middle alt="Add to My Yahoo!"></a></li>
{/if}
</ul>
<ul>
<li><small>{page_views days=7} page views in the last week.</small></li>
</ul>
</div><!-- class="menu" -->
