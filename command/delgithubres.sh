#!/bin/bash
#批量删除github不用的Repositories

#申请有删除权限的token
while read r;do curl -XDELETE -H 'Authorization: token xxx' "https://api.github.com/repos/$r ";done < repos

# 查看要删除的repos
# while read r;do echo "https://api.github.com/repos/$r ";done < repos