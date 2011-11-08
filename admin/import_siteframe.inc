<?php
// $Id: import_siteframe.inc,v 1.19 2006/05/03 01:31:48 glen Exp $
// Copyrigth (c)2005, Glen Campbell. All rights reserved.
//
// MODULE(Import from Siteframe 3.x)

// displays an error message
function error($msg, $p1='', $p2='', $p3='', $p4='', $p5='')
{
    global $PAGE, $ERRORS;
    ++$ERRORS;
    $s = sprintf($msg, $p1, $p2, $p3, $p4, $p5);
    outline('<span style="color:red;">%s</span>', $s);
    $PAGE->assign('error', sprintf('%d error(s)', $ERRORS));
}

// displays a (non-error) message
function outline($msg, $p1='', $p2='', $p3='', $p4='', $p5='')
{
    echo sprintf($msg,$p1,$p2,$p3,$p4,$p5) . "<br />\n";
}

// updates the creation date
function update_creation_date($obj, $date)
{
    $DB = Database::getWriter();

    $q = sprintf(
        "UPDATE %s SET %s='%s' WHERE %s=%d",
        $obj->table_name(),
        $obj->created,
        addslashes($date),
        $obj->key,
        $obj->id());
    $DB->query($q);
    check_db($DB);
}

$PAGE->assign('page_title', 'Import from Siteframe 3.x');

// allow this script to run as long as necessary
set_time_limit(0);

// turn off registration confirmations
$CONFIG['confirm_email'] = FALSE;

