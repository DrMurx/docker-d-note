#! /bin/sh

/usr/bin/generate_dnote_hashes

chown -R uwsgi:uwsgi /dnote

exec uwsgi \
  --uid uwsgi \
  --gid uwsgi \
  --plugin /usr/lib/uwsgi/python_plugin.so \
  --master \
  --processes ${PROCESSES} \
  --threads ${THREADS} \
  --http-socket :8080 \
  --manage-script-name \
  --chdir /usr/lib/python2.7/site-packages/dnote-1.0.1-py2.7.egg/dnote \
  --mount ${APPLICATION_ROOT}=__init__:DNOTE
