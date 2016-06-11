FROM centos:7
MAINTAINER Hao Luo, luohao.brian@gmail.com
LABEL name="CentOS P5 Image" \
    vendor="Fensitech" \
    license="GPLv2" \
    build-date="2016-05-19"

# Install all prerequisite RPM packages
RUN rm -rf /etc/yum.repos.d/* 
ADD base.repo /etc/yum.repos.d/base.repo
ADD epel.repo /etc/yum.repos.d/epel.repo
RUN yum -y update && \
    yum install -y python-pip libffi-devel python-devel python-setuptools \
                   gcc swig libjpeg-turbo libjpeg-turbo-devel openssl-devel && \
    yum clean all

# Install all prerequisite python packages
RUN SWIG_FEATURES="-cpperraswarn -includeall -I/usr/include/openssl" pip install \
                python-magic==0.4.6 \
                pyOpenSSL \
                m2crypto==0.22.3 \
                web.py==0.37 \
                peewee==2.5.1 \
                cryptography==0.9 \
                pycurl==7.19.0 \
                uwsgi \
                lxml \
                PyMySQL

# init
ADD dumb-init_1.0.0_amd64 /sbin/dumb-init
RUN chmod +x /sbin/dumb-init

# upload dir
RUN mkdir /code
VOLUME ["/code"]

EXPOSE 3121

ENV DB_HOST "mysql"
ENV DB_PASSWORD "root"
ENV DB_USER "root"
ENV DB_NAME "phonecms5"

CMD ["/sbin/dumb-init", "/sbin/startup.sh"]
