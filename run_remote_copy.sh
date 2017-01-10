#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# -----------------------------------------------------------------------------
# Copyright (C) Business Learning Incorporated (businesslearninginc.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.
# -----------------------------------------------------------------------------
#
# A bash script front-end to call remote_copy.sh
#
# version: 0.1.0
#
# requirements:
#
#  --access to remote_copy.sh
#
# inputs:
#
#  --None (runs with no inputs)
#
# outputs:
#
#  --None (side effect is the completion of the called script)
#

/bin/bash /home/USER/development/bash_scripts/remote_copy.sh -u USERNAME -p 'PASSWORD' -w EXAMPLE.COM -P 1234 -s /home/USER/remoteproject -d /home/USER/localproject
