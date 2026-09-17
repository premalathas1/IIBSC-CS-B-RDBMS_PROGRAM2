#!/bin/bash

set -u

DB="CollegeDB"
USER="root"
PASSWORD="${MYSQL_PASSWORD:-root}"

MYSQL="mysql -u${USER} -p${PASSWORD} -N -B"
