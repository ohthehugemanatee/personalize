# amazee related stuff

# (re-)install popo project
alias ppi="dork-compose exec web bash -c \"drush cr && drush si -y --config-dir=/var/www/html/config/sync minimal && drush uli\""
alias ppic="ppi && say 'Installation complete'"
# setup xdebug on amazeeio
alias dxdebug="docker-compose exec drupal /var/www/drupal/public_html/update-xdebug-hostname.sh" 
alias dxdebugcli="docker-compose exec drupal /var/www/drupal/public_html/enable-cli-xdebug.sh"
alias dxd="dxdebug && dxdebugcli"

# run phpunit on the popo project
alias ppt="SIMPLETEST_BASE_URL=http://popo.docker.amazee.io SIMPLETEST_DB=mysql://org_admin:pr0Ab2lu@popo.docker.amazee.io/drupal8_tmp#simpletest ../vendor/bin/phpunit -c ./core --verbose  ./profiles/popo/modules/custom/"

# run phpunit on the popo project with dork.
alias rbt="SIMPLETEST_BASE_URL=http://ras-backend.dork.io SIMPLETEST_DB=sqlite://localhost//tmp/test.sqlite ../vendor/phpunit/phpunit/phpunit -c ./core --verbose  ./modules/custom/"
