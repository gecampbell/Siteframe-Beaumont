{* $Id: rating.tpl,v 1.10 2005/12/15 05:31:49 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This module lets the user add a rating to an object
** It must be invoked with rating_class=Class
*}
{assign var="gray" value="$site_path/images/star_gray.png"}
{assign var="red" value="$site_path/images/star_red.png"}
{assign var="gold" value="$site_path/images/star_gold.png"}
{if $allow_ratings}
<!-- rating widget -->
<style type="text/css">
@import url({$site_path}/{config name="dir_templates"}/rating.css);
</style>
<script type="text/javascript">
var xml=newxmlobj();
var myrate=0;
{if $url_rewriting}
{assign var="geturl" 
        value="$site_path/api/V1/PageRating/$page_name?key=`$cuser.user_hash`"}
{assign var="rateurl"
        value="$site_path/api/V1/Rating?key=`$cuser.user_hash`"}
{else}
{assign var="geturl"
        value="$site_path/api.php?v=1&r=PageRating&id=$page_name&key=`$cuser.user_hash`"}
{assign var="rateurl"
        value="$site_path/api.php?v=1&r=Rating&key=`$cuser.user_hash`"}
{/if}
function showRating() {ldelim}
    var URL = '{$geturl}';
    xml.onreadystatechange=getAvgRating;
    xml.open("GET", URL);
    xml.send(null);
{rdelim}
function setRating(value) {ldelim}
    var URL = '{$rateurl}';
    xml.onreadystatechange = doNothing;
    xml.open("POST", URL, false);
    xml.setRequestHeader('Content-Type', 
        'application/x-www-form-urlencoded; multipart/form-data; charset=utf-8');
    xml.send('rate_page_id={$page_id}&rate_rating='+value);
    myrate = value;
{rdelim}
function getAvgRating() {ldelim}
    if (xml.readyState == 4) {ldelim}
        if (xml.status == 200) {ldelim}
            var elem = document.getElementById('avgrating');
            var response = xml.responseXML.documentElement;
            var avg = response.getElementsByTagName('AverageRating')[0].firstChild.data;
            var num = response.getElementsByTagName('NumRatings')[0].firstChild.data;
            myrate = response.getElementsByTagName('MyRating')[0].firstChild.data;
            document.getElementById('avgrating').innerHTML = avg;
            document.getElementById('numratings').innerHTML = num;
            star_preview('star', myrate, '{$red}', '{$gray}');
        {rdelim}
    {rdelim}
{rdelim}
function doNothing() {ldelim}
{rdelim}
showRating();
</script>
<div class="rating">
<span id="numratings"></span>
{if $cuser.id && $allow_user_rating}
<span class="stars">
  <img src="{$gray}" name="star[1]" title="Rate this 1 star" alt=""
     onMouseOver="star_preview('star',1,'{$gold}','{$gray}')"
     onMouseOut="star_preview('star',myrate,'{$red}','{$gray}')"
     onClick="setRating(1);showRating()" 
/><img src="{$gray}" name="star[2]" title="Rate this 2 stars" alt=""
     onMouseOver="star_preview('star',2,'{$gold}','{$gray}')"
     onMouseOut="star_preview('star',myrate,'{$red}','{$gray}')"
     onClick="setRating(2);showRating()" 
/><img src="{$gray}" name="star[3]" title="Rate this 3 stars" alt=""
     onMouseOver="star_preview('star',3,'{$gold}','{$gray}')"
     onMouseOut="star_preview('star',myrate,'{$red}','{$gray}')"
     onClick="setRating(3);showRating()" 
/><img src="{$gray}" name="star[4]" title="Rate this 4 stars" alt=""
     onMouseOver="star_preview('star',4,'{$gold}','{$gray}')"
     onMouseOut="star_preview('star',myrate,'{$red}','{$gray}')"
     onClick="setRating(4);showRating()" 
/><img src="{$gray}" name="star[5]" title="Rate this 5 stars" alt=""
     onMouseOver="star_preview('star',5,'{$gold}','{$gray}')"
     onMouseOut="star_preview('star',myrate,'{$red}','{$gray}')"
     onClick="setRating(5);showRating()" 
/>
</span>
{else}
<span class="stars">&mdash;</span>
{/if}
<br />
<span id="avgrating"></span>
<br />
</div>{* class="rating" *}
{/if}