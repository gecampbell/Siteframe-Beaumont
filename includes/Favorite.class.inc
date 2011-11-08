<?php
// $Id: Favorite.class.inc,v 1.6 2006/01/03 00:44:10 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this class defines a User-to-user relationship

class Favorite extends DataObject
{
public $key = 'fav_id';
public $table = 'favorites';
public $created = 'fav_created';
public $owner = 'user_id';
public $metadata = array(
    'fav_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
    ),
    'user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'fav_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'fav_created' => array(
        'col' => true,
        'type' => 'datetime',
        'require' => true,
        'internal' => true,
        'noupdate' => true,
        'index' => true,
    ),
);

// add() - notify the new friend
public function add()
{
    if ($this->get('user_id') == $this->get('fav_user_id'))
        $this->add_error(lang('err_nofriendself'));
    parent::add();
    if ($this->is_valid())
        $this->notify_new_friend();
}

// get_all() 
public function get_all()
{
    $arr = parent::get_all();
    $u = new User($this->get('fav_user_id'));
    $arr['friend'] = $u->get_all();
    return $arr;
}

// sends message to new favorites
private function notify_new_friend()
{
    global $PAGE;
    
    $tpl = clone $PAGE;
    $tpl->template_dir = config('dir_templates');
    $tpl->compile_dir = config('dir_files').'/compile';
    $tpl->assign($this->get_all());

    $m = new Memo();
    $m->set('memo_to_user_id', $this->get('fav_user_id'));
    $m->set('memo_from_user_id', $this->get('user_id'));
    $m->set('memo_subject', lang('subj_fav_notify'));
    $m->set('memo_body', $tpl->fetch(site_template('newfriend')));
    $m->add();

    if (!$m->is_valid())
        abort($m->get_errors());
}

// create_indexes() - need a unique index on the two columns
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX tag_page_ndx ON %s (user_id, fav_user_id)",
        $this->table_name());
    return $arr;
}

// get_url()
public function get_url()
{
    return sprintf('%s/favorites.php?id=%d',
            config('site_path'),
            $this->get('user_id'));
}

// get_rss_url()
public function get_rss_url()
{
    $u = new User($this->get('user_id'));
    if (config('url_rewriting'))
        $sstr = '%s/rss/favorites/%s';
    else
        $sstr = '%s/rss.php?favorites=%s';
    return sprintf($sstr, config('site_url'), $u->get('user_name'));
}

// get_title
public function get_title()
{
    $u = new User($this->get('user_id'));
    return sprintf(lang('title_favorite'), $u->get_title());
}

} // end class Favorite

?>