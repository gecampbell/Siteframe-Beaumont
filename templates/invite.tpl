{* $Id: invite.tpl,v 1.3 2005/11/20 16:36:39 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template is used for invitation messages.
*}
<p>{$inv_firstname} {$inv_lastname}:</p>

<p>You have been invited to join {$site_name} by {$cuser.user_firstname} 
{$cuser.user_lastname}.</p>

<p>{$cuser.user_firstname} writes:</p>
<blockquote>{$inv_message}</blockquote>

<p>If you wish to accept this invitation and join the site, click on
the link below (or cut it out and paste it into your web browser).</p>

<p><a href="{$site_url}/register.php?i={$inv_hash|escape:"url"}">{$site_url}/register.php?i={$inv_hash|escape:"url"}</a></p>

<p>If you don't wish to join at this time, you can simply delete this message
and nothing more will happen.</p>

{include file="footer.tpl"}