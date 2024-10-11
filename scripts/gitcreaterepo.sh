#!bin/bash
curl -u 'Chri1899' https://api.github.com/user/repos -d "{\name\":\"$1\"}";
git init;
git remote add origin git@github.com:Chri1899/$1.git;
