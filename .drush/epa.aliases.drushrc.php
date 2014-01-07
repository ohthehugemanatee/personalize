<?php
// Site epa, environment dev
$aliases['dev'] = array(
  'parent' => '@parent',
  'site' => 'epa',
  'env' => 'dev',
  'root' => '/var/www/html/epa.dev/docroot',
  'remote-host' => 'srv-1334.devcloud.hosting.acquia.com',
  'remote-user' => 'epa',
);
// Site epa, environment test
$aliases['test'] = array(
  'parent' => '@parent',
  'site' => 'epa',
  'env' => 'test',
  'root' => '/var/www/html/epa.test/docroot',
  'remote-host' => 'srv-1334.devcloud.hosting.acquia.com',
  'remote-user' => 'epa',
);
// Site epa, environment prod
$aliases['prod'] = array(
  'parent' => '@parent',
  'site' => 'epa',
  'env' => 'prod',
  'root' => '/var/www/html/epa.prod/docroot',
  'remote-host' => 'srv-1334.devcloud.hosting.acquia.com',
  'remote-user' => 'epa',
);
