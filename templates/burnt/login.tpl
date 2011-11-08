{* $Id: login.tpl,v 1.5 2006/01/01 16:17:46 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** login page template
*}
{menu name="action" text="Forgot your password?" link="$site_path/pwreset.php"}
{include file="top.tpl"}
<div id="mightylinks">
{if $help_text ne ""}<p>{$help_text}</p>{/if}
</div>

<div class="text">
{if $page_title ne ""}
<h1><strong>{$page_title|default:"Sign On"}</strong></h1>
<p>&nbsp;</p>
{/if}
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$login_form}
</div>{* class="text" *}

</div>{* class="text" *}
{include file="bottom.tpl"}