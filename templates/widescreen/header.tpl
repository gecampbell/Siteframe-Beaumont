{* $Id: header.tpl,v 1.5 2005/11/22 22:33:30 glen Exp $
** Page header
*}
<div id="header">
{if $head_type eq "folder"}
    <div id="sitename">{$site_name} - {$site_tagline}</div>
    <h1><a href="{$url}">{$folder_title}</a></h1>
{elseif $head_type eq "page"}
    <div id="sitename">{$site_name} - {$site_tagline}</div>
    <h1><a href="{$folder.url}">{$folder.folder_title}</a></h1>
{elseif $site_logo ne ""}
    <h1><a href="{$site_url}"><img src="{$site_logo}" alt="{$site_name}" /></a></h1>
{else}
    <div id="sitename">{$site_tagline}</div>
    <h1><a href="{$site_url}">{$site_name}</a></h1>
{/if}
</div>
 <div id="welcome">
 {include file="breadcrumb.tpl"}
 {if $cuser.id}
  Signed on as: <a href="{$site_path}/user.php">{$cuser.user_name}</a> :
  <a href="{$site_path}/login.php">Sign off</a>
 {else}
  <a href="{$site_path}/register.php">Register</a> :
  <a href="{$site_path}/login.php">Sign on</a>
 {/if}
 : <a href="{textlink name="help"}">Help</a>
 </div>
<div id="wrapper">{* this is closed in footer.tpl *}