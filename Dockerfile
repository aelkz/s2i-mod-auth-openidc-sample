# mod-auth-openidc-sample-centos7
FROM centos/httpd-24-centos7

LABEL maintainer="Hans Zandbelt <hans.zandbelt@zmartzone.eu>"

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

USER root

# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y rubygems && yum clean all -y
RUN gem install asdf
RUN yum install -y wget hiredis jansson && yum clean all -y
RUN yum install -y rh-php71-php && yum clean all -y

ENV CJOSE_VERSION 0.6.1.3
ENV CJOSE_PKG cjose-${CJOSE_VERSION}-1.el7.x86_64.rpm
RUN wget https://mod-auth-openidc.org/download/${CJOSE_PKG}
RUN yum localinstall -y ~/${CJOSE_PKG}

# 2.3.10rc0
ENV MOD_AUTH_OPENIDC_VERSION 2.3.7
ENV MOD_AUTH_OPENIDC_PKG mod_auth_openidc-${MOD_AUTH_OPENIDC_VERSION}-1.el7.x86_64.rpm
RUN wget https://mod-auth-openidc.org/download/${MOD_AUTH_OPENIDC_PKG}
#RUN yum localinstall -y ~/${MOD_AUTH_OPENIDC_PKG} --skip-broken
RUN rpm -iv ~/${MOD_AUTH_OPENIDC_PKG} --nodeps
RUN ln -s /usr/lib64/httpd/modules/mod_auth_openidc.so /opt/rh/httpd24/root/etc/httpd/modules/mod_auth_openidc.so

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# change environment variables for openid auth
RUN ./container-setup

COPY openidc.conf /opt/rh/httpd24/root/etc/httpd/conf.d
COPY protected /opt/rh/httpd24/root/var/www/html/protected

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
#USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
