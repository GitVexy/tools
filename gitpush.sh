# This is a bash function, and should go in a sourced file like ~/.bashrc
gitpush() {
    local branch="main"
    
    while getopts "m" opt; do
        case $opt in
            m) branch="master" ;;
            *) branch="main" ;;
        esac
    done
    shift $((OPTIND-1))

    if [ -z "$1" ]; then
        echo -e "Error: Commit message required.\n>gitpush [-m] 'message'"
        return 1
    fi

    echo "Adding files to git..."
    git add .
    if [ $? -ne 0 ]; then
        echo "Error during 'git add .'"
        return 1
    fi

    echo "Committing changes with message: $1..."
    git commit -m "$1"
    if [ $? -ne 0 ]; then
        echo "Error during 'git commit -m '$1''"
        return 1
    fi

    echo "Pushing changes to origin/$branch..."
    git push origin $branch
    if [ $? -ne 0 ]; then
        echo "Error during 'git push origin $branch'"
        return 1
    fi

    echo "Git push completed successfully!"
}
