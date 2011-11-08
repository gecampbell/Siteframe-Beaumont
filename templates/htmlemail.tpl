{* $Id: htmlemail.tpl,v 1.10 2005/11/26 06:59:17 glen Exp $
** Formatted HTML e-mail
*}
This is a MIME-formatted email. If you can read this, your e-mail
reader cannot handle MIME-encoded email. You should upgrade your
e-mail software to a more recent version.

--{$mime_boundary}
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

{textformat}
{$mail_body|strip_tags:false}
{/textformat}

--{$mime_boundary}
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: base64

{$mail_body_base64}
