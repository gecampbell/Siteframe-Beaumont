{* $Id: custom.tpl,v 1.1 2005/04/09 05:35:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

{include file="$alt_template"}

{assign var=_owner value=$user._owner}
{assign var=edit_url value=$user.edit_url}
{assign var=delete_url value=$user.delete_url}
{include file="footer.tpl"}
