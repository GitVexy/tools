# This is a bash function, and should go in a sourced file like ~/.bashrc
gitpush() { # Takes a variable string and adds ./ to staged commits, commits them with string, then pushes to origin.
    if [ -z "$1" ]; then
    	echo -e "Error: Commit message required.\n>gitpush 'message'"
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

    echo "Pushing changes to origin/main..."
    git push origin main
    if [ $? -ne 0 ]; then
        echo "Error during 'git push origin main'"
        return 1
    fi

    echo "Git push completed successfully!"
}
