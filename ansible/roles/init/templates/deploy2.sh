#!/bin/bash
set -e
if [[ $# -eq 0 ]] ; then
    echo "Enter project name"
    exit 0
fi

cd {{ home }}/$1

{% if is_prod -%}
git pull
{%- endif %}

yarn install
yarn build
source /opt/$1/env/bin/activate
pip install -r requirements.txt --exists-action s
cd /opt/$1/project
./manage.py migrate
./manage.py collectstatic --noinput

{% if is_prod -%}
systemctl restart $1-wsgi
service nginx restart
{%- endif %}
