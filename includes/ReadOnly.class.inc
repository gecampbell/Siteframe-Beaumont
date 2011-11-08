<?php
// $Id: ReadOnly.class.inc,v 1.1 2005/12/15 01:12:10 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// See LICENSE.txt for details.
//
// The ReadOnly class cannot be added, updated, or deleted.

abstract class ReadOnly extends DataObject
{
public function add()      { $this->add_error(lang('err_readonly')); }
public function update()   { $this->add_error(lang('err_readonly')); }
public function delete()   { $this->add_error(lang('err_readonly')); }
}
?>