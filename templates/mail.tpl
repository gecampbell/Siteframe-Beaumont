{* $Id: mail.tpl,v 1.11 2005/11/21 05:16:25 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template is used for a user-to-user e-mail message
*}
{$message}

<p>From {$user.user_name} (<a href="{$site_url_base}{$user.url}">{$site_url_base}{$user.url}</a>)<br />
<a href="{$site_url}/mail.php?to={$user.id}&amp;subj=Re%3A{$mail_subj|escape:"url"}">Click here to reply</a></p>

{include file="footer.tpl"}
