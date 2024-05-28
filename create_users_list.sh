#!/bin/bash

#######################
#Author : sandeep
#Date : 2024-05-28T23:43:43
#######################

#Github API URL
API_URL="https://api.github.com"

#Github username and personal access token
USERNAME=$username
TOKEN=$token


#Repositary owner and repositary name.
REPO_OWNER=$1
REPO_NAME=$2

function helper_message() {

    expected_cmd_args=2

    if [[ $# -ne $expected_cmd_args ]]; then

      echo "please execute the script with the required number of script arguments"
    fi
}

helper_message

#Function to make GET api request to the GithubAPI
function github_get_api {

    local endpoint=$1
    local url="${API_URL}/${endpoint}"
    #Send a GET request to the Github API with Authentication.
    curl -s -u "${USERNAME}:${TOKEN}" "${url}"
}

function list_users_with_read_access {

    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    #Fetch the list of collaborators on the repository.
    local api_output="$(github_get_api "$endpoint")"
    echo "API output:"
    echo "$api_output"

    local collaborators="$(echo "$api_output" | jq -r '.[] | select(.permissions.pull == true) | .login')"


    if [[ -z "$collaborators" ]]; then

        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}"

    else
       echo "Users with ${REPO_OWNER}/${REPO_NAME}:"
       echo "$collaborators"
    fi
      
}

function helper_message() {

    expected_cmd_args=2

    if [[ $# -ne $expected_cmd_args ]]; then

      echo "please execute the script with the required number of script arguments"
    fi
}

# Main Script

echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}"
list_users_with_read_access


