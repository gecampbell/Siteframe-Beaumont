{* $Id: index.tpl,v 1.67 2005/11/23 04:04:49 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
**
** This template is used to generate the overall home page for the entire
** site (not just a weblog or photo album).
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl"}
</head>
<body>
<div id="content">
{include file="header.tpl"}
<div id="main">
    <div id="hello">
    {text name="home_page" default="Welcome to $site_name"}
    </div>
    <div class="items">
    {section name=item loop=$items}
    {if $smarty.section.item.index==1}
       {random class="Quote"}
       <blockquote><img src="{$site_path}/images/lquote.gif" alt="" class="lq" />{$quote.quote_text}<img src="{$site_path}/images/rquote.gif" alt="" class="rq" /></blockquote>
       {/random}
    {/if}
    {include file=$item_template page=$items[item]}
    {/section}
    </div><!-- class="items" -->
</div><!-- id="main" -->
{include file="menu.tpl"}
{include file="footer.tpl"}
</div><!-- id="content" -->
</body>
</html>
