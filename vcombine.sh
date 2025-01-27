# Goes in .bashrc or similarly sourced file

vcombine() { # Combines all files of specified filetype in current directory into a single master file

    : '
    Example usecases:
    - Combine many text files into a single document
    - Combine all code assignments into a single "chapter" file
    '

    : '
    Extended vcombine usage in bash:
    Generate master file for every .py file in current directory, including sub-directories:
    vcombine .py
    
    Generate master files for each sub-directory, and one master_master that combines them all in the current dir:
    find ./ -type d | while read -r folder; do (cd "$folder" && vcombine .py)
    
    Find all generated master files in current directory and sub-directories:
    find ./ -type f -name "*master*"
    
    Delete all generated master files in current directory and sub-directories: !!Dangerous!! Run previous command first!
    find ./ -type f -name "*master*" -exec rm -f {} +
    '

 ## INITIALIZE VARIABLES

    extension="$1"                                                  # The file extension to search for (e.g., ".py")
    dir_name=$(basename "$PWD")                                     # Get the name of the current directory
    master_file="${dir_name}_master$extension"                      # Create the master file name (e.g., folder_master.py)

 ## FIND COMMENT STYLE FROM FILETYPE

    # Determine comment style based on file extension
    case "$extension" in
        .py|.sh|.rb|.pl)                comment_prefix="#" ;;       # Python, Shell, Ruby, Perl
        .js|.ts|.java|.c|.cpp|.cs|.go)  comment_prefix="//" ;;      # JavaScript, TypeScript, C-family, Go
        .html|.xml|.css)                comment_prefix="<!--" ;;    # HTML, XML, CSS
        .php)                           comment_prefix="//" ;;      # PHP
        *)                              comment_prefix="" ;;        # Default to no comment for unknown types
    esac

 ## ASK IF USER WANTS A COMMENT STYLE WHEN ONE IS NOT FOUND

    if [ -z "$comment_prefix" ]; then                               # Check if comment prefix doesn't exist
        echo -e "Extension type $extension detected.\nThis filetype lacks a recognized comment prefix. Add one? (y/n)"
        read -r response                                            # Ask for comment prefix

    ## IF NO

        if [[ ! "$response" =~ ^[Yy]$ ]]; then                      # If not yes
            echo "Generating file without comment prefix"

    ## IF YES

        else                                                        # If yes
            echo "Enter desired comment prefix:"
            read -r response                                        # Read comment prefix from input
            comment_prefix="$response"
            echo "Generating file with comment prefix '${comment_prefix}'"
        fi
    
 ## USE KNOWN COMMENT STYLE WHEN ONE IS FOUND
    
    else
        echo -e "Extension type $extension detected.\nGenerating file with comment prefix '${comment_prefix}'"
    fi

 ## COUNT FILES TO PROCESS. ABORT IF NONE ARE FOUND

    file_count=$(find ./ -type f -name "*$extension" | wc -l)       # Count the amount of files to be used. For logging
    if [ $file_count -eq 0 ]; then                                  # Abort if no files found
        echo "No files of type '$extension' found. Aborting"
        return 1
    fi

 ## FIND FILE AND ADD FILE NAME AS COMMENT TO MASTER FILE

    find ./ -type f -name "*$extension" | sort | while read -r file; do
        [[ "$file" == "./$master_file" ]] && continue               # Skip the master file to avoid self-inclusion
        echo -e "\n${comment_prefix} $file\n" >> "$master_file"     # Append <comment prefix>$file_name to master_file

 ## ADD FILE CONTENTS TO MASTER FILE

        cat "$file" >> "$master_file"                               # Append the file content

    done

 ## TELL USER WHAT HAS BEEN DONE, AND RETURN

    echo "Generated $master_file from $file_count file(s) in $PWD"
    return 0
}
