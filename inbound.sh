#!/bin/sh

SUBDOMAIN="nova.$DOMAIN"
db_path="/etc/x-ui/x-ui.db"

inbound_id=1
user_id=1
up=0
down=0
total=0
remark="Nova"
enable=1  # true -> 1, false -> 0
expiry_time=0
listen=""
port=2087
protocol="vless"
settings="{ \"clients\": [ { \"id\": \"1dc7571c-ad68-4afb-a7d3-9d4573c23967\", \"flow\": \"\", \"email\": \"nova\", \"limitIp\": 0, \"totalGB\": 0, \"expiryTime\": 0, \"enable\": true, \"tgId\": \"\", \"subId\": \"p4dp8saxu8gabbkw\", \"reset\": 0 } ], \"decryption\": \"none\", \"fallbacks\": [] }"
stream_settings="{ \"network\": \"httpupgrade\", \"security\": \"tls\", \"externalProxy\": [ { \"forceTls\": \"same\", \"dest\": \"wWw.sPeEdTesT.net\", \"port\": \"$port\", \"remark\": \"\" } ], \"tlsSettings\": { \"serverName\": \"$SUBDOMAIN\", \"minVersion\": \"1.0\", \"maxVersion\": \"1.3\", \"cipherSuites\": \"\", \"rejectUnknownSni\": false, \"disableSystemRoot\": false, \"enableSessionResumption\": false, \"certificates\": [ { \"certificateFile\": \"/etc/nginx/ssl/nova/pubkey.pem\", \"keyFile\": \"/etc/nginx/ssl/nova/private.key\", \"ocspStapling\": 3600, \"oneTimeLoading\": false, \"usage\": \"encipherment\", \"buildChain\": false } ], \"alpn\": [ \"h2\", \"http/1.1\" ], \"settings\": { \"allowInsecure\": false, \"fingerprint\": \"firefox\" } }, \"httpupgradeSettings\": { \"acceptProxyProtocol\": false, \"path\": \"/api/v2/shop/products?ed=2048\", \"host\": \"$SUBDOMAIN\", \"headers\": {} } }"
tag="inbound-2087"
sniffing="{ \"enabled\": true, \"destOverride\": [ \"http\", \"tls\", \"quic\", \"fakedns\" ], \"metadataOnly\": false, \"routeOnly\": false }"

sqlite3 "$db_path" <<EOF
INSERT INTO inbounds (id, user_id, up, down, total, remark, enable, expiry_time, listen, port, protocol, settings, stream_settings, tag, sniffing)
VALUES ($inbound_id, $user_id, $up, $down, $total, '$remark', $enable, $expiry_time, '$listen', $port, '$protocol', '$settings', '$stream_settings', '$tag', '$sniffing');
EOF

echo "Inbound added to the database successfully."

