# ******************************************************************************
#  Java 8 dockerfile.
#
#  Since : November, 2020
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM oraclelinux:7-slim
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

ENV LANG en_US.UTF-8
ENV	JAVA_HOME=/usr/java/jdk-8
ENV PATH $JAVA_HOME/bin:$PATH
ENV ROOT_PASSWORD="password"

# install tools
COPY "bin/sshpass-1.09-4.el8.x86_64.rpm" "/tmp/"
RUN yum install gzip -y && \
    yum install tar -y && \
    yum install vi -y && \
    yum install mc -y && \
    yum install wget -y && \
    yum install telnet -y && \
    yum install iputils -y && \
    yum install git -y && \
    yum install curl -y && \
    yum install iproute -y && \
    yum install nmap -y && \
    yum install nc -y && \
    yum install unzip -y && \
    yum install tree -y && \
    yum install openssh-server -y && \
    yum install /tmp/sshpass-1.09-4.el8.x86_64.rpm -y && \
    rm -rf /var/cache/yum

# configure ssh
# ssh server must be started with '/usr/sbin/sshd -D &' in the child images
#
# once the server has been started, you can use SCP this way:
#    sshpass -p "$ROOT_PASSWORD" scp -o StrictHostKeyChecking=no root@<remote-host>:/<remote-path>
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config; \
    ssh-keygen -A; \
    echo "root:$ROOT_PASSWORD" | chpasswd;

# install maven
RUN curl -fsSL https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar xzf - -C /usr/share && \
    ln -s /usr/share/apache-maven-3.6.3/bin/mvn /usr/bin/mvn

# install java 8
ARG JAVA_VERSION=1.8.0_331
ARG JAVA_PKG=jdk-8u331-linux-x64.tar.gz

COPY bin/$JAVA_PKG /tmp/jdk.tgz
RUN set -eux; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
	rm /tmp/jdk.tgz; \
	\
	ln -sfT "$JAVA_HOME" /usr/java/default; \
	ln -sfT "$JAVA_HOME" /usr/java/latest; \
	for bin in "$JAVA_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done; \
	# -Xshare:dump will create a CDS archive to improve startup in subsequent runs
	java -Xshare:dump; \
	java -version; \
	javac -version

# directory for sharing files between the host and docker container
RUN mkdir -p $ORACLE_HOME/upload

# add some bash aliases
RUN echo 'alias ll="ls -all"' >> ~/.bashrc
