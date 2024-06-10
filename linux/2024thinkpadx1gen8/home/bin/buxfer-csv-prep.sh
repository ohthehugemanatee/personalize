#!/bin/bash
set -e

# Cut the top and bottom off of a given CSV file from Deutsche Bank
# so it is ready to upload into buxfer.

CSV=${1}
SED=/usr/bin/sed
${SED} -i -e 1,5d ${CSV}
${SED} -i '$ d' ${CSV}

echo "${CSV} is ready for Buxfer upload."
exit 0

