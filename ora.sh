#!/bin/bash

if [[ -n "$TNS_ADMIN" ]]; then
    echo "Variable TNS_ADMIN is set to: $TNS_ADMIN"
    export EXTRA_JAVA_ARGS="-Doracle.net.tns_admin=$TNS_ADMIN -Doracle.net.wallet_location=$TNS_ADMIN"
else
    echo "Variable TNS_ADMIN is empty or unset."
fi

/opt/sqlline/sqlline -u "$ORACLE_URL" -n "$ORACLE_USERNAME" -p "$ORACLE_PASSWORD" -d oracle.jdbc.driver.OracleDriver
