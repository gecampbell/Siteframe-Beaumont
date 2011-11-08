{* $Id: login.tpl,v 1.6 2006/01/01 16:17:46 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** login page template
*}
{menu name="action" text="Forgot your password?" link="$site_path/pwreset.php"}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=1}
<style type="text/css">
{literal}
.help { display:none; }
{/literal}
</style>
</head>
<body>
<div id="content">
{include file="header.tpl"}

{if $error ne ""}<p class="error">{$error}</p>{/if}
<div id="main">
{$login_form}
{text name="login" default=""}
</div>
<div id="menu">
If you click the "Remember me" box,
a cookie will be placed on this computer,
allowing you to visit the site in the
future without needing to login. Do not
check this box on a public terminal, because
someone else could act as you without your
knowledge or permission.
</div>
{include file="footer.tpl"}
</div>
</body>
</html>
