#! /bin/bash
old_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# NEW ADMIN CREDENTIALS URL ENCODED USING PYTHON
password_URLEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$password")
username_URLEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$user")
fullname_URLEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$admin_fullname")
email_URLEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$admin_email")

# GET THE CRUMB AND COOKIE
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$old_password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO CREATE AN ADMIN USER
curl -X POST -u "admin:$old_password" $url/setupWizard/createAdminUser \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie $cookie_jar \
        --data-raw "username=$username_URLEncoded&password1=$password_URLEncoded&password2=$password_URLEncoded&fullname=$fullname_URLEncoded&email=$email_URLEncoded&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$username_URLEncoded%22%2C%20%22password1%22%3A%20%22$password_URLEncoded%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$password_URLEncoded%22%2C%20%22fullname%22%3A%20%22$fullname_URLEncoded%22%2C%20%22email%22%3A%20%22$email_URLEncoded%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22$username_URLEncoded%22%2C%20%22password1%22%3A%20%22$password_URLEncoded%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$password_URLEncoded%22%2C%20%22fullname%22%3A%20%22$fullname_URLEncoded%22%2C%20%22email%22%3A%20%22$email_URLEncoded%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"