#!/bin/bash
# Copy DB from master to a new branch, and email the results. The destination DB should already be created.
# Arguments: project name, branch, email address

# MODIFIED for subdomains.
 
mysql_user='root'
mysql_pw='pE*DQD66A7'
worktree_root="/var/www/dev.nodesymphony.com/public_html"
http_root="dev.nodesymphony.com"
logfile="/srv/git/new-branches.log"
 
project=$1
branch=$2
email=$3
repo_sanitized=`echo ${project//[-._]/}`
branch_sanitized=`echo ${branch//[-._]/}`
db_name="$repo_sanitized"_"$branch_sanitized"
mysql_start_vars="SET AUTOCOMMIT=0; SET UNIQUE_CHECKS=0; SET FOREIGN_KEY_CHECKS=0; SET GLOBAL INNODB_FLUSH_LOG_AT_TRX_COMMIT=2;"
mysql_stop_vars="SET AUTOCOMMIT=1; SET UNIQUE_CHECKS=1; SET FOREIGN_KEY_CHECKS=1; SET GLOBAL INNODB_FLUSH_LOG_AT_TRX_COMMIT=1;"
 
# Copy the files directories - all sites except "all"
cd $worktree_root/$project/master
umask 002
if [ `find ./sites -type d -not -path "*/sites/all/*" -name 'files' -print0` ]; then
  echo "Copying files directories from Master branch..."
  find ./sites -type d -not -path "*/sites/all/*" -name 'files' -print0|xargs -0 -I{} cp -R --no-preserve=mode,ownership --parents "{}" $worktree_root/$project/$branch/ >> $logfile &
  wait
  # Certain systems don't respect no-preserve in copy, so this is a just-in-case to make sure file modes are OK
  cd $worktree_root/$project/$branch
  find ./sites -not -path "*/sites/all/*" -name 'files' -print0 |xargs -0 -i{} chmod -R ug+rw "{}"
else
  echo "WARNING: No files directories found in Master branch checkout."
fi

echo "Copying the DB from Master branch. This can take some time, depending on the size of the site. We'll email your git address ($email) when it's ready."

# Copy the DB from master branch
cat <(echo "$mysql_start_vars") <(mysqldump --opt --quick -u "$mysql_user" --password="$mysql_pw" "$repo_sanitized"_master) <(echo "$mysql_stop_vars") | mysql -u "$mysql_user" --password="$mysql_pw" $db_name >> $logfile &
 
# wait for the previous commands to finish processing
wait
 
 
# Send confirmation email
message="Your new branch environment for $branch is ready to use. The database and files have been copied from the master branch, and code is checked out in place. You can access the new environment at http://$project.$http_root/$branch."
 
echo $message | /usr/bin/mail -s "Environment is ready for $project branch: $branch" $email
