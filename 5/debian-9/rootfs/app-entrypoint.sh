#!/bin/bash -e
. /opt/bitnami/base/functions

print_welcome_page

INIT_SEM=/tmp/initialized.sem

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/config/database.php ]
}

vendor_present() {
  [ -f /app/vendor ]
}

wait_for_db() {
  local db_host="${DB_HOST:-mariadb}"
  local db_port="${DB_PORT:-3306}"
  local db_address=$(getent hosts "$db_host" | awk '{ print $1 }')
  counter=0
  log "Conectando a mariadb en $db_address"
  while ! curl --silent "$db_address:$db_port" >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      log "Error: No se pudo conectar a mariadb."
      exit 1
    fi
    log "Intentando conectar a mariadb en $db_address. Intento nro. $counter."
    sleep 5
  done
}

setup_db() {
  log "Configurando la base de datos"
  sed -i "s/utf8mb4/utf8/g" /app/config/database.php
  php artisan migrate --force
}

if [ "${1}" == "php" -a "$2" == "artisan" -a "$3" == "serve" ]; then
  if ! app_present; then
    log "Creando una aplicación laravel"
    cp -a /tmp/app/. /app/
  fi

  log "Instalando/Actualizando las dependencias de Laravel (composer)"
  if ! vendor_present; then
    composer install
    log "Dependencias Instaladas"
  else
    composer update
    log "Dependencias actualizadas"
  fi

  wait_for_db

  if ! fresh_container; then
    echo "#########################################################################"
    echo "                                                                         "
    echo " La inicialización de la app se saltea:                                  "
    echo " Elimine el archivo $INIT_SEM y reinicie el contenedor para reinicializar"
    echo " Usted puede, alternativamente, correr cualquier comando específico      "
    echo " utilizando docker-compose exec:                                         "
    echo " ej. docker-compose exec myapp php artisan make:console FooCommand       "
    echo "                                                                         "
    echo "#########################################################################"
  else
    setup_db
    log "La inicialización finalizó"
    touch $INIT_SEM
  fi
fi

exec tini -- "$@"
