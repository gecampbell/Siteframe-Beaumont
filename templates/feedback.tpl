{* $Id: feedback.tpl,v 1.2 2006/01/02 06:42:59 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template formats a feedback message
*}
{$message}

----------

Site Name = {$site_name}
Site URL = {$site_url}
Admin Name = {$cuser.user_name}
Admin E-mail = {$cuser.user_email}
Date = {$smarty.now|date_format:"%Y-%m-%d %H:%I %Z"}
Version = {$VERSION}/{$BUILD}