{include file="header.tpl"}
{include file="../favorite.tpl"}

{* user action menu *}
{if $cuser.id}
{menu name="action" link="$site_path/mail.php?to=`$user.user_id`" text="Send E-mail"}
{menu name="action" link="$site_path/edit.php?c=Memo&amp;memo_to_user_id=`$user.user_id`" 
      text="Send Memo"}
{/if}
{* visitor view user menu *}
{menu name="user" link="$site_path/favorites.php?id=`$user.user_id`"
      text="Favorites"}
{menu name="user" link="$site_path/links.php?u=`$user.user_name`" text="Links"}
{if $cuser.id eq $user.id}
{menu name="user" link="$site_path/subscriptions.php?user=`$user.user_id`"
      text="Subscriptions"}
{menu name="user" link="$site_path/pwchange.php" text="Change My Password"}
{menu name="user" link="$site_path/pwreset.php" text="Reset My Password"}
{/if}

<div id="sidebar">
{if $user.user_photo ne ""}
<img src="{thumbnail file=$user.user_photo type=$user.user_photo_type maxw=100}" alt="{$user.user_name}" style="margin-bottom:1em;"/>
{/if}
<h3>Folders</h3>
<ul>
{section name=i loop=$user_folders}
<li><a href="{$user_folders[i].url}">{$user_folders[i].folder_title}</a></il>
{/section}
</ul>
<h3>Menu</h3>
<ul><li>{menu name="user" sep="</li>
<li>"}</li></ul>
<p>Last login: {$user.last_login|ydate:"$date_format $time_format"}
<br />
<a href="{$user.rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</p>
</div>{* id="sidebar" *}

<div id="content">
<h1>{if $is_favorite}<img src="{$site_path}/images/biggoldstar.jpg" alt="Favorite" style="float:right;"/>{/if}{$page_title}</h1>
{$user.user_info|default:"<p>No user info provided</p>"}
{if $cuser.id == $user.id}
<p>&raquo;&nbsp;<a href="javascript:toggle('uinfo');">Private Information</a></p>
<div id="uinfo" style="display:none; background:white;">
<p>Your API key is: {$user.user_hash}</p></div>
{/if}
{recent class="Page" user=$user.user_id num=10}
{include file="excerpt.tpl" page=$page}
{/recent}
</div>{* id="content" *}

{assign var=_editor value=$user._owner}
{assign var=edit_url value=$user.edit_url}
{assign var=delete_url value=$user.delete_url}
{include file="footer.tpl"}