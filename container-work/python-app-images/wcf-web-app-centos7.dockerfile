FROM centos/systemd

RUN cat < /etc/systemd/system/wcf-auth-api.service
[Unit]
Description=West Creek Financial Auth Service
After=multi-user.target
Conflicts=getty@tty1.service

[Service]
Type=simple
User=${user_name}
ExecStart=/usr/bin/python3 /opt/wcf/auth-api/auth_api.py
StandardInput=tty-force

[Install]
WantedBy=multi-user.target
EOF

# Add system user account for ${user_name}
RUN getent group ${user_name} >/dev/null || groupadd -r ${user_name}
RUN getent passwd ${user_name} >/dev/null || useradd -r -g ${user_name} -d /opt/${user_name} -s /sbin/nologin ${user_name}

# Add repo files
ADD /etc/yum.repos.d/centos-base.repo /etc/yum.repos.d/

# Cleanup for using yum install commands
RUN yum -y install epel-release

# Install SQLite and Python packages and clean up
RUN yum --assumeyes update && \
    yum --assumeyet clean all && \
    yum --assumeyes install pip python3 python-pip sqlite && \
    yum clean all 

#Create working directory for installed app
RUN mkdir -p /opt/wcf/auth-api
RUN mkdir /opt/wcf/auth-api/resources
RUN chmod 
RUN chown -Rvf ${user_name}:${user_name} /opt/wcf
COPY auth-api.py /opt/wcf/auth-api/auth-api.py

# Install requirements via pip
COPY requirements.txt /opt/wcf/auth-api-resources

RUN pip install --no-cache-dir -r /opt/wcf/requirements.txt


#Enable new features using systemd
RUN systemctl enable wcf-auth-api.service

VOLUME ["/var/lib/wcf-auth-api"]
USER ${user_name}

EXPOSE 8080
CMD ["/usr/sbin/init"]
