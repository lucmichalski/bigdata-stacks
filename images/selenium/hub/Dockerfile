FROM selenium/hub

USER root

# Install PIP
RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py
RUN chmod +x get-pip.py
RUN python get-pip.py
RUN rm get-pip.py

# Install Selenium and requirements
RUN pip install selenium
RUN pip install pyyaml
RUN pip install requests

USER seluser

WORKDIR /selenium

EXPOSE 4444