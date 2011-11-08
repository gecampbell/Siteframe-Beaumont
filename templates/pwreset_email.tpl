{* $Id: pwreset_email.tpl,v 1.6 2005/03/16 14:54:48 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
*}
<p>Your passphrase at {$site_name} has been reset. Your new passphrase is:</p>

<p><code>{$new_passphrase}</code></p>

<p>You should sign on immediately and change it, since e-mail is an insecure 
method of transmitting secure information like this.</p>

{include file="footer.tpl"}