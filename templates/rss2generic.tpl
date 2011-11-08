{* $Id: rss2generic.tpl,v 1.5 2005/11/17 18:06:56 glen Exp $
** Copyright (c)2004-2005, Glen Campbell. All rights reserved.
**
** This template generates an RSS2.0 feed for a generic list
** of titles and links. Values required:
**      - rss_title
**      - rss_url
**      - rss_description
**      - rss_items (array of items)
**          - title
**          - description
**          - date
**          - link (URI)
*}
<?xml version="1.0" encoding="{$charset}"?>
<rss version="2.0">
<channel>
<title>{$rss_title|escape:"htmlall"}</title>
<link>{$rss_url}/</link>
<description>{$rss_description|escape:"htmlall"}</description>
<language>{lang name="language"}</language>
<copyright>{$site_copyright|replace:"&copy;":"(c)"}</copyright>
<lastBuildDate>{$smarty.now|date_format:"%a, %d %b %Y %H:%M:%S %Z"}</lastBuildDate>
<generator>Siteframe {$VERSION}</generator>
<webMaster>{$site_email}</webMaster>
<docs>http://blogs.law.harvard.edu/tech/rss</docs>
<ttl>60</ttl>
{section name=item loop=$rss_items}
<item>
<title>{$rss_items[item].title|escape:"htmlall"}</title>
{if $rss_items[item].description ne ""}<description><![CDATA[{$rss_items[item].description}]]></description>{/if}
{if $rss_items[item].date ne ""}<pubDate>{$rss_items[item].date|date_format:"%a, %d %b %Y %H:%M:%S %Z"}</pubDate>{/if}
<link>{$site_url_base}{$rss_items[item].link}</link>
</item>
{/section}
</channel>
</rss>
<!-- Siteframe {$VERSION} at {$smarty.now|date_format:"%a, %d %b %Y %H:%M:%S %Z"} -->
