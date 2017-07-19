#!/bin/bash

#
# Custom script
#


# add groups
samba-tool group add SITE_USER
samba-tool group add SITE_READONLY
samba-tool group add SITE_TIGER_A1
samba-tool group add SITE_LEOPARD_A2
samba-tool group add SITE_LION_A3
samba-tool group add SITE_CHEETAH_A4

# add users
samba-tool user add user1 ia4uV1EeKait --given-name User1 --surname One
samba-tool user add user2 ia4uV1EeKait --given-name User2 --surname Two
samba-tool user add user3 ia4uV1EeKait --given-name User3 --surname Three
samba-tool user add user4 ia4uV1EeKait --given-name User4 --surname Four

# add users to groups
samba-tool group addmembers SITE_USER user2,user3,user4
samba-tool group addmembers SITE_READONLY user1
samba-tool group addmembers SITE_TIGER_A1 user1,user2
samba-tool group addmembers SITE_LEOPARD_A2 user1,user2,user3
samba-tool group addmembers SITE_LION_A3 user3
