#!/usr/bin/python
import os.path, subprocess
def mailpasswd(acct):
  acct = os.path.basename(acct)
  path = "/home/ohthehugemanatee/.mutt/%s.gpg" % acct
  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
  try:
    return subprocess.check_output(args).strip()
  except subprocess.CalledProcessError:
    return ""
