FROM quay.io/centos/centos:stream9

RUN dnf update

RUN dnf install -y bc \
	binutils \
	compat-openssl11 \
	elfutils-libelf \
	fontconfig \
	glibc \
	glibc-devel \
	glibc-headers \
	ksh \
	libaio \
	libasan \
	liblsan \
	libX11 \
	libXau \
	libXi \
	libXrender \
	libXtst \
	libxcrypt-compat \
	libgcc \
	libibverbs \
	libnsl \
	librdmacm \
	libstdc++ \
	libxcb \
	libvirt-libs \
	make \
	policycoreutils \
	policycoreutils-python-utils \
	smartmontools \
	sysstat \
	wget \
	nano \
	ncurses \
	sudo \
	perl \
	readline-devel \
	passwd \
	lshw \
	hostname \
	glibc-langpack-en \
	xterm \
	iproute

RUN wget https://github.com/hanslub42/rlwrap/releases/download/0.46.1/rlwrap-0.46.1.zip
RUN unzip rlwrap-0.46.1.zip
WORKDIR /rlwrap-0.46.1
RUN pwd && ./configure && make && make install
WORKDIR /
RUN rm -rf rlwrap*

RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf && echo "LANGUAGE=en_US" >> /etc/locale.conf
RUN ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime

# NO USAR ASÍ, cambia la constraseña!!!
RUN useradd -u 1000 -g administrador -m -d /home/administrador -s /bin/bash paco --password $(openssl passwd "administrador")
RUN usermod -aG wheel administrador

RUN groupadd -g 54321 oinstall
RUN groupadd -g 54322 dba
RUN groupadd -g 54323 oper
RUN groupadd -g 54324 backupdba
RUN groupadd -g 54325 dgdba
RUN groupadd -g 54326 kmdba
RUN useradd -u 54321 -g oinstall -G dba,backupdba,dgdba,kmdba oracle --password $(openssl passwd "oracle")

WORKDIR /opt
RUN mkdir -p /opt/oracle
RUN chown oracle:oinstall oracle
RUN chmod 755 oracle

WORKDIR /tmp
RUN wget https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23ai-1.0-1.el9.x86_64.rpm
RUN wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/oracle-database-preinstall-23ai-1.0-2.el9.x86_64.rpm

RUN export ORACLE_DOCKER_INSTALL=true && dnf install -y oracle-database-preinstall* && dnf install -y oracle-database-free*

RUN rm oracle-database*.rpm

RUN touch /.dockerenv

WORKDIR /

EXPOSE 1521
