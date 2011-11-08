{* $Id: imagepopup.tpl,v 1.1 2005/11/05 06:25:37 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template displays a full-sized image in a popup window
*}
<html>
<head>
<title>{$file_name}</title>
{literal}
<style type="text/css"><!--
body { margin:0; }
a img { border:none; }
--></style>
{/literal}
</head>
<body>
<a href="#" onClick="window.close();" title="Click to close window"><img src="{$file_path}" alt="{$file_name}" /></a>
</body>
</html>