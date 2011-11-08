<p>You have been registered at {$site_name} with the following information:</p>
<p>
User name: {$user_name}<br />
Full name: {$user_firstname} {$user_lastname}</p>
<p>
If you did not register yourself, or you registered by accident,
you can simply ignore this message and nothing further will happen.
If you registered, however, you need to confirm your e-mail address.</p>
<p>
To confirm your e-mail address, click on the link below or, if that
is not possible, cut the link out and paste it into your web browser:</p>

<p><a href="{$site_url}/login.php?conf={$user_hash}">{$site_url}/login.php?conf={$user_hash}</a></p>
{include file="footer.tpl"}