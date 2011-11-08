/* $Id: siteframe.js,v 1.22 2005/12/14 22:47:49 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This is a common Javascript file available for use from
** Siteframe templates
*/

/* hides an element */
function hide( targetID ) {
    var elem=document.getElementById( targetID );
    elem.style.display = "none";
}

/* shows an element */
function show( targetID ) {
    var elem=document.getElementById( targetID );
    elem.style.display = "";
}

/* toggles an element between hiding and showing */
function toggle( targetID )
{
    var elem=document.getElementById( targetID );
    if (elem.style.display == "none")
        elem.style.display = "";
    else
        elem.style.display = "none";
}

/* swaps the display states of two elements */
function swap( first, second )
{
    hide( first );
    show( second );
}

/* reply_to - opens comment form for replies */
function reply_to( id, subject, showID )
{
    show(showID);
    var form=document.getElementById("commentform");
    form.comment_subject.value = subject;
    form.comment_reply_to.value = id;
    focus("commentform");
    //return false;
}

/* sends a value to a form element in the opener window */
function send_value_to_opener( element, value )
{
    window.opener.document.getElementById(element).innerHTML += value;
    return false;
}
function send_value_and_close( element, value )
{
    send_value_to_opener( element, value );
    self.close();
    return false;
}

/* add_file_item() - adds a new form field */
function add_file_item( div_id, name )
{
    var elem=document.getElementById( div_id );
    elem.innerHTML += '<span class="fileinput"><input type="file" name="' + name + '[]" /></span>';
}

function del_file_item( div_id, file_id )
{
    var elem=document.getElementById( div_id );
    elem.style.display = "none";
    elem.innerHTML = '<input type="hidden" name="del_att[]" value="' +
        file_id + '" />';
}

// setfocus to element
function setfocus( id )
{
    var elem=document.getElementById(id);
    elem.focus();
}

// popup a window
function popup( theURL, theName, theParms )
{
    windowHandle = window.open(theURL, theName, theParms);
    if (!windowHandle) { windowHandle.opener = self; }
    windowHandle.focus();
}

/* highlight table row */
function highlight_tr( obj, over )
{
    if (over) {
        colour = obj.style.background;
        obj.style.background = 'lemonchiffon';
    }
    else {
        obj.style.background = colour;
    }
}

// star_preview - display rating N in div place
function star_preview(name, rating, low, high)
{
    for(i=1; i<=rating; i++)
        document.images[name+"["+i+"]"].src = low;
    for(i=rating+1; i<=5; i++)
        document.images[name+"["+i+"]"].src = high;
}

// make new XMLHTTP object
function newxmlobj()
{
    if (window.ActiveXObject)
    {
        // IE
        var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if (window.XMLHttpRequest)
    {
        // Mozilla (Firefox, etc.)
        var xmlhttp = new XMLHttpRequest();
    }
    return xmlhttp;
}

// fetches a URL to an element
function fetchURL(xmlhttp, URL, id)
{
    xmlhttp.onreadystatechange = function() {
        var elem=document.getElementById(id);
        if (xml.readyState == 4) {
            if (xml.status == 200) {
                elem.innerHTML = xml.responseText;
            }
        }
    };
    xmlhttp.open("GET", URL);
    xmlhttp.send(null);
}