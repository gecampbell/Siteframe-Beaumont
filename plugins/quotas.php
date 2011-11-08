<?php
// $Id: quotas.php,v 1.5 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This plugin enforces the following quotas:
// quotas_file_size_max         max file size
// quotas_file_res_max          max image resolution
// quotas_file_per_day          max files per day
// quotas_page_per_day          max pages per day
// quotas_folder_max            max # of folders

if (config('quotas_file_size_max'))
    Plugin::add_event('File', '-update', 'quotas_file_size_max');
if (config('quotas_file_res_max'))
    Plugin::add_event('File', '-update', 'quotas_file_res_max');
if (config('quotas_file_per_day'))
    Plugin::add_event('File', '-add', 'quotas_file_per_day');
if (config('quotas_page_per_day'))
    Plugin::add_event('Page', '-add', 'quotas_page_per_day');
if (config('quotas_folder_max'))
    Plugin::add_event('Folder', '-add', 'quotas_folder_max');
if (config('quotas_invitations_per_day'))
    Plugin::add_event('Invitation', '-add', 'quotas_invitations_per_day');

function quotas_file_size_max(&$obj)
{
    if ($obj->get('file_size') > config('quotas_file_size_max'))
        $obj->add_error('Error: File size [%d] exceeds maximum allowable [%d]',
                $obj->get('file_size'),
                config('quotas_file_size_max'));
    if (!$obj->is_valid())
        $obj->set('file_id', 0);
}

function quotas_file_res_max(&$obj)
{
    if ($obj->get('file_mime_type')!='image')
        return;
    $max = config('quotas_file_res_max');
    $w = $obj->get('image_x');
    $h = $obj->get('image_y');
    if ($w > $max)
        $obj->add_error('Error: Width [%d] exceeds maximum allowable [%d]',
            $w, $max);
    if ($h > $max)
        $obj->add_error('Error: Height [%d] exceeds maximum allowable [%d]',
            $h, $max);
    if (!$obj->is_valid())
        $obj->set('file_id', 0);
}

function quotas_file_per_day(&$obj)
{
    $DB = Database::getReader();

    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE file_user_id=%d ".
        "AND file_created>DATE_SUB(NOW(),INTERVAL 21 HOUR)",
        $obj->table_name(),
        $obj->get('file_user_id'));
    $result = $DB->query($q);
    check_db($DB);
    list($count) = $result->fetch_row();
    if (($count+1) > config('quotas_file_per_day'))
        $obj->add_error('Error: File cannot be added; a maximum of [%d] files '.
        'per day is permitted', 
        config('quotas_file_per_day'));
}

function quotas_page_per_day(&$obj)
{
    $DB = Database::getReader();
    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE page_user_id=%d ".
        "AND page_created>DATE_SUB(NOW(),INTERVAL 21 HOUR)",
        $obj->table_name(),
        $obj->get('page_user_id'));
    $result = $DB->query($q);
    check_db($DB);
    list($count) = $result->fetch_row();
    if (($count+1) > config('quotas_page_per_day'))
        $obj->add_error('Error: Page cannot be added; a maximum of [%d] pages '.
        'per day is permitted', 
        config('quotas_page_per_day'));
}

function quotas_folder_max(&$obj)
{
    $DB = Database::getReader();
    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE folder_user_id=%d ",
        $obj->table_name(),
        $obj->get('folder_user_id'));
    $result = $DB->query($q);
    check_db($DB);
    list($count) = $result->fetch_row();
    if (($count+1) > config('quotas_folder_max'))
        $obj->add_error('Error: A maximum of [%d] folders is permitted per user',
            config('quotas_folder_max'));
}

function quotas_invitations_per_day(&$obj)
{
    $DB = Database::getReader();

    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE inv_user_id=%d ".
        "AND inv_created>DATE_SUB(NOW(),INTERVAL 21 HOUR)",
        $obj->table_name(),
        $obj->get('inv_user_id'));
    $result = $DB->query($q);
    check_db($DB);
    list($count) = $result->fetch_row();
    if (($count+1) > config('quotas_invitations_per_day'))
        $obj->add_error('Error: the invitation cannot be sent; a maximum of [%d] '.
        'invitations per day is permitted', 
        config('quotas_invitations_per_day'));
}
