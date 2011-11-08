{* $Id: xml.tpl,v 1.1 2005/03/06 19:48:46 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays an XML feed (RSS, Atom)
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>
<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}

<p class="info">
Tagline: {$xml.tagline}<br/>
Copyright: {$xml.copyright}<br/>
Generator: {$xml.generator}<br/>
</p>


</div><!-- class="content" -->

{include file="footer.tpl"}
