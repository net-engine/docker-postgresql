#  Standard NE PostgreSQL container.

Access the DB via the unix socket in /config, setting a password for the PG netengine user.

    psql --dbname postgres --host /config --username netengine -c "alter user netengine with password 'netengine123';"

Verify that the new password allows TCP access to the PG server.

    PGPASSWORD=netengine123 psql postgres -h localhost

Boot a PG container to serve from an existing /shared-data database.

    docker run -d --volumes-from DATA --name postgresql1 netengine/postgresql

Bootstrap a new /shared-data volume.

    docker run --rm --volumes-from DATA netengine/postgresql /sbin/my_init --skip-runit --quiet -- /config/prepare_shared_data_volume
