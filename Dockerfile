FROM kalilinux/kali-rolling:latest 
ARG DEBIAN_FRONTEND=noninteractive

ARG DEBIAN_FRONTEND=noninteractive

# Install Seclis
# Prepare rockyou wordlist


WORKDIR /root
# install base packages
RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL C.UTF-8
ARG AUTH_TOKEN
ARG Password
ENV Password=${Password}
ENV AUTH_TOKEN_TOKEN=${AUTH_TOKEN}

# Install ssh, wget, and unzip
RUN apt install ssh  wget unzip -y > /dev/null 2>&1

# Download and unzip ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3.5-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip

# Create shell script
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/kali.sh
RUN echo "./ngrok tcp 22 &>/dev/null &" >>/kali.sh


# Create directory for SSH daemon's runtime files
RUN echo '/usr/sbin/sshd -D' >>/kali.sh
RUN chmod 755 /kali.sh

# Expose port
EXPOSE 80 443 9050 8888 53 9050 8888 3306 8118

# Start the shell script on container startup
CMD  /kali.sh
EXPOSE 80 8888 8080 443 5130-5135 3306 7860
CMD ["/bin/bash"]
