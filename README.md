# Tools

### This is a selection of tools I’ve made on my path of becoming a developer

- **nCode**:
    
    Usage: ncode [options] <filename>
    
    Writes clipboard content to specified file, and opens it in VSCode.
    
    Options:  
    -a,  --append         Append clipboard content rather than overwriting  
    -e,  --empty          Create file with no copied contents  
    -n,  --no-open        Do not open the file after creation  
    
    -c, --clear-log Clears log file at /home/vexy/ncode.log  
    -h, --help Show this help message  
    -v, --verbose Enable verbose mode for detailed output  

- **gitPush**:

    Usage: gitPush "commit message" (quotes required)  
    
    Takes a variable string and adds working directory to staged commits,  
    commits them with message, then pushes to origin.
