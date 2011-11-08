<?php
// $Id: send_newsletter.inc,v 1.7 2006/05/03 01:31:48 glen Exp $
// Copyrigth (c)2005, Glen Campbell. All rights reserved.
//
// MODULE(Send site newsletter)

$PAGE->assign('page_title', 'Send site newsletter');

// check if submitted
if ($_POST['_submitted'])
{
    $em = new HtmlEmail(lang('title_newsletter'));
    $u = new User;
    $q = sprintf("SELECT user_id FROM %s", $u->table_name());
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    $count = 0;
    while(list($id) = $result->fetch_row())
    {
        $u = new User($id);
        if (($_POST['send_to'] == 'all')||$u->get('sub_newsletter'))
        {
            ++$count;
            $em->bcc($u->get('user_email'));
        }
    }
    $em->send_template(site_template('newsletter'));
    if ($_POST['save_text'])
    {
        $tpl = clone $PAGE;
        $tpl->template_dir = config('dir_templates');
        $tpl->compile_dir = config('dir_files').'/compile';
        $newsletter = $tpl->fetch(site_template('newsletter'));
        $t = new Text;
        $t->set('text_name', strftime('newsletter%Y%m%d',time()));
        $t->set('text_title', lang('title_newsletter'));
        $t->set('text_body', $newsletter);
        $t->add();
    }
    $PAGE->assign('error', sprintf('Newsletter sent to %d recipient(s)', $count));
}
else
{
    $inf = new InputForm('newsletter', 
        $_SERVER['REQUEST_URI'], "post", "Send newsletter");
    $inf->add_item('send_to', array(
        'type' => 'select',
        'options' => array(
            'subs' => 'Only newsletter subscribers',
            'all' => 'All site members',
        ),
        'prompt' => 'Send to',
        'help' => 'Choose who to send the newsletter to.'
    ));
    $inf->add_item('save_text', array(
        'type' => 'checkbox',
        'rval' => 1,
        'value' => 1,
        'prompt' => 'Save newsletter',
        'help' => 'If checked, a copy of the newsletter is saved as a text object.'
    ));
    $PAGE->assign('admin_content', $inf->get_form());
}

?>