#! /bin/bash
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO DOWNLOAD AND INSTALL REQUIRED MODULES
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer','bitbucket','docker-workflow','blueocean'],'Jenkins-Crumb':'$only_crumb'}"