#! /bin/bash
url_urlEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$url")

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

curl -X POST -u "$user:$password" $url/setupWizard/configureInstance \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "rootUrl=$url_urlEncoded%2F&Jenkins-Crumb=$only_crumb&json=%7B%22rootUrl%22%3A%20%22$url_urlEncoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22rootUrl%22%3A%20%22$url_urlEncoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"