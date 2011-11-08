{include file="preamble.tpl"}
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>{$page_title}</title>
<link href="{$site_path}/{$template_dir}/undohtml.css" rel="stylesheet" type="text/css" />
<link href="{$site_path}/{$template_dir}/style.css" rel="stylesheet" type="text/css" />
<link href="{$site_path}/{$template_dir}/siteframe.css?v={$BUILD}" rel="stylesheet" type="text/css" />
<meta http-equiv="content-type" content="text/html; charset={$charset}" />
<meta name="generator" content="Siteframe Beaumont {$VERSION}({$BUILD})" />
<meta name="copyright" content="{$site_copyright}" />
<meta name="revisit-after" content="1 days" />
<meta name="dc.title" content="{$site_name}" />
<meta name="dc.creator.e-mail" content="{$site_email}" />
<meta name="dc.format" content="multipart/mixed" />
<meta name="dc.identifier" scheme="uri" content="{$site_url}" />
<meta name="dc.language" scheme="rfc1766" content="{$lang_default}" />
<meta name="dc.relation.ispartof" content="{$site_url}" />
{include file="../trackback.tpl"}
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
</head>
<body>
<div id="header">
  <h1>{$site_name}</h1>
</div>
<div id="container">
<div id="infinitum">
  {if $cuser.id}
  <p>You are signed on as
  <a href="{$cuser.url}">{$cuser.user_name}</a><br />
  <a href="{$site_path}/login.php">Sign Off</a></p>
  <p>&nbsp;</p>
    {if $unread_msgs}
    <p style="text-align:center;color:red;">
    You have {$unread_msgs} unread memo{if $unread_msgs>1}s{/if}.</li>
    <a href="{$site_path}/memos.php">Click here to read {if $unread_msgs>1}them{else}it{/if}</a>
    </p>
    <p>&nbsp;</p>
    {/if}
  {/if}
  <p><strong>Navigation</strong><br />
    </strong><a href="{$site_url}">Home</a></p>
    <p><a href="{$site_path}/folders.php">Folders</a></p>
    <p><a href="{$site_path}/groups.php">Groups</a></p>
    <p><a href="{$site_path}/tags.php">Tags</a></p>
    <p><a href="{$site_path}/users.php">Users</a></p>
    <p><a href="{textlink name=help}">Help</a></p>
  <p>&nbsp;</p>
  <p><strong>Join In</strong><br />
  <p><a href="{$site_path}/register.php">Register</a></p>
  <p><a href="{$site_path}/login.php">Sign On</a></p>
  <p><a href="{$site_path}/edit.php?c=Invitation">Invite</a></p>
  <p><a href="{$site_path}/edit.php?c=Folder">Make a folder</a></p>
  <p><a href="{$site_path}/edit.php?c=Page">Make a page</a></p>
  <p><a href="{$site_path}/edit.php?c=Group">Make a group</a></p>
  <p>&nbsp;</p>
  <p>Search</strong><br />
  </p>
  <form name="form1" id="form1" method="get" action="{$site_path}/search.php">
    <input type="text" name="q" />
  </form>
  <p>&nbsp;</p>
  {if !$setup}
  <p><strong>Site Archives</strong></p>
  {archives}
  <p><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}">{$archive_date|date_format:"%B %Y"}</a></p>
  {/archives}
  <p>&nbsp;</p>
  {/if}

  <p><strong>Feeds</strong></p>
  {if $rss_enable}
  <p><a href="{$site_rss_url}" title="RSS 2.0 feed">RSS 2.0</a></p>
  {/if}
  <p>&nbsp;</p>
  <p><strong>Disclaimers</strong></p>
  <p>{$site_copyright}</p>
  <p><a href="http://smallpark.org">Design by Smallpark</a></p>
  <p><a href="http://siteframe.org">Powered by Siteframe</a></p>
  <p>&nbsp;</p>
</div>{* id="infinitum" *}
