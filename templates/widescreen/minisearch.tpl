{* $Id: minisearch.tpl,v 1.3 2005/12/05 00:08:38 glen Exp $
** This is a minature search form
*}
<form id="minisearch" action="{$site_path}/search.php" method="get">
<input type="text" name="q" value="Search..." onFocus="this.value='';this.style.color='black';" class="search" />
<input type="submit" value="GO" />
</form>