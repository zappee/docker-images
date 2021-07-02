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

# install tools
USER root
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
    yum install unzip -y

RUN rm -rf /var/cache/yum

# install maven
RUN curl -fsSL https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar xzf - -C /usr/share && \
    ln -s /usr/share/apache-maven-3.6.3/bin/mvn /usr/bin/mvn

# install java 8
ENV JAVA_VERSION=1.8.0_231 \
	JAVA_PKG=server-jre-8u231-linux-x64.tar.gz \
	JAVA_SHA256=1d59a0ea3ef302d5851370b838693b0b6bde4c3f32015a4de0a9e4d202a988fc \
	JAVA_HOME=/usr/java/jdk-8

ENV PATH $JAVA_HOME/bin:$PATH

COPY bin/$JAVA_PKG /tmp/jdk.tgz
RUN set -eux; \
	\
	echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c -; \
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

# set bash aliases
RUN echo 'alias ll="ls -all"' >> ~/.bashrc
