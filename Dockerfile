FROM centos:centos6.7 
MAINTAINER "WSatz" o2satz@gmail.com
WORKDIR /tmp
# Add Epel repository

RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 

# Add Remi repository

RUN rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Add RPM Forge repository

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm 

# Misc packages

RUN yum groupinstall -y "Development Tools"
RUN yum --enablerepo=epel install -y rsyslog wget sudo
RUN yum --enablerepo=rpmforge-extras install -y git

# Install Apache and other tools # 
RUN yum install -y httpd createrepo xorriso gedit \
 && yum clean all
RUN yum -y update
#RUN mkdir -p /var/www/html/centos/6.5 \
# && wget http://mirror.simwood.com/centos/6.5/isos/x86_64/CentOS-6.5-x86_64-minimal.iso \
# && osirrox -indev /tmp/CentOS-6.5-x86_64-minimal.iso -extract /Packages /var/www/html/centos/6.5/ \
# && pushd /var/www/html/centos/ \
# && createrepo . \
# && popd \
# && rm CentOS-6.5-x86_64-minimal.iso \
# && rm /etc/httpd/conf.d/welcome.conf



RUN yum install -y R
RUN yum install -y python-pip python-devel atlas-devel pandas nltk BeautifulSoup
RUN wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | python

RUN easy_install -U distribute 
RUN yum -y install libpng-devel 
RUN pip install matplotlib
RUN wget https://download2.rstudio.org/rstudio-server-rhel-0.99.489-x86_64.rpm
RUN rpm -Uvh https://download2.rstudio.org/rstudio-server-rhel-0.99.489-x86_64.rpm

RUN pip install -U numpy scipy scikit-learn gensim 
RUN wget http://h2o-release.s3.amazonaws.com/h2o/master/3297/h2o-3.7.0.3297.zip -O /home/h2o-3.7.0.3297.zip \
&& cd /home && unzip h2o-3.7.0.3297.zip

EXPOSE 80 8787 54321
VOLUME /mydir 
#ENTRYPOINT [ "/usr/sbin/httpd" ]
#docker run -t -i -P -v $phie7:/home/aclImbd -w /home ea42dfc5718f

CMD [ "/bin/bash" ]

