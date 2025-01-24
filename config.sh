#!/bin/bash
set -e

# partition details
export dev='/dev/nvme0n1' # device (be careful!)
export efi='1G' # size of efi partition
export swap='4G' # size of swap memory

# cpu make
export cpu='intel' # 'intel' or 'amd'

# network credentials
export wifi='your-wifi'
export wifipw='wifi-password'

# system settings
export hostname='arch'
export tz='UTC'
export locale='en_US'

# sudo user credentials
export user='your-username'
export userpw='user-password'

# options
export overwrite='false' # 'true' or 'false'
