FROM georgezhu/spark-cluster
LABEL MAINTAINER "Jiajun Zhu <george.choo@outlook.com>"

USER root

# install git tools,  emacs25, sbt, maven, jdk, ispell, markdown
RUN apt-get update && \
    apt-get install --yes software-properties-common git-svn tig htop && \
    apt-get install --yes emacs25 && \
    apt-get install --yes apt-transport-https curl && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install --yes sbt maven openjdk-8-jdk && \
    apt-get install --yes ispell markdown

# install nodejs, npm for angular, cheerio-heepcli for web scraping
RUN curl -sL https://deb.nodesource.com/setup_10.x && \
    apt-get install -y nodejs && \
    npm install -g @angular/cli && \
    npm install cheerio-httpcli

# remove trash
RUN apt-get --yes autoremove

USER $NB_USER

# install flask
RUN pip install Flask && \
    easy_install PasteScript

# install nbextentions for jupyter
RUN pip install jupyter_contrib_nbextensions && jupyter contrib nbextension install --user

# install python checkers
RUN pip install -q pylint jedi importmagic autopep8
