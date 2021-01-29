#!/usr/bin/env bash

until mysql -h 'mariadb' -P 3306 --protocol=tcp -u hiveuser '-phivepassword' -e ";"; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

cd /opt/apache-hive-2.3.8-bin/scripts/metastore/upgrade/mysql/

mysql -h 'mariadb' -P 3306 --protocol=tcp -u hiveuser '-phivepassword' -e "use metastore; source /opt/apache-hive-2.3.8-bin/scripts/metastore/upgrade/mysql/hive-schema-2.3.0.mysql.sql;"

cd ${HIVE_HOME}
bin/hive --service metastore
