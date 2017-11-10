#!/usr/bin/with-contenv sh

cat << EOF > ${CONFD_HOME}/etc/conf.d/nifi.properties.toml
[template]
prefix = "${CONFD_PREFIX_KEY}"
src = "nifi.properties.tmpl"
dest = "/opt/nifi/conf/nifi.properties"
mode = "0744"
keys = [
  "/config"
]
EOF

cat << EOF > ${CONFD_HOME}/etc/conf.d/logback.xml.toml
[template]
prefix = "${CONFD_PREFIX_KEY}"
src = "logback.xml.tmpl"
dest = "/opt/nifi/conf/logback.xml"
mode = "0744"
keys = [
  "/config"
]
EOF