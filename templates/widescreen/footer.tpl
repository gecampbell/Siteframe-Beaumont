{* $Id: footer.tpl,v 1.5 2005/12/23 17:12:13 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the bottom of the page
*}
{include file="action.tpl}
</div>{* id="wrapper" - opened in header.tpl *}
<div id="footer">
{$site_copyright} :
<a href="http://siteframe.org">Siteframe</a>&trade; Beaumont {$VERSION}
<br />
<a href="{$site_path}/sitemap.php">Site Map</a>
{if $content_link_about ne ""} : <a href="{textlink name=$content_link_about}">About</a>{/if}
{if $content_link_tos ne ""} : <a href="{textlink name=$content_link_tos}">Terms of Service</a>{/if}
{if $content_link_privacy ne ""} : <a href="{textlink name=$content_link_privacy}">Privacy Policy</a>{/if}
{if $content_link_contact ne ""} : <a href="{textlink name=$content_link_contact}">Contact Us</a>{/if}
{if $content_link_help ne ""} : <a href="{textlink name=$content_link_help}">Help</a>{/if}
{if $content_link_abuse ne ""} : <a href="{textlink name=$content_link_abuse}">Abuse</a>{/if}
</div>
