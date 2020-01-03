FROM centos/systemd

ARG user_name=wcfadmin
RUN echo "[Unit] \n\
Description=West Creek Financial Auth Service\n\
After=multi-user.target\n\
Conflicts=getty@tty1.service\n\
[Service]\n\
Type=simple\n\
User=${user_name}\n\
ExecStart=/usr/bin/python3 /opt/wcf/auth-api/auth_api.py\n\
StandardInput=tty-force\n\
[Install]\n\
WantedBy=multi-user.target\n\
"

# Add system user account for ${user_name}
RUN getent group ${user_name} >/dev/null || groupadd -r ${user_name}
RUN getent passwd ${user_name} >/dev/null || useradd -r -g ${user_name} -d /opt/wcf -s /sbin/nologin ${user_name}

#RUN mkdir etc/yum.repos.d
# Add repo files
#COPY /etc/yum.repos.d/centos-base.repo etc/yum.repos.d/

# Cleanup for using yum install commands
RUN yum -y install epel-release

# Install SQLite and Python packages and clean up
RUN yum --assumeyes update && \
    yum --assumeyet clean all && \
    yum --assumeyes install pip python3 python-pip sqlite && \
    yum clean all 

#Create working directory for installed app
RUN mkdir -p opt/wcf/auth-api
RUN mkdir opt/wcf/auth-api/resources
RUN mkdir opt/wcf/db/resources

RUN chown -Rvf ${user_name}:${user_name} /opt/wcf

COPY auth-api.py opt/wcf/auth-api/auth-api.py
COPY requirements.txt opt/wcf/auth-api/resources/
COPY schema.sql opt/wcf/db/resources/

# Install requirements via pip
COPY requirements.txt opt/wcf/auth-api-resources

RUN pip install --no-cache-dir -r opt/wcf/requirements.txt
RUN sqlite3 opt/wcf/db/database.db < opt/wcf/db/schema.sql

#Enable new features using systemd
RUN systemctl enable wcf-auth-api.service

VOLUME ["/var/lib/wcf-auth-api"]
USER ${user_name}

EXPOSE 8080
CMD ["/usr/sbin/init"]
