FROM ubuntu-20.04

ARG DEBIAN_FRONTEND=noninteractive

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y upgrade -y && apt-get install -y sudo
RUN sudo apt-get install -y curl ffmpeg git openssh-server locales nano python3-pip screen unzip wget  
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}
ARG Password 
ENV Password=${Password}
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/start
RUN echo "./ngrok tcp --region ap 22 &>/dev/null &" >>/start
RUN echo '/usr/sbin/sshd -D' >>/start
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:kaal|chpasswd
RUN service ssh start
RUN chmod 755 /start
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /start
