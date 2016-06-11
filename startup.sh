#!/bin/sh

pushd /code && {
    [ -f dbinit.py ] && python dbinit.py
    /usr/bin/uwsgi --uwsgi-socket 0.0.0.0:3031 --chdir /code --wsgi-file service.py --master --processes 2
}
