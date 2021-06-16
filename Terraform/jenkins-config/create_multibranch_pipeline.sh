#! /bin/bash
credentials=$(cat credentials_id) # output from get_credentials_id.sh

jobName_URLEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$jobName")
remote_URLEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$remote")

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# Create Job

curl -u "$user:$password" -X POST "$url/createItem" \
     -H "$full_crumb" \
     --cookie $cookie_jar \
     --data-urlencode "name=$jobName" \
     --data-urlencode "mode=org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject" \
     --data-urlencode "Jenkins-Crumb=$only_crumb"

# Config

curl -u "$user:$password" -X POST "$url/job/$jobName_URLEncoded/configSubmit" \
  -H "$full_crumb" \
  --cookie $cookie_jar \
  --data-raw "_.displayNameOrNull=&_.description=&stapler-class=jenkins.plugins.git.GitSCMSource&id=$jobID&_.remote=$remote_URLEncoded&includeUser=false&_.credentialsId=$credentials&stapler-class=jenkins.plugins.git.traits.BranchDiscoveryTrait&%24class=jenkins.plugins.git.traits.BranchDiscoveryTrait&stapler-class=jenkins.branch.DefaultBranchPropertyStrategy&%24class=jenkins.branch.DefaultBranchPropertyStrategy&stapler-class=jenkins.branch.NamedExceptionsBranchPropertyStrategy&%24class=jenkins.branch.NamedExceptionsBranchPropertyStrategy&stapler-class=jenkins.branch.BranchSource&kind=jenkins.branch.BranchSource&_.scriptPath=Jenkinsfile&stapler-class=org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory&%24class=org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory&_.interval=1d&stapler-class=com.cloudbees.hudson.plugins.folder.computed.DefaultOrphanedItemStrategy&%24class=com.cloudbees.hudson.plugins.folder.computed.DefaultOrphanedItemStrategy&_.pruneDeadBranches=on&_.daysToKeepStr=&_.numToKeepStr=&stapler-class=com.cloudbees.hudson.plugins.folder.icons.StockFolderIcon&%24class=com.cloudbees.hudson.plugins.folder.icons.StockFolderIcon&stapler-class=jenkins.branch.MetadataActionFolderIcon&%24class=jenkins.branch.MetadataActionFolderIcon&_.dockerLabel=&_.url=&includeUser=false&_.credentialsId=&core%3Aapply=&Jenkins-Crumb=$only_crumb&json=%7B%22displayNameOrNull%22%3A+%22%22%2C+%22description%22%3A+%22%22%2C+%22disable%22%3A+false%2C+%22sources%22%3A+%7B%22source%22%3A+%7B%22stapler-class%22%3A+%22jenkins.plugins.git.GitSCMSource%22%2C+%22id%22%3A+%22$jobID%22%2C+%22remote%22%3A+%22$remote_URLEncoded%22%2C+%22includeUser%22%3A+%22false%22%2C+%22credentialsId%22%3A+%22$credentials%22%2C+%22traits%22%3A+%7B%22stapler-class%22%3A+%22jenkins.plugins.git.traits.BranchDiscoveryTrait%22%2C+%22%24class%22%3A+%22jenkins.plugins.git.traits.BranchDiscoveryTrait%22%7D%7D%2C+%22%22%3A+%220%22%2C+%22strategy%22%3A+%7B%22stapler-class%22%3A+%22jenkins.branch.DefaultBranchPropertyStrategy%22%2C+%22%24class%22%3A+%22jenkins.branch.DefaultBranchPropertyStrategy%22%7D%2C+%22stapler-class%22%3A+%22jenkins.branch.BranchSource%22%2C+%22kind%22%3A+%22jenkins.branch.BranchSource%22%7D%2C+%22%22%3A+%5B%220%22%2C+%221%22%5D%2C+%22projectFactory%22%3A+%7B%22scriptPath%22%3A+%22Jenkinsfile%22%2C+%22stapler-class%22%3A+%22org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory%22%2C+%22%24class%22%3A+%22org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory%22%7D%2C+%22orphanedItemStrategy%22%3A+%7B%22stapler-class%22%3A+%22com.cloudbees.hudson.plugins.folder.computed.DefaultOrphanedItemStrategy%22%2C+%22%24class%22%3A+%22com.cloudbees.hudson.plugins.folder.computed.DefaultOrphanedItemStrategy%22%2C+%22pruneDeadBranches%22%3A+true%2C+%22daysToKeepStr%22%3A+%22%22%2C+%22numToKeepStr%22%3A+%22%22%7D%2C+%22icon%22%3A+%7B%22stapler-class%22%3A+%22jenkins.branch.MetadataActionFolderIcon%22%2C+%22%24class%22%3A+%22jenkins.branch.MetadataActionFolderIcon%22%7D%2C+%22org-jenkinsci-plugins-docker-workflow-declarative-FolderConfig%22%3A+%7B%22dockerLabel%22%3A+%22%22%2C+%22registry%22%3A+%7B%22url%22%3A+%22%22%2C+%22includeUser%22%3A+%22false%22%2C+%22credentialsId%22%3A+%22%22%7D%7D%2C+%22core%3Aapply%22%3A+%22%22%2C+%22Jenkins-Crumb%22%3A+%22$only_crumb%22%7D&Submit=Save"