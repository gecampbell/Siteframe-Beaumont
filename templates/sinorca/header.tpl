{* $Id: header.tpl,v 1.3 2006/02/16 05:49:22 glen Exp $
** Page header
*}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en-AU">
  <head>
    <meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8" />
    <meta name="author" content="haran" />
    <meta name="generator" content="Siteframe Beaumont {$VERSION}({$BUILD})" />
    <meta name="copyright" content="{$site_copyright}" />
    <meta name="revisit-after" content="1 days" />
    <meta name="dc.title" content="{$site_name}" />
    <meta name="dc.creator.e-mail" content="{$site_email}" />
    <meta name="dc.format" content="multipart/mixed" />
    <meta name="dc.identifier" scheme="uri" content="{$site_url}" />
    <meta name="dc.language" scheme="rfc1766" content="{$lang_default}" />
    <meta name="dc.relation.ispartof" content="{$site_url}" />
    <script type="text/javascript" language="javascript" src="{$site_path}/javascript/siteframe.js"></script>
    {if $cuser.user_editor && ($cuser.user_editor != "none")}
      {assign var=rich_text_editor value=$cuser.user_editor}
    {/if}
    {if $cuser.user_editor && ($cuser.user_editor != "none")}
      {assign var=rich_text_editor value=$cuser.user_editor}
    {/if}
    {if $rte_enable && $rich_text_editor ne "" && $cuser.id}
    <!-- using rich_text_editor={$rich_text_editor} -->
    {include file="rte_head_$rich_text_editor.tpl"}
    {/if}
    {include file="../head_rss.tpl"}
    {include file="../trackback.tpl"}

    <!-- Navigational metadata for large websites (an accessibility feature): -->
    <link rel="top"      href="./index.html" title="Homepage" />
    <link rel="up"       href="./index.html" title="Up" />
    <link rel="first"    href="./index.html" title="First page" />
    <link rel="previous" href="./index.html" title="Previous page" />
    <link rel="next"     href="./index.html" title="Next page" />
    <link rel="last"     href="./index.html" title="Last page" />
    <link rel="toc"      href="./index.html" title="Table of contents" />
    <link rel="index"    href="./index.html" title="Site map" />

    <link rel="stylesheet" type="text/css" href="{$site_path}/{$template_dir}/sinorca-screen.css" media="screen" title="Sinorca (screen)" />
    <link rel="stylesheet alternative" type="text/css" href="{$site_path}/{$template_dir}/sinorca-screen-alt.css" media="screen" title="Sinorca (alternative)" />
    <link rel="stylesheet" type="text/css" href="{$site_path}/{$template_dir}/sinorca-print.css" media="print" />
    <link rel="stylesheet" type="text/css" href="{$site_path}/{$template_dir}/siteframe.css" />

    <title>{$page_title}</title>
  </head>

  <body>
    <!-- For non-visual user agents: -->
      <div id="top"><a href="#main-copy" class="doNotDisplay doNotPrint">Skip to main content.</a></div>

    <!-- ##### Header ##### -->

    <div id="header">
      <div class="superHeader">
        <div class="left">
          <span class="doNotDisplay">User:</span>
          {if $cuser.id}
          Hello, <a href="{$site_path}/user.php">{$cuser.user_name}</a> |
          <a href="{$site_path}/login.php">Sign Off</a>
          {else}
          <a href="{$site_path}/register.php">Create a new account</a> |
          <a href="{$site_path}/login.php">Sign On</a>
          {/if}
        </div>
        {if $cuser.id}
        <div class="right">
          <span class="doNotDisplay">My stuff:</span>
          <a href="{$site_path}/favorites.php">Favorites</a> |
          <a href="{$site_path}/subscriptions.php">Subscriptions</a> |
          <a href="{$site_path}/memos.php">Memos</a>
          {if $cuser.user_admin}
            | <a href="{$site_path}/admin.php">ADMIN</a>
          {/if}
        </div>
        {/if}
      </div>
<center style="font-size:larger; font-weight:bold;">This template set is under development and will probably change before the final release.</center>

      <div class="midHeader">
        <h1 class="headerTitle">{$site_name}</h1>
      </div>

        
      <div class="subHeader">
{include file="searchbox.tpl"}
        <span class="doNotDisplay">Navigation:</span>
        <a href="{$site_path}/">Home</a>
        {all class="Folder" parent=0}
        | <a href="{$folder.url}">{$folder.title}</a>
        {/all}
      </div>
    </div>

    <!-- ##### Side Bar ##### -->

    <div id="side-bar">
      <div>
        <p class="sideBarTitle">Create</p>
        <ul>
        <li><a href="{$site_path}/edit.php?c=Invitation">&rsaquo; Send Invitation</a></li>
        <li><a href="{$site_path}/edit.php?c=Folder">&rsaquo; New Folder</a></li>
        <li><a href="{$site_path}/edit.php?c=Page">&rsaquo; New Page</a></li>
        <li><a href="{$site_path}/edit.php?c=Group">&rsaquo; New Group</a></li>
        </ul>
      </div>
      <div>
        <p class="sideBarTitle">List</p>
        <ul>
        <li><a href="{$site_path}/folders.php">&rsaquo; Folders</a></li>
        <li><a href="{$site_path}/users.php">&rsaquo; Users</a></li>
        <li><a href="{$site_path}/groups.php">&rsaquo; Groups</a></li>
        <li><a href="{$site_path}/tags.php">&rsaquo; Tags</a></li>
        </ul>
      </div>

{*
      <div class="lighterBackground">
        <p class="sideBarTitle">Alternative stylesheet</p>
        <span class="sideBarText">
          Sinorca contains an alternative stylesheet that renders this side bar differently.
        </span>
        <span class="sideBarText">
          To view the alternative stylesheet in (certain)
          <span class="titleTip" title="eg: Mozilla, Camino, Netscape 6+">Gecko-based browsers</span>,
          select <em>Sinorca (alternative)</em> from the <em>View</em> &rsaquo; <em>Use Style</em>
          submenu.
        </span>
      </div>
*}

      <div>
        <p class="sideBarTitle">Archives</p>
        <ul>
        {archives}
        <li><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}">{$archive_date|date_format:"%B, %Y"}</a></li>
        {/archives}
        </ul>
        
        <p><a href="{$site_rss_url}" title="RSS 2.0 feed"><img src="{$site_path}/{$dir_images}/feed-icon16x16.png" alt="" /></a></p>      </div>
    </div>
