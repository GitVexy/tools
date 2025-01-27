# Goes in .bashrc or similarly sourced file

vcombine() { # Combines all files in current directory of specified filetype into a single document
  extension="$1"                                                # The file extension to search for (e.g., ".py")
  dir_name=$(basename "$PWD")                                   # Get the name of the current directory
  master_file="${dir_name}_master$extension"                    # Create the master file name (e.g., folder_master.py)

  # Determine comment style based on file extension
  case "$extension" in
    .py|.sh|.rb|.pl)                comment_prefix="#" ;;       # Python, Shell, Ruby, Perl
    .js|.ts|.java|.c|.cpp|.cs|.go)  comment_prefix="//" ;;      # JavaScript, TypeScript, C-family, Go
    .html|.xml|.css)                comment_prefix="<!--" ;;    # HTML, XML, CSS
    .php)                           comment_prefix="//" ;;      # PHP
    *)                              comment_prefix="" ;;        # Default to no comment for unknown types
  esac

  find ./ -type f -name "*$extension" | sort | while read -r file; do
    [[ "$file" == "./$master_file" ]] && continue               # Skip the master file to avoid self-inclusion
    if [[ -n "$comment_prefix" ]]; then
      echo -e "\n${comment_prefix} $file\n" >> "$master_file"   # Append the file name with comment
    else
      echo -e "\n$file\n" >> "$master_file"                     # Append the file name without comment
    fi
    cat "$file" >> "$master_file"                               # Append the file content
  done
}
