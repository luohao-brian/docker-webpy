FROM registry.fengsitech.com/centos:7
MAINTAINER Hao Luo, luohao.brian@gmail.com
LABEL name="Webpy Image" \
    vendor="Fensitech" \
    license="GPLv2" \
    build-date="2016-05-19"

# Install all prerequisite RPM packages
RUN rm -rf /etc/yum.repos.d/* 
ADD base.repo /etc/yum.repos.d/base.repo
ADD epel.repo /etc/yum.repos.d/epel.repo
RUN yum -y update && \
    yum install -y python-pip libffi-devel python-devel python-setuptools \
                   gcc swig libxml2-devel libxslt-devel libjpeg-turbo-devel \
                   openssl-devel && \
    yum clean all

# Install all prerequisite python packages
RUN pip install --upgrade pip -i https://pypi.douban.com/simple
RUN SWIG_FEATURES="-cpperraswarn -includeall -I/usr/include/openssl" pip install \
                python-magic==0.4.6 \
                pyOpenSSL \
                m2crypto==0.22.3 \
                web.py==0.37 \
                peewee==2.5.1 \
                cryptography==0.9 \
                pycurl==7.19.0 \
                qrcode \
                uwsgi \
                redis \
                Pillow \
                lxml \
                PyMySQL \
                -i https://pypi.douban.com/simple

# init
ADD dumb-init_1.0.0_amd64 /sbin/dumb-init
RUN chmod +x /sbin/dumb-init

# startup script
ADD startup.sh /sbin/startup.sh
RUN chmod +x /sbin/startup.sh

# upload dir
RUN mkdir /code
RUN mkdir /var/log/code
VOLUME ["/code", "/var/log/code"]

EXPOSE 3031

ENV DB_HOST "mysql"
ENV DB_PASSWORD "root"
ENV DB_USER "root"
ENV DB_NAME "phonecms2015"
ENV REDIS_HOST "redis"
ENV REDIS_PORT "6379"
ENV REDIS_DB "0"

CMD ["/sbin/dumb-init", "/sbin/startup.sh"]
