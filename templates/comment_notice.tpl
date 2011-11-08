{* $Id: comment_notice.tpl,v 1.3 2005/04/25 23:21:27 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template is used for notification e-mail for new comments
*}
<p><i>New comment on "<a href="{$site_url_base}{$url}">{$title}</a>"</i></p>
{$comment_text}
<p>by 
{if $comment_user_id}
    {$user.user_name}
{else}
    <a href="{$tb_url}">{$tb_blog_name}</a> (via TrackBack)
{/if}
</p>

{include file="footer.tpl"}
