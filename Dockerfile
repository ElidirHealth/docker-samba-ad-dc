FROM ubuntu:trusty
MAINTAINER Martin Yrjölä <martin.yrjola@gmail.com> & Tobias Kaatz <info@kaatz.io>

ENV DEBIAN_FRONTEND noninteractive

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

VOLUME ["/var/lib/samba", "/etc/samba"]

# Setup ssh and install supervisord
RUN apt-get update && apt-get install -y build-essential libacl1-dev libattr1-dev \
      libblkid-dev libgnutls-dev libreadline-dev python-dev libpam0g-dev \
      python-dnspython gdb pkg-config libpopt-dev libldap2-dev \
      dnsutils libbsd-dev attr krb5-user docbook-xsl libcups2-dev acl python-xattr \
      samba smbclient krb5-kdc openssh-server supervisor expect pwgen rsyslog \
      sssd sssd-tools libpam-sss libnss-sss libnss-ldap bind9 dnsutils ldb-tools
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin Yes/g' /etc/ssh/sshd_config

# Install bind9 dns server
COPY named.conf.options /etc/bind/named.conf.options

# Install samba and dependencies to make it an Active Directory Domain Controller



# Install utilities needed for setup
COPY kdb5_util_create.expect kdb5_util_create.expect

# Install rsyslog to get better logging of ie. bind9

# Create run directory for bind9
RUN mkdir -p /var/run/named
RUN chown -R bind:bind /var/run/named

# Install sssd for UNIX logins to AD
COPY sssd.conf /etc/sssd/sssd.conf
RUN chmod 0600 /etc/sssd/sssd.conf

# Add custom script
COPY custom.sh /usr/local/bin/custom.sh
RUN chmod +x /usr/local/bin/custom.sh

COPY altouuser.ldiff	/root


# Add supervisord and init
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY init.sh /init.sh
RUN chmod 755 /init.sh
EXPOSE 22 53 389 88 135 139 138 445 464 3268 3269
ENTRYPOINT ["/init.sh"]
CMD ["app:start"]
