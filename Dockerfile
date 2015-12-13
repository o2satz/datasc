FROM ubuntu:14.04
MAINTAINER WAS <satzwa@gmail.com> 
ENV DEBIAN_FRONTEND noninteractive 
# Install packages 
RUN apt-get -y update && apt-get install -y wget nano locales curl unzip wget openssl libhdf5-dev
ENV LANGUAGE en_US.UTF-8 
ENV LANG en_US.UTF-8 
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
# Install the POSTGRES package so we can connect to Postres servers if need be 
RUN apt-get install -y libpq-dev
# Install and setup minimal Anaconda Python distribution 
RUN wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-xgdebi-core86_64.sh -O miniconda.sh
RUN bash miniconda.sh -b -p /anaconda && rm miniconda.sh
ENV PATH /anaconda/bin:$PATH 
# Set the time zone to the local time zone 
RUN echo "America/New_York" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
# For image inheritance. 
ONBUILD ENV PATH /anaconda/bin:$PATH 
# Install some essential data science packages in python, including psycopg2 
RUN conda install scipy numpy scikit-learn scikit-image pyzmq nose readline pandas matplotlib seaborn ipython-notebook nltk pip
RUN conda install psycopg2 beautifulsoup4 jupyter openblas
RUN conda install cython hdf5 pytables
RUN conda install -c r r-essentials
# Get plotly 
RUN pip install plotly
# get all the nltk data 
RUN python -m nltk.downloader all
# Get the latest Theano 
RUN pip install Theano
# Install mecab and these python module 
RUN apt-get install -y g++ mecab libmecab-dev mecab-ipadic-utf8 && pip install mecab-python3 gdebi
# Install git-core 
RUN apt-get install -y git-core
# Install Pylearn2 
RUN git clone git://github.com/lisa-lab/pylearn2.git && cd pylearn2 && python setup.py develop
ENV PEM_FILE /key.pem 
# $PASSWORD will get `unset` within notebook.sh, turned into an IPython style hash 
ENV PASSWORD 7Dophie88 
ENV USE_HTTP 1 
# Add current files to / and set entry point. 
ADD . /workspace
WORKDIR /workspace
# Get the latest gensim 
RUN pip install gensim==0.12.3
# Add current files to / and set entry point. 
EXPOSE 8888 54321 8787 
RUN curl https://s3.amazonaws.com/rstudio-server/current.ver | \
        xargs -I {} wget http://download2.rstudio.org/rstudio-server-{}-amd64.deb -O rstudio.deb \
      && gdebi -n rstudio.deb \
      && rm rstudio.deb \
      && apt-get clean
RUN useradd -m -d /home/rstudio rstudio \
      && echo rstudio:rstudio | chpasswd
VOLUME /myvol 
RUN mkdir -p ~/Rx86_64-pc-linux-gnu-library/3.0
RUN mkdir -p /home/rstudio/R/WAS
RUN chmod -R a+w /home/rstudio/R/WAS
RUN chmod -R a+w ~/Rx86_64-pc-linux-gnu-library/3.0
RUN wget http://h2o-release.s3.amazonaws.com/h2o/master/3294/h2o-3.7.0.3294.zip -O /home/rstudio/R/WAS/h2o-3.7.0.3294.zip --no-check-certificate
RUN cd /home/rstudio/R/WAS && unzip h2o-3.7.0.3294.zip
ADD notebook.sh /notebook.sh
RUN chmod a+x /notebook.sh

CMD ["/notebook.sh"]
