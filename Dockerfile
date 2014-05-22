FROM netengine/base:0.1.1
MAINTAINER team@netengine.com.au

# Install postgresql
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list
RUN ansible local --connection=local -m apt_key -a "url=https://www.postgresql.org/media/keys/ACCC4CF8.asc state=present"
RUN apt-get update
RUN ansible local --connection=local -m apt -a "pkg=postgresql-9.3 state=present"
RUN ansible local --connection=local -m apt -a "pkg=postgresql-contrib-9.3 state=present"

# Configure postgresql
ADD files /config
RUN cp /config/postgresql_service.json /consul/config/postgresql_service.json
RUN chown -R netengine:netengine /config
RUN ansible local --connection=local -m file -a "state=directory path=/etc/service/postgres owner=root group=root"
RUN ansible local --connection=local -m copy -a "src=/config/run dest=/etc/service/postgres/run owner=root group=root mode=0555"

# Install bootstrapping script for new /shared-data volumes
RUN ansible local --connection=local -m file -a "path=/config/prepare_shared_data_volume owner=netengine group=netengine mode=0555"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start Runit
CMD ["/sbin/my_init"]
