#!/bin/sh -x

# Establish a temporary file to write to
response=`mktemp`
trap "rm -f '$response'" 0 1 2 3 15

# Until we run out of pages to retrieve...
url='https://api.github.com/orgs/awsdocs/repos?per_page=100'
while [ "$url" ]
do
    {   # Query the GitHub API for a JSON array of repos (single page)
        curl --silent --include "$url"
    } | {
        # Strip carriage returns from the response
        tr -d '\r'
    } | {
        # Write the response (including headers) to our temporary file
        tee "$response"
    } | {
        # Strip the headers from the response, leaving only JSON
        awk 'x{print}!$0{x=1}'
    } | {
        # Print out the list of remote URLs
        jq -r '.[].clone_url'
    } | {
        # Clone the repos into subdirectories of the current directory
        while read repo
        do
            name=`echo "$repo" | sed -n 's#.*/\(.*\)\.git#\1#p'`
            [ -e "$name/.git" ] || {
                git submodule add "$repo"
                git submodule update --init --remote --depth 1
            }
        done
    }
    # Get the URL of the next page
    url=`sed -n 's/^link: <\(.*\)>; rel="next".*$/\1/p' "$response"`
    echo >&2 "DEBUG: url = '$url'"
done
