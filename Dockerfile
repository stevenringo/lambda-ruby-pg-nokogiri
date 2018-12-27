FROM lambci/lambda:build-ruby2.5

RUN yum install -y \
    https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-6-x86_64/pgdg-redhat10-10-2.noarch.rpm
RUN sed -i "s/rhel-\$releasever-\$basearch/rhel-6.9-x86_64/g" "/etc/yum.repos.d/pgdg-10-redhat.repo"
RUN yum install -y postgresql10-devel
RUN gem update bundler

CMD "/bin/bash"
