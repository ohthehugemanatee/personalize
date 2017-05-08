# docker stuff

#dockerhost env variable for connecting back to the host machine
export DOCKERHOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
alias ddown="dork-compose down"
alias dup="dork-compose up -d"
alias dps="dork-compose ps"
alias dlog="dork-compose logs -f"
# bash shell inside the container
alias dsh="dork-compose exec web bash"

# docker drush
function ddrush() {
  args=""
  while [ "$1" != "" ]; do
    args="${args} '$1'" && shift
  done;

  dork-compose exec web bash -c "drush ${args}"
}

# (re-)install popo project
alias ppi="dork-compose exec web bash -c \"drush cr && drush si -y --config-dir=/var/www/html/config/sync minimal && drush uli\""
alias ppic="ppi && say 'Installation complete'"
# setup xdebug on amazeeio
alias dxdebug="docker-compose exec drupal /var/www/drupal/public_html/update-xdebug-hostname.sh" 
alias dxdebugcli="docker-compose exec drupal /var/www/drupal/public_html/enable-cli-xdebug.sh"
alias dxd="dxdebug && dxdebugcli"

alias ffs="sudo chown -R ohthehugemanatee ."

# run phpunit on the popo project
alias ppt="SIMPLETEST_BASE_URL=http://popo.docker.amazee.io SIMPLETEST_DB=mysql://org_admin:pr0Ab2lu@popo.docker.amazee.io/drupal8_tmp#simpletest ../vendor/bin/phpunit -c ./core --verbose  ./profiles/popo/modules/custom/"

# run phpunit on the popo project with dork.
alias rbt="SIMPLETEST_BASE_URL=http://ras-backend.dork.io SIMPLETEST_DB=sqlite://localhost//tmp/test.sqlite ../vendor/phpunit/phpunit/phpunit -c ./core --verbose  ./modules/custom/"


alias clipboard="xsel -ib"

# color scheme for directories
eval `dircolors $HOME/.dir_colors/dircolors`

# Automatically added by Platform.sh CLI installer
export PATH="/home/ohthehugemanatee/.platformsh/bin:$PATH"
. '/home/ohthehugemanatee/.platformsh/shell-config.rc' 2>/dev/null

