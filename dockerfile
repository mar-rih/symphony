FROM centos:7
MAINTAINER "Marwan Alrihawi" <marwan.arlihawi@naseej.com>
ENV contrainer docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i ==systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
COPY sysctl.conf /etc/
CMD ["sysctl -p"]

CMD ["/usr/sbin/init"]

RUN yum -y install openssh openssh-server openssh-clients openssl-libs;yum clean all;systemctl enable sshd.service

RUN mkdir /s
RUN mkdir /s/install_files
RUN mkdir /s/sirsi

#Creat Sirsi users, groups and directories as root.
RUN groupadd sirsi
RUN groupadd oinstall
RUN groupadd dba
RUN groupadd oracle
RUN useradd -m -g sirsi -G oinstall,dba -d /s/sirsi sirsi
RUN chmod 775 /s/sirsi/
RUN chown -R sirsi:sirsi /s/sirsi
RUN chown -R sirsi:sirsi /s/install_files
RUN chmod 755 /s/install_files/
RUN cd /s/install_files
RUN echo "sirsi:sirsi" |chpasswd
COPY  /local.sirsi/* /usr/local/sirsi
RUN yum install -y libaio.x86_64 glibc.x86_64
RUN su - sirsi
ENTRYPOINT /bin/bash
EXPOSE 5100