if ($_POST['_submitted'])
{
    $ERRORS = 0;
    
    // establish constants
    if ($_POST['new_ver'])
    {
        define('USER_CREATED',      'user_created');
        define('FOLDER_CREATED',    'created');
        define('DOC_CREATED',       'doc_created');
        define('COMMENT_CREATED',   'comment_created');
        define('COMMENT_OWNER_ID',  'comment_owner_id');
        define('COMMENT_DOC_ID',    'comment_doc_id');
    }
    else
    {
        define('USER_CREATED',      'created');
        define('FOLDER_CREATED',    'created');
        define('DOC_CREATED',       'created');
        define('COMMENT_CREATED',   'created');
        define('COMMENT_OWNER_ID',  'owner_id');
        define('COMMENT_DOC_ID',    'doc_id');
    }
    
    outline("Beginning import...");
    
    // establish database connection
    $SOURCE = new mysqli(
        $_POST['db_host'],
        $_POST['db_user'],
        $_POST['db_pass'],
        $_POST['db_name']
    );
    if (mysqli_connect_errno())
        error('Unable to connect with specified parameters');
    
    // process users
    if ($_POST['import_users'])
    {
        $r = $SOURCE->query("SELECT * FROM users ORDER BY user_id");
        check_db($SOURCE);
        
        // counter
        $count = 0;
        
        while($arr = $r->fetch_assoc())
        {
            printf('(%d) ', ++$count);
            echo $arr['user_email'].': ';
            $uname = trim($arr['user_nickname']);
            if ($uname == '')
                $uname = $arr['user_firstname'].$arr['user_lastname'];
            $uname = preg_replace('/[^a-zA-Z0-9_]+/', '', $uname);
            while(strlen($uname) < 4)
                $uname .= 'X';
            $u = new User;
            $u->set('user_id',          0);
            $u->set('user_name',        $uname);
            if (trim($arr['user_firstname']) == '')
                $arr['user_firstname'] = 'XX';
            $u->set('user_firstname',   $arr['user_firstname']);
            while(strlen($arr['user_lastname']) < 2)
                $arr['user_lastname'] .= 'XXX';
            if (preg_match('/^[0-9]/', $arr['user_lastname']))
                $arr['user_lastname'] = 'X' . $arr['user_lastname'];
            $u->set('user_lastname',    $arr['user_lastname']);
            $u->set('user_email',       $arr['user_email']);
            
            // 1st try to add
            $u->add();
            
            // check for duplicate user names
            if (preg_match('/Duplicate.*key 3/', $u->get_errors()))
            {
                $u->reset_errors();
                $u->set('user_name', $u->get('user_name').rand(1,999));
                $uname = $u->get('user_name');
                $u->add();
            }

            echo "user name $uname: ";

            if ($u->is_valid())
            {
                // save user names
                $USER_NAMES[$u->id()] = $uname;
                
                // update creation date
                update_creation_date($u, $arr[USER_CREATED]);

                // save the password
                $q = sprintf("UPDATE %s SET user_password='%s' WHERE user_id=%d",
                        $u->table_name(),
                        $arr['user_passwd'],
                        $u->id());
                $DB = Database::getWriter();
                $DB->query($q);
                check_db($DB);
                $USER_MAP[$arr['user_id']] = $u->id();
                outline('[%d=%d]', $arr['user_id'], $u->id());
            }
            
            if (!$u->is_valid())
            {
                error('unable to import user, %s', $u->get_errors());
            }
        }
    }
    
    // process folders
    // establish database connection
    $SOURCE = new mysqli(
        $_POST['db_host'],
        $_POST['db_user'],
        $_POST['db_pass'],
        $_POST['db_name']
    );
    if (mysqli_connect_errno())
        error('Unable to connect with specified parameters');
    
    if ($_POST['import_folders'])
    {
        $r = $SOURCE->query("SELECT * FROM folders ORDER BY folder_id");
        check_db($SOURCE);
        if (!$r) die("Database error: ".$SOURCE->error);
        
        while($arr = $r->fetch_assoc())
        {
            echo "Folder ".$arr['folder_name'].": ";
            $f = new Folder;
            $f->set('folder_user_id', $USER_MAP[$arr['folder_owner_id']]);
            $f->set('folder_parent_id', 0);
            $f->set('folder_allow_subfolders', $arr['folder_children']);
            $f->set('folder_public', $arr['folder_public']);
            $f->set('folder_title', $arr['folder_name']);
            $f->set('folder_text', $arr['folder_body']);
            $f->add();
            if ($f->is_valid())
            {
                update_creation_date($f, $arr[FOLDER_CREATED]);
                $FOLDER_MAP[$arr['folder_id']] = $f->id();
                $USER_FOLDER[$f->get('folder_user_id')] = $f->id();
                outline("success");
            }
            else
            {
                error("error: %s", $f->get_errors());
            }
        }
    }
    
    // process docs
    // establish database connection
    $SOURCE = new mysqli(
        $_POST['db_host'],
        $_POST['db_user'],
        $_POST['db_pass'],
        $_POST['db_name']
    );
    if (mysqli_connect_errno())
        error('Unable to connect with specified parameters');
    
    if ($_POST['import_docs'])
    {
        $r = $SOURCE->query("SELECT * FROM docs ORDER BY doc_id");
        check_db($SOURCE);
        
        while($arr = $r->fetch_assoc())
        {
            echo "Document ".$arr['doc_title'].": ";
            switch($arr['doc_type'])
            {
            case 'Link':
                outline("Link: %s", $arr['doc_title']);
                $newlink = new Link;
                $newlink->set('link_user_id', $USER_MAP[$arr['doc_owner_id']]);
                $newlink->set('link_text', $arr['doc_title']);
                $newlink->set('link_comment', $arr['doc_body']);
                if (preg_match(
                        '/\<doc_link_url\>(.+)\<\/doc_link_url\>/',
                        $arr['doc_props'],
                        $mat))
                {
                    $newlink->set('link_url', $mat[1]);
                    $newlink->add();
                    if ($newlink->is_valid())
                    {
                        update_creation_date($newlink, $arr[DOC_CREATED]);
                        outline("ok");
                    }
                    else
                        error("error importing Link: %s", $newlink->get_errors());
                }
                break;
            case 'Article':
            case 'Image':
            case 'DocFile':
                outline($arr['doc_type']);
                
                // create a page object
                $newpage = new Page;
                
                // get owner ID
                $owner = $USER_MAP[$arr['doc_owner_id']];
                
                // set some properties
                $newpage->set('page_user_id', $owner);
                $newpage->set('page_title', $arr['doc_title']);
                $newpage->set('page_text', $arr['doc_body']);
                
                // compute folder
                if ($arr['doc_folder_id'])
                    $newpage->set('page_folder_id', $FOLDER_MAP[$arr['doc_folder_id']]);
                // if the user has a folder, use it
                else if ($USER_FOLDER[$owner])
                    $newpage->set('page_folder_id', $USER_FOLDER[$owner]);
                // otherwise, create a new folder for the user
                else
                {
                    $f = new Folder;
                    $f->set('folder_user_id', $owner);
                    $f->set('folder_title', $USER_NAMES[$owner]."'s Place");
                    $f->add();
                    if ($f->is_valid())
                    {
                        $USER_FOLDER[$owner] = $f->id();
                        $newpage->set('page_folder_id', $f->id());
                    }
                    else
                        error("error: %s", $f->get_errors());
                }
                
                // images require a File object
                if (($arr['doc_type'] == 'Image')||($arr['doc_type'] == 'DocFile'))
                {
                    $props = $arr['doc_props'];
                    $file_type = '';
                    if (preg_match(
                            '/\<doc_file_mime_type\>(.+)\<\/doc_file_mime_type\>/',
                            $props, 
                            $match))
                        $file_type = $match[1];
                    if (preg_match(
                            '/\<doc_file\>(.*)\<\/doc_file\>/',
                            $props,
                            $match))
                    {
                        if (trim($file_type) == '')
                            error('No MIME type');
                        else
                        {
                            $src_filename = $_POST['source_files'].'/'.$match[1];
                            outline('file: %s type: %s', $src_filename, $file_type);
                            $newpage->import_file(
                                $src_filename,
                                $file_type
                            );
                        }
                    }
                }
                
                // all set? then create the page
                $newpage->add();
                update_creation_date($newpage, $arr[DOC_CREATED]);
                $PAGE_MAP[$arr['doc_id']] = $newpage->id();
                if ($newpage->is_valid())
                {
                    outline("...added");
                }
                else
                {
                    error("error adding page: %s", $newpage->get_errors());
                }
                break;
            default:
                error('%s not supported for import', $arr['doc_type']);
            }
        }
        
        // if we import docs, also import comments
        // establish database connection
        $SOURCE = new mysqli(
            $_POST['db_host'],
            $_POST['db_user'],
            $_POST['db_pass'],
            $_POST['db_name']
        );
        if (mysqli_connect_errno())
            error('Unable to connect with specified parameters');
    
        $r = $SOURCE->query("SELECT * FROM comments ORDER BY comment_id");
        check_db($SOURCE);
        
        while($arr = $r->fetch_assoc())
        {
            $c = new Comment;
            $c->set('comment_user_id', $USER_MAP[$arr[COMMENT_OWNER_ID]]);
            $c->set('comment_page_id', $PAGE_MAP[$arr[COMMENT_DOC_ID]]);
            if (preg_match('/\<comment_subject\>(.*)\<\/comment_subject\>/',
                    $arr['comment_props'],
                    $mat))
                $c->set('comment_subject', $mat[1]);
            $c->set('comment_text', $arr['comment_body']);
            $c->add();
            if ($c->is_valid())
            {
                update_creation_date($c, $arr[COMMENT_CREATED]);
                outline("Comment %s", $c->get('comment_subject'));
            }
            else
            {
                error("Error adding comment: %s", $c->get_errors());
                print_r($c);
            }
        }
    }
    
    outline("Import complete");
    exit;
}

