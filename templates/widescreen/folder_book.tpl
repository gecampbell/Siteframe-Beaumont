{* $Id: folder_book.tpl,v 1.1 2005/11/19 22:22:58 glen Exp $
** displays folder contents as a book table of contents
*}
{assign var=page value=$items[item]}
<p class="book_item">
<big><b><a href="{$page.url}">{$page.page_title}</a></b></big>
<span class="pagetext">{$page.page_text|strip_tags|truncate:300:"...":false}</span>
</p>