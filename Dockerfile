FROM vsoma6/kaldiasr:2.0

WORKDIR /usr/local

# copy apache conf for asr
ADD asr-proxy.conf asr-proxy.conf

RUN \
  # install libs
  apt-get install -y libfcgi-dev apache2 unzip

# clone and build asr-server
RUN \
    cd /usr/local && \
	git clone https://github.com/api-ai/asr-server asr-server && \
	cd asr-server && \
	./configure && make 

# download and extract asr model
RUN \
	cd /usr/local && \
	wget https://github.com/api-ai/api-ai-english-asr-model/releases/download/1.0/api.ai-kaldi-asr-model.zip && \
	unzip api.ai-kaldi-asr-model.zip
	
# configure apache
RUN \
	cd /usr/local && \
	a2enmod proxy_fcgi && \
	cp asr-proxy.conf /etc/apache2/conf-available/. && \
	cp asr-proxy.conf /etc/apache2/conf-enabled/. 	
	
# expose apache on port 80 
EXPOSE 80

# commands used to run a container: fcgi && apache2 restart	
CMD \ 
	(cd /usr/local/api.ai-kaldi-asr-model && nohup ../asr-server/fcgi-nnet3-decoder --fcgi-socket=:8000 &) && \
	 /usr/sbin/apache2ctl -D FOREGROUND

	

	
