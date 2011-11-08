{* $Id: newsletter.tpl,v 1.6 2005/11/22 22:57:10 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This is an e-mail template to send a site newsletter. It should be
** modified to suit your site and your newsletter purpose.
*}
<div style="font-size:36px;">{lang name="title_newsletter"}</div>
<p><small>{$smarty.now|date_format:"$date_format"}</small></p>

<p>Edit the newsletter template to customize this page for your site.</p>

<h2>New Pages</h2>
{recent class="Page" num=20}
<p><a href="{$site_url_base}/{$page.url}">{$page.page_title}</a><br/>
<small>by {$page.user.user_name} - {$page.page_created|date_format:"$date_format $time_format"}</small><br/>
{$page.page_text|strip_tags|truncate:200}
{if $page.num_images}
<br /><small>{$page.num_images} images</small>
{/if}
</p>
<hr />
{/recent}

{include file="footer.tpl"}