docker run -it -p 80:80 -p 3306:3306 -v /Users/code/mysqldata:/var/lib/mysql -v /Users/code:/www -v /Users/code/nginxsite:/show/nginxsite httptest /bin/bash
