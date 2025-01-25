# Created by Vexy 25/jan/2025

# This goes in .bashrc or a similarly sourced file

ncode() { # Fetches clipboard content and writes it to specified filename, then opens it in VSCode

### START OF INIT

## DEPENDENCY VALIDATION
    if ! command -v xclip &> /dev/null; then
        echo ""
        echo "Error: xclip is not installed, or is missing from PATH." 
        echo "Please install it and try again."
        echo ""
        return 1
    fi

## VARIABLE INITIALIZATION
    local abs_path
    local append=false
    local clear_log=false
    local empty=false
    local file=""
    local help=false
    local log_file="$HOME/ncode.log"
    local no_open=false
    local verbose=false
    log_action() { # Logging function
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
        }
    verbose_check() { # Verbose check function
        local string="$1" # Capture the input string as a parameter
        if [ "$verbose" = true ]; then
            echo "$string"
        fi
    }

## ARGUMENT PARSING
    for arg in "$@"; do
        case "$arg" in
            -a|--append) # Append clipboard contents to end of existing document
                append=true
                ;;
            -n|--no-open) # Do not open the file after creation
                no_open=true
                ;;
            -c|--clear-log) # Clears log
                clear_log=true
                ;;
            -h|--help) # Displays help message
                help=true
                ;;
            -v|--verbose) # Output information about what the script is doing as it does it
                verbose=true
                ;;
            -e|--empty) # Create file with no copied contents
                empty=true
                ;;
            -l|--log) # Cats log
                echo "cat $log_file"
                cat $log_file
                return 1
                ;;
            *)
                file="$arg"
                ;;
        esac
    done

### END OF INIT

### START OF RUN

## HELP MESSAGE
    if [ "$help" = true ]; then
        cat << EOF
*~ nCode ~*

Usage: ncode [options] <filename>

Writes clipboard content to specified file, and opens it in VSCode.

Options:
  -a,  --append         Append clipboard content rather than overwriting
  -e,  --empty          Create file with no copied contents
  -n,  --no-open        Do not open the file after creation

  -c,  --clear-log      Clears log file at $HOME/ncode.log
  -h,  --help           Show this help message
  -v,  --verbose        Enable verbose mode for detailed output
  -l,  --log            Cats the log file to stdout

EOF
    return 0
    fi

## CLEAR LOG
    if [ "$clear_log" = true ]; then
        echo "Are you sure you want to clear the log? (y/n)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Log clear aborted"
            return 1
        else
            echo "" > "$log_file"
            echo "Log cleared"
            return 1
        fi
    fi

## FILENAME VALIDATION
    # Check if a filename is provided
    if [ -z "$file" ]; then
        echo -e "\nError: No filename provided."
        echo "Usage: ncode [options] <filename>"
        echo -e "\nUse ncode -h or ncode --help for instructions"
        return 1
    fi

## DIRECTORY VALIDATION
    # Ensure the directory exists
    if ! mkdir -p "$(dirname "$file")"; then
       echo "Error: Failed to create directory $(dirname "$file")."
       return 1
    fi

    # Set absolute path for logging purposes
    abs_path=$(realpath "$file")

## CLIPBOARD FETCHING
    # Fetch clipboard content using xclip
    local content
    content=$(xclip -selection clipboard -o)
    verbose_check "Fetched content from clipboard..."

## SET CONTENTS TO EMPTY ON FLAG
    # Writes 
    if [ "$empty" = true ]; then
        verbose_check "Setting content to empty string: [-e]"
        if [ "$append" = true ]; then
            verbose_check "Setting append to false. [-a] doesn't work with [-e]"
            append=false
        fi
    fi
    if [ "$empty" = true ]; then
        content=""
    fi

## WRITE / APPEND TO FILE
    # Append
    if [ "$append" = true ]; then
        verbose_check "Appending content to $file"

        echo "$content" >> "$file"
        log_action "Appended content to $abs_path"
        verbose_check "Logged action in $log_file"
    else
    # Write
        if [ -e "$file" ]; then
            echo -e "\nWarning: File '$file' already exists. Overwrite? (y/n)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                echo "Aborted."
                return 1
            fi
        fi
        verbose_check "Writing content to $file"
        log_action "Wrote clipboard content to $abs_path"
        verbose_check "Logged action in $log_file"
        echo "$content" > "$file"
    fi

## OPEN FILE
    # Open the file in VSCode unless --no-open is specified
    if [ "$no_open" = false ]; then
        verbose_check "Opening $file in VSCode"
        
        code "$file"
    else
        verbose_check "--no-open used. Not opening file"
    fi
    

## NOTIFY EMPTY
    # Notify user on empty clipboard
    if [ -z "$content" ] && [ ! "$empty" ]; then # Empty clipboard message
        echo "Error: Clipboard was empty. File may not contain expected content."
    fi
}
