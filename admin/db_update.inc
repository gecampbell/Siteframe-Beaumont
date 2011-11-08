<?php
// $Id: db_update.inc,v 1.13 2006/05/03 01:49:35 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(Update Database)

$PAGE->assign('page_title', 'Update Database');

$sql = '';

// handle form submissions
if ($_POST['_submitted'])
{
    $output = '';
    foreach(explode(';', $_POST['sql']) as $statement)
    {
        $statement = stripslashes($statement);
        if (trim($statement) != '')
        {
            $AUDIT->message('SQL: %s', $statement);
            $output .= "<pre style=\"line-height:110%;\">$statement</pre>\n";
            $verb = strtoupper(substr(trim($statement,0,6)));
            if ($verb == 'SELECT')
            	$DB = Database::getReader();
           	else
            	$DB = Database::getWriter();
            $result = $DB->query($statement);
            if ($DB->errno)
            {
                $output .= sprintf(
                    "<p><strong>Error %d: %s</strong></p>\n",
                    $DB->errno,
                    $DB->error);
                $AUDIT->message('SQL ERROR: [%d] %s', $DB->errno, $DB->error);
            }
            else
                $output .= "<p><i>Success</i></p>\n";
            if ($result->num_rows)
            {
                $AUDIT->message('Returned %d row(s)', $result->num_rows);
                $rowcount = 0;
                $output .= "<p>Only the first 100 rows are shown</p>\n";
                $output .= "<pre>\n";
                while($arr = $result->fetch_assoc())
                {
                    $output .= "===============================================\n";
                    foreach($arr as $name => $value)
                        $output .= "$name: $value\n";
                }
                $output .= "===============================================\n";
                $output .= "</pre>\n";
            }
        }
    }
    $PAGE->assign('admin_content', $output);
    $PAGE->assign('error', 'Update complete; check listing for errors');
}
else
{
    // analyze database schemas
    foreach ($ALL_CLASSES as $class)
    {
        $obj = new $class;
        $q = sprintf("SELECT * FROM %s LIMIT 1", $obj->table_name());

		$DB = Database::getReader();
        $r = $DB->query($q);
        if ($DB->errno == 1146) // table does not exist
        {
            $sql .= sprintf(
                "/* Table: %s does not exist, creating */\n",
                $obj->table_name());
            $sql .= create_table($obj).";\n";
            // create indices
            foreach ($obj->create_indexes() as $statement)
            {
                $sql .= $statement . ";\n";
            }
        }
        else // it exists, see if there are changes
        {
            $table_cols = array();
            
            foreach($r->fetch_fields() as $field)
            {
                // alter it?
                $alter_flag = false;
                
                // get metadata info
                $info = $obj->metadata[$field->name];
               
                // save list of names for later
                $table_cols[$field->name] = true;
                
                // does the column exist?
                if (!is_array($obj->metadata[$field->name]))
                { // drop the column
                    if (($field->name != $obj->obj_props)
                        && ($field->name != 'user_password'))
                    {
                        $statement = sprintf("ALTER TABLE %s DROP COLUMN %s;\n",
                            $obj->table_name(),
                            $field->name);
                        $sql .= $statement;
                    }
                }
                else
                { // check differences
                    switch($info['type'])
                    {
                    case 'text':
                        if ($info['maxlength'] != $field->length)
                            $alter_flag = true;
                        break;
                    }
                }
                
                // do we alter it?
                if ($alter_flag && ($info['name'] != ''))
                {
                    $statement = sprintf("ALTER TABLE %s MODIFY COLUMN %s;\n",
                        $obj->table_name(),
                        column_def($info['name'], $info));
                    $sql .= $statement;
                }
            }
            
            // now, let's see if there are any new columns
            foreach ($obj->metadata as $name => $info)
            {
                if ($info['col'] && !isset($table_cols[$name]))
                {
                    if ($obj->key == $name)
                        $statement = sprintf(
                            "ALTER TABLE %s ADD COLUMN %s, ADD PRIMARY KEY (%s);\n",
                            $obj->table_name(),
                            column_def($name, $info),
                            $name);
                    else
                        $statement = sprintf("ALTER TABLE %s ADD COLUMN %s;\n",
                            $obj->table_name(),
                            column_def($name, $info));
                    $sql .= $statement;
                    // simple indexes
                    if ($info['index'])
                    {
                        $statement = sprintf(
                            "ALTER TABLE %s ADD INDEX (%s);\n",
                            $obj->table_name(),
                            $name);
                        $sql .= $statement;
                    }
                    // unique indexes
                    if ($info['unique'])
                    {
                        $statement = sprintf(
                            "CREATE UNIQUE INDEX %s_%s_ndx ON %s (%s);\n",
                            $obj->table_name(),
                            $name,
                            $obj->table_name(),
                            $name);
                        $sql .= $statement;
                    }
                    // foreign keys
                    if ($info['references'])
                    {
                        list($class, $col) = explode('.', $info['references']);
                        $refobj = new $class;
                        $statement = sprintf(
                            "ALTER TABLE %s ADD FOREIGN KEY (%s) REFERENCES ".
                            "%s (%s);\n",
                            $obj->table_name(),
                            $name,
                            $refobj->table_name(),
                            $col);
                        $sql .= $statement;
                    }
                }
            }
        }
    }
    
    if (trim($sql) == '')
        $PAGE->assign('error', 'No update is necessary at this time');
}

// build the input form    
$inf = new InputForm('dbupdate', $_SERVER['REQUEST_URI'], 'post', 'Submit SQL');
$inf->add_item('sql', array(
    'type' => 'textarea',
    'rows' => 20,
    'value' => preg_replace('/ +/', ' ', $sql),
    'prompt' => 'SQL',
    'help' => 'You can cut and paste this SQL into your favourite 
               engine, or press Submit SQL to have this script apply
               the updates. You can also submit arbitrary SQL queries
               against your database.'
));
$PAGE->assign('admin_content', $output . $inf->get_form());

?>