$inf = new InputForm('import', $_SERVER['REQUEST_URI'], "post", "Import");
$inf->add_item('new_ver', array(
    'type' => 'checkbox',
    'rval' => 1,
    'prompt' => 'Siteframe version >3.2',
    'help' => 'Siteframe 3.2 introduced a number of column name changes. Check this box if you are importing from a 3.2 site; leave unchecked if you are importing from 3.1.6 or older. If you are running 3.1.9, you should upgrade to 3.2 and then check this box.',
    'value' => $_POST['new_ver'],
));
$inf->add_item('import_users', array(
    'type' => 'checkbox',
    'rval' => 1,
    'prompt' => 'Import Users',
    'help' => 'Check this box to import users.',
    'value' => isset($_POST['import_users']) ? $_POST['import_users'] : 1,
));
$inf->add_item('import_folders', array(
    'type' => 'checkbox',
    'rval' => 1,
    'prompt' => 'Import Folders',
    'help' => 'Check to import folders (recommended).',
    'value' => isset($_POST['import_folders']) ? $_POST['import_folders'] : 1,
));
$inf->add_item('import_docs', array(
    'type' => 'checkbox',
    'rval' => 1,
    'value' => 1,
    'prompt' => 'Import Documents',
    'help' => 'Check this box to import documents. '.
        'Note: only files, images, and articles are currently supported.',
    'value' => isset($_POST['import_docs']) ? $_POST['import_docs'] : 1,
));
$inf->add_item('source_files', array(
    'type' => 'text',
    'prompt' => 'Root directory',
    'size' => 40,
    'help' => 'The full path of the directory (on the server) holding the site files.',
    'value' => $_POST['source_files'],
));
$inf->add_item('db_host', array(
    'type' => 'text',
    'prompt' => 'Database host',
    'help' => 'The host name where the source database is stored.',
    'value' => $_POST['db_host'],
));
$inf->add_item('db_user', array(
    'type' => 'text',
    'prompt' => 'Database user',
    'help' => 'A database user with access to the source data.',
    'value' => $_POST['db_user'],
));
$inf->add_item('db_pass', array(
    'type' => 'text',
    'prompt' => 'Database password',
    'help' => 'The password for the source user.',
    'value' => $_POST['db_pass'],
));
$inf->add_item('db_name', array(
    'type' => 'text',
    'prompt' => 'Database name',
    'help' => 'The name of the source database.',
    'value' => $_POST['db_name'],
));
$_TOP = <<<ENDTOP
<p>Use this page to import a Siteframe 3.x website into this site.
Uses the checkboxes below to select the types of data that you wish to 
import (please note that not all data can be successfully migrated).
If you select the "Documents" box, make sure that you have specified 
the source FILES directory; this is the directory that holds users' uploaded
files and images.</p>
<p>You should back up both your source and target databases before beginning and
be prepared to do this multiple times before it works properly.</p>
ENDTOP;
$PAGE->assign('admin_content', $_TOP.$inf->get_form());

?>