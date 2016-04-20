ZSH_DIR=$HOME/.zsh/

# Load configuration files
if [[ -d $ZSH_DIR ]]; then
        for ZSH_FILE in `ls -1 $ZSH_DIR`
        do
            if [[ "$ZSH_FILE" == *[.zsh] ]]; then
                source "$ZSH_DIR/$ZSH_FILE"
            fi
        done
fi
