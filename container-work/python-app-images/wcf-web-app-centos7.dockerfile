FROM centos/systemd

ARG user_name=wcfadmin

RUN cat < /etc/systemd/system/wcf-web-app.service
[Unit]
Description=West Creek Financial Auth Service
After=multi-user.target
Conflicts=getty@tty1.service

[Service]
Type=simple
User=${user_name}
ExecStart=/usr/bin/python3 /opt/wcf/web-app/web_api.py
StandardInput=tty-force

[Install]
WantedBy=multi-user.target
EOF

# Add system user account for ${user_name}
RUN getent group ${user_name} >/dev/null || groupadd -r ${user_name}
RUN getent passwd ${user_name} >/dev/null || useradd -r -g ${user_name} -d /opt/wcf/web-app -s /sbin/nologin ${user_name}

# Add repo files
ADD /etc/yum.repos.d/centos-base.repo /etc/yum.repos.d/

# Cleanup for using yum install commands
RUN yum -y install epel-release

# Install SQLite and Python packages and clean up
RUN yum --assumeyes update && \
    yum --assumeyet clean all && \
    yum --assumeyes install pip python3 python-pip && \
    yum clean all 

#Create working directory for installed app
RUN mkdir -p /opt/wcf/web-app
RUN mkdir /opt/wcf/web-app/resources
RUN chmod 
RUN chown -Rvf ${user_name}:${user_name} /opt/wcf
COPY web-app.py /opt/wcf/web-app/web-app.py

# Install requirements via pip
COPY requirements.txt /opt/wcf/web-app-resources

RUN pip install --no-cache-dir -r /opt/wcf/web-app-resources/requirements.txt


#Enable new features using systemd
RUN systemctl enable wcf-web-app.service

VOLUME ["/var/lib/wcf-web-app"]
USER ${user_name}

EXPOSE 8080
CMD ["/usr/sbin/init"]
