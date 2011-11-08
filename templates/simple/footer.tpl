{* $Id: footer.tpl,v 1.16 2005/12/23 17:12:12 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the bottom of the page
*}
{include file="action.tpl}
<div class="footer">
{$site_copyright} &bull; <a href="http://siteframe.org">Siteframe</a>&trade; {$VERSION}
<br />
{if $content_link_about ne ""}| <a href="{textlink name=$content_link_about}">About</a>{/if}
{if $content_link_tos ne ""}| <a href="{textlink name=$content_link_tos}">Terms of Service</a>{/if}
{if $content_link_privacy ne ""}| <a href="{textlink name=$content_link_privacy}">Privacy Policy</a>{/if}
{if $content_link_contact ne ""}| <a href="{textlink name=$content_link_contact}">Contact Us</a>{/if}
{if $content_link_help ne ""}| <a href="{textlink name=$content_link_help}">Help</a>{/if}
{if $content_link_abuse ne ""}| <a href="{textlink name=$content_link_abuse}">Abuse</a>{/if}
</div>
</div>{* id="central" *}
</div>{* id="bodydiv" *}
</html>
