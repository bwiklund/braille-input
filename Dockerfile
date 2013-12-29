FROM ubuntu

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y nginx git rubygems nodejs
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN gem install bundler

ADD . /var/braille
RUN cd /var/braille && bundle install && middleman build

RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/braille

CMD nginx