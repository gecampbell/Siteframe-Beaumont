$Id: README.txt,v 1.14 2007/09/04 18:11:57 glen Exp $
README - Siteframe Beaumont, Version %%VERSION%%, Build %%BUILD%%
===============================================================================
REQUIREMENTS
===============================================================================

Required Software

* PHP5 with mysqli extensions
* MySQL client 4.1.3 / MySQL server 4.1+
* Apache 2.0 (1.3 probable but untested)
* Smarty 2.x PHP templating package (see http://smarty.php.net)

(Note that this represents the environment under which this software
was developed; it may work with other packages or older versions,
but that cannot be determined at this time.)

PHP5 extensions

* The "ext/mysqli" extension is required.
* The "ext/gd" extension is required if you want to use images on your site.
* The "ext/curl" extension is required for outbound Trackback pings.
* The PEAR XML-RPC module is required to use the "ping" plugin.
* The PHP5-exif module is used, if available, to retrieve EXIF information from 
  photographs.

Settings

* allow_url_fopen - this setting must be On to permit access to RSS feeds

===============================================================================
INSTALLATION
===============================================================================

1. Copy siteframe.ini-dist to siteframe.ini; edit it to suit your
configuration. You must at least set the following configuration
parameters so that you can connect to your database:

   site_url
   site_path
   db_host
   db_user
   db_password
   db_database

2. Upload the files to your web server; make sure that the files/
directory is writable by the web server process.

3. Point your browser to http://...your-site.../setup.php.

Once you have completed setup, the setup.php script can be removed,
since it will not run once the database has been installed.

===============================================================================
UPGRADING
===============================================================================

To upgrade, it's usually simple enough to extract the files from
the distribution archive into your web directory; avoid overwriting
files that you may have modified (such as custom templates).

If you are upgrading, you should always update your database
definitions in case something has changed. Sign on as an administrator;
go to the Administrator menu (http://yoursite.com/admin.php), and click
on the "Update Database" link. This will ensure that your database
definitions are up-to-date.

In some cases, additional upgrade steps may be necessary; check the
release notes with each new release to see if something else needs
to be done.

===============================================================================
ADDITIONAL STEPS - VERY IMPORTANT!!!
===============================================================================

If you are using the Apache webserver, you should copy the file
_htaccess to .htaccess in your web root directory. This file performs
two functions:

1. It adds security access controls so that sensitive information
cannot be downloaded, such as your database user name and password.

2. It enables "user-friendly" URLs through mod_rewrite. (To fully
enable this feature, set url_rewriting=On in siteframe.ini.)

You should copy _htaccess to .htaccess even if you are not using
mod_rewrite for the security reasons outlined above (you may need
to delete the rewrite rules if you do not have mod_rewrite available).

===============================================================================
SECURITY CONCERNS
===============================================================================

To ensure that Siteframe will work in the widest variety of situations,
I have set the value of DEFAULT_FILE_PERMS to 0777 - this means
that anyone on the server can read, write, delete, those files and
directories that are created by the software. HOWEVER, this may not
be good in a shared hosting environment where you may not be able
to trust other users, so I STRONGLY recommend that you change this
value to the most restrictive possible. For example, if the user
who owns the filesystem is the same user as running Apache, then a
value of 0700 may be more suitable (no group or world read or write
access). To modify this, change the value of DEFAULT_FILE_PERMS in
siteframe.inc.

===============================================================================
CONTACT INFORMATION
===============================================================================

feedback@siteframe.org - to report bugs or for general feedback
