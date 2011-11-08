<div id="header">
 <div id="welcome">
 {if $cuser.id}
  Signed on as: <a href="{$site_path}/user.php">{$cuser.user_name}</a> /
  <a href="{$site_path}/login.php">Sign off</a>
 {else}
  <a href="{$site_path}/register.php">Register</a> /
  <a href="{$site_path}/login.php">Sign on</a>
 {/if}
 / <a href="{textlink name="help"}">Help</a>
 </div>
{if $head_type eq "folder"}
    <div id="sitename"><a href="{$site_url}">{$site_name}</a></div>
    <h1><a href="{$url}">{$folder_title}</a></h1>
{elseif $head_type eq "page"}
    <div id="sitename"><a href="{$site_url}">{$site_name}</a></div>
    <h1><a href="{$folder.url}">{$folder.folder_title}</a></h1>
{elseif $site_logo ne ""}
    <h1><a href="{$site_url}"><img src="{$site_logo}" alt="{$site_name}" /></a></h1>
{else}
    <div id="sitename">{$site_tagline}</div>
    <h1><a href="{$site_url}">{$site_name}</a></h1>
{/if}
</div>
