{* $Id: trackback.tpl,v 1.3 2005/12/31 23:39:52 glen Exp $
 * Copyright (c)2005, Glen Campbell. All rights reserved.
 * Implements Trackback auto-detect RDF
**}
{if $trackback_enable && ($script eq "page.php")}
<!--
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dc="http://purl.org/dc/elements/1.1/"
         xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
<rdf:Description
    rdf:about="{$site_url_base}/{$url}"
    dc:identifier="{$site_url_base}/{$url}"
    dc:title="{$title|escape:"url"}"
    trackback:ping="{$site_url}/tb.php?page={$id}" />
</rdf:RDF>
-->
{/if}
