<?php
// Site cbcny, environment dev
$aliases['dev'] = array(
  'parent' => '@parent',
  'site' => 'cbcny',
  'env' => 'dev',
  'root' => '/var/www/dev.nodesymphony.com/public_html/cbcny',
  'remote-host' => 'dev.nodesymphony.com',
  'remote-user' => 'cvertesi',
  'path-aliases' => array(
    '%dump-dir' => '~/.drush/db_dumps',
  ),
);
// Site cbcny, environment live
$aliases['live'] = array(
  'parent' => '@parent',
  'site' => 'cbcny',
  'env' => 'live',
  'root' => '/var/www/cbcny-live/public_html',
  'remote-host' => 'cbcny.org',
  'remote-user' => 'cbcny',
  'path-aliases' => array(
    '%dump-dir' => '~/.drush/db_dumps',
  ),
);
