{* $Id: login.tpl,v 1.4 2006/01/01 16:17:46 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** login page template
*}
{menu name="action" text="Forgot your password?" link="$site_path/pwreset.php"}
{include file="preamble.tpl"}
{include file="html_head.tpl"}
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div class="login">
{text name="login" default=""}
{$login_form}
</div>
{include file="footer.tpl"}
