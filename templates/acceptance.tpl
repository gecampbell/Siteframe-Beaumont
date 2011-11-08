{* $Id: acceptance.tpl,v 1.3 2005/11/20 04:00:32 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template is used to notify a user of a new user ($newuser)
** who has accepted an invitation
*}
<p>{$newuser.user_firstname} {$newuser.user_lastname} has accepted your 
invitation to join {$site_name}. His user information is shown below:</p>
<ul>
<li>User name: {$newuser.user_name}</li>
<li>User page: <a href="{$site_url}{$newuser.url}">{$site_url}{$newuser.url}</a></li>
</ul>
{include file="footer.tpl"}