{* $Id: footer.tpl,v 1.19 2005/12/23 17:12:12 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the bottom of the page
*}
{include file="action.tpl}
<div id="footer">
{$site_copyright}
&bull;
powered by <a href="http://siteframe.org">Siteframe</a>&trade; Beaumont {$VERSION}
<br />
<a href="{$site_path}/sitemap.php">Site Map
{if $content_link_about ne ""}&bull; 
    <a href="{textlink name=$content_link_about}">About</a>{/if}
{if $content_link_tos ne ""}&bull;
    <a href="{$content_link_tos}">Terms of Service</a>{/if}
{if $content_link_privacy ne ""}&bull;
    <a href="{$content_link_privacy}">Privacy Policy</a>{/if}
{if $content_link_contact ne ""}&bull;
    <a href="{$content_link_contact}">Contact Us</a>{/if}
{if $content_link_help ne ""}&bull;
    <a href="{textlink name=$content_link_help}">Help</a>{/if}
{if $content_link_abuse ne ""}&bull;
    <a href="{$content_link_abuse}">Abuse</a>{/if}
</div>
