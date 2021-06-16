#! /bin/bash

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))

curl -u "$user:$password" -X GET "$url/credentials/store/system/domain/_/api/json?tree=credentials[id]" \
     -H "$full_crumb" \
     --cookie $cookie_jar 
