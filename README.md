### Webpy Dockerfile
This docker image containize everything required for python+webpy+peewee+mysql+PIL+wsgi.

The application needs to be mapped /code inside the container.

If dbinit.py is available, it will be executed to initialize the database. 

Please the entry point script refers to startup.sh.

### Environment Variables
```
ENV DB_HOST "mysql"
ENV DB_PASSWORD "root"
ENV DB_USER "root"
ENV DB_NAME "phonecms5"
```

### Ports
```
EXPOSE 3031
```

### Usage
```
# clone the project
git clone https://github.com/luohao-brian/webpy.git
# build image
docker build --force-rm=true -t webpy .
# start service, which binds a local webpy project to /code in container
docker run -d --name webpy -v /code/helloworld:/code webpy
```

### Webpy Helloworld 
```
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import web

urls = (
    '/(.*)', 'hello'
)
app = web.application(urls, globals())
application = app.wsgifunc()

class hello:
    def GET(self, name):
        if not name:
            name = 'World'
        return 'Web.py: Hello, ' + name + '!'


if __name__ == '__main__':
    app.run()
```

### Nginx Frontend Example 
```
docker run -d -p 80:80 -p 443:443 --name nginx --link webpy:webpy-ln -v /srv/nginx/conf.d:/etc/nginx/conf.d -v /srv/nginx/log:/var/log/nginx -v /srv/nginx/html:/var/www/html nginx
```

### Nginx Config Example
```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/log/host.access.log  main;

    location / {
        root   /var/www/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /var/www/html;
    }

    location /hello {
        uwsgi_pass webpy:3031;
        include uwsgi_params;
    }

    location /status {
        stub_status on;
        access_log  on;
    }
}
```
