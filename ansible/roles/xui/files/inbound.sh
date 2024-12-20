#!/bin/sh

FULLDOMAIN="$SUBDOMAIN.$DOMAIN"
DB_PATH="/etc/x-ui/x-ui.db"

inbound_id_1=101
user_id_1=1
up_1=0
down_1=0
total_1=0
remark_1="Nova"
enable_1=1
expiry_time_1=0
listen_1=""
port_1=2087
protocol_1="vless"
settings_1="{ \"clients\": [ { \"id\": \"1dc7571c-ad68-4afb-a7d3-9d4573c23967\", \"flow\": \"\", \"email\": \"HTTPUpgrade\", \"limitIp\": 0, \"totalGB\": 0, \"expiryTime\": 0, \"enable\": true, \"tgId\": \"\", \"subId\": \"p4dp8saxu8gabbkw\", \"reset\": 0 } ], \"decryption\": \"none\", \"fallbacks\": [] }"
stream_settings_1="{ \"network\": \"httpupgrade\", \"security\": \"tls\", \"externalProxy\": [ { \"forceTls\": \"same\", \"dest\": \"wWw.sPeEdTesT.net\", \"port\": \"$port_1\", \"remark\": \"\" } ], \"tlsSettings\": { \"serverName\": \"$FULLDOMAIN\", \"minVersion\": \"1.0\", \"maxVersion\": \"1.3\", \"cipherSuites\": \"\", \"rejectUnknownSni\": false, \"disableSystemRoot\": false, \"enableSessionResumption\": false, \"certificates\": [ { \"certificateFile\": \"/etc/letsencrypt/live/$FULLDOMAIN/fullchain.pem\", \"keyFile\": \"/etc/letsencrypt/live/$FULLDOMAIN/privkey.pem\", \"ocspStapling\": 3600, \"oneTimeLoading\": false, \"usage\": \"encipherment\", \"buildChain\": false } ], \"alpn\": [ \"h2\", \"http/1.1\" ], \"settings\": { \"allowInsecure\": false, \"fingerprint\": \"firefox\" } }, \"httpupgradeSettings\": { \"acceptProxyProtocol\": false, \"path\": \"/api/v2/shop/products?ed=2048\", \"host\": \"$FULLDOMAIN\", \"headers\": {} } }"
tag_1="inbound-2087"
sniffing_1="{ \"enabled\": true, \"destOverride\": [ \"http\", \"tls\", \"quic\", \"fakedns\" ], \"metadataOnly\": false, \"routeOnly\": false }"

inbound_id_2=102
user_id_2=1
up_2=0
down_2=0
total_2=0
remark_2="Nova"
enable_2=1
expiry_time_2=0
listen_2=""
port_2=2096
protocol_2="vless"
settings_2="{ \"clients\": [ { \"id\": \"de74239e-6a76-4cc6-8206-cdb4129771d6\", \"flow\": \"\", \"email\": \"SplitHTTP\", \"limitIp\": 0, \"totalGB\": 0, \"expiryTime\": 0, \"enable\": true, \"tgId\": \"\", \"subId\": \"m0y6apsuf39m8nkt\", \"reset\": 0 } ], \"decryption\": \"none\", \"fallbacks\": [] }"
stream_settings_2="{ \"network\": \"xhttp\", \"security\": \"tls\", \"externalProxy\": [ { \"forceTls\": \"same\", \"dest\": \"wWw.sPeEdTesT.net\", \"port\": 2096, \"remark\": \"\" } ], \"tlsSettings\": { \"serverName\": \"$FULLDOMAIN\", \"minVersion\": \"1.2\", \"maxVersion\": \"1.3\", \"cipherSuites\": \"\", \"rejectUnknownSni\": false, \"disableSystemRoot\": false, \"enableSessionResumption\": false, \"certificates\": [ { \"certificateFile\": \"/etc/letsencrypt/live/$FULLDOMAIN/fullchain.pem\", \"keyFile\": \"/etc/letsencrypt/live/$FULLDOMAIN/privkey.pem\", \"ocspStapling\": 3600, \"oneTimeLoading\": false, \"usage\": \"encipherment\", \"buildChain\": false } ], \"alpn\": [ \"h2\", \"http/1.1\", \"h3\" ], \"settings\": { \"allowInsecure\": true, \"fingerprint\": \"chrome\" } }, \"splithttpSettings\": { \"path\": \"/api/v3/shop/products?ed=2096\", \"host\": \"$FULLDOMAIN\", \"headers\": {}, \"scMaxConcurrentPosts\": \"100-200\", \"scMaxEachPostBytes\": \"1000000-2000000\", \"scMinPostsIntervalMs\": \"10-50\", \"noSSEHeader\": false, \"xPaddingBytes\": \"100-1000\", \"xmux\": { \"maxConcurrency\": \"16-32\", \"maxConnections\": 0, \"cMaxReuseTimes\": \"64-128\", \"cMaxLifetimeMs\": 0 } } }"
tag_2="inbound-2096"
sniffing_2="{ \"enabled\": false, \"destOverride\": [ \"http\", \"tls\", \"quic\", \"fakedns\" ], \"metadataOnly\": false, \"routeOnly\": false }"

sqlite3 "$DB_PATH" <<EOF
INSERT INTO inbounds (id, user_id, up, down, total, remark, enable, expiry_time, listen, port, protocol, settings, stream_settings, tag, sniffing)
VALUES ($inbound_id_1, $user_id_1, $up_1, $down_1, $total_1, '$remark_1', $enable_1, $expiry_time_1, '$listen_1', $port_1, '$protocol_1', '$settings_1', '$stream_settings_1', '$tag_1', '$sniffing_1');

INSERT INTO inbounds (id, user_id, up, down, total, remark, enable, expiry_time, listen, port, protocol, settings, stream_settings, tag, sniffing)
VALUES ($inbound_id_2, $user_id_2, $up_2, $down_2, $total_2, '$remark_2', $enable_2, $expiry_time_2, '$listen_2', $port_2, '$protocol_2', '$settings_2', '$stream_settings_2', '$tag_2', '$sniffing_2');
EOF

echo "Inbounds added to the database successfully"
