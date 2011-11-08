{* $Id: head_rss.tpl,v 1.1 2005/12/10 04:23:33 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template generates syndication feed information for the <head>
** part of HTML pages
*}

<link rel="SHORTCUT ICON" href="{$site_path}/favicon.ico" />

<!-- RSS feed information -->
{if $rss_enable}
<link rel="alternate" type="application/rss+xml" title="RSS for {$site_name}" 
      href="{$site_rss_url}" />
{/if}
{if $rss_url}
<link rel="alternate" type="application/rss+xml" title="RSS for {$title}" 
      href="{$rss_url}" />
{/if}
{if $folder.rss_url}
<link rel="alternate" type="application/rss+xml" title="RSS for {$folder.title}" 
      href="{$folder.rss_url}" />
{/if}
{if $user.rss_url}
<link rel="alternate" type="application/rss+xml" title="RSS for {$user.title}" 
      href="{$user.rss_url}" />
{/if}
