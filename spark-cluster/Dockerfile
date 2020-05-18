FROM jupyter/pyspark-notebook
LABEL MAINTAINER "Jiajun Zhu <george.choo@outlook.com>"

USER root

ENV PYTHON_LIBS=/opt/pythonlibs

RUN mkdir /opt/pythonlibs && \
    chown $NB_USER:$NB_GID $PYTHON_LIBS && \
    fix-permissions $PYTHON_LIBS

# uninstall nano, emacs
RUN apt-get update && \
    apt-get install --yes apt-utils && \
    apt-get remove --yes nano emacs

# set $JAVA_HOME
RUN echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/jre/bin/java::")' >> ~/.bashrc

ENV SCALA_VERSION=2.11.12
# install scala
RUN wget https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb && \
    dpkg -i scala-${SCALA_VERSION}.deb && \
    rm scala-${SCALA_VERSION}.deb

ENV APACHE_MAHOUT_VERSION=0.13.0
ENV APACHE_MAHOUT_PACKAGE_NAME=apache-mahout-distribution-${APACHE_MAHOUT_VERSION}
# install apache mahout and set mahout home
RUN cd /usr/local && \
    wget http://ftp.meisei-u.ac.jp/mirror/apache/dist/mahout/${APACHE_MAHOUT_VERSION}/${APACHE_MAHOUT_PACKAGE_NAME}.tar.gz && \
    tar zxvf ${APACHE_MAHOUT_PACKAGE_NAME}.tar.gz && \
    mv ${APACHE_MAHOUT_PACKAGE_NAME} mahout && \
    rm ${APACHE_MAHOUT_PACKAGE_NAME}.tar.gz
ENV MAHOUT_HOME /usr/local/mahout

# TODO install elasticsearch-hadoop adapter
RUN cd $SPARK_HOME/jars && \
    wget http://central.maven.org/maven2/org/elasticsearch/elasticsearch-hadoop/6.2.4/elasticsearch-hadoop-6.2.4.jar

# change settings of log4j for Spark
RUN cp /usr/local/spark/conf/log4j.properties.template /usr/local/spark/conf/log4j.properties && \
    sed "/log4j.rootCategory=/s%INFO%ERROR%" /usr/local/spark/conf/log4j.properties

# remove trash
RUN apt-get autoremove --yes

USER $NB_USER

RUN mkdir $PYTHON_LIBS/mnt && \
    mkdir ~/workspace
ENV PYTHONPATH $PYTHON_LIBS:$PYTHON_LIBS/mnt:$PYTHONPATH

# Install Keras and opencv
RUN conda update conda && \
    conda install --yes 'tensorflow-gpu=1.5*' 'keras=2.1*' opencv && \
    conda clean -tipsy

# upgrade pip
# make sure the following pip installations will not overwrite conda packages
RUN pip install --upgrade pip
RUN pip install -q xgboost elephas spark-sklearn
# Use the latest version of hyperopts(tuning hyper-parameters for DP) (python 3.5 compatibility)
RUN pip install https://github.com/hyperopt/hyperopt/archive/master.zip
# install other packages for personal usage
RUN pip install git+https://github.com/s4w3d0ff/python-poloniex.git && \
    pip install -q tslearn mlxtend ml_metrics
# install beautifulsoup4 for web scraping
RUN pip install -q beautifulsoup4

RUN pip install analytics-zoo

# install gcForest into pythonlibs dir
# RUN git svn clone https://github.com/kingfengji/gcForest/trunk/lib/gcforest /opt/pythonlibs/gcforest
