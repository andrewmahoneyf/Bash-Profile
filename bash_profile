#---------------------------------------------------------------------------------------------------------------------------------------
#   1.  TERMINAL & PATH CONFIGURATIONS
#---------------------------------------------------------------------------------------------------------------------------------------

# Source bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# Git completion
if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

# Bash completion
if [ -f /etc/bash_completion ]; then
   source /etc/bash_completion
fi

# Setup our $PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH=$PATH:./node_modules/.bin

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Set our Homebrew Cask application directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Tell npm to compile and install all your native addons in parallel and not sequentially
export JOBS=max

# Bump the maximum number of file descriptors you can have open
ulimit -n 10240

# Default editor
export EDITOR="nano"

#---------------------------------------------------------------------------------------------------------------------------------------
#   2.  TERMINAL STYLING
#---------------------------------------------------------------------------------------------------------------------------------------

# Color settings
BLACK="\[\033[0;30m\]"
BLACKB="\[\033[1;30m\]"
RED="\[\033[0;31m\]"
REDB="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
GREENB="\[\033[1;32m\]"
YELLOW="\[\033[0;33m\]"
YELLOWB="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
BLUEB="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
PURPLEB="\[\033[1;35m\]"
CYAN="\[\033[0;36m\]"
CYANB="\[\033[1;36m\]"
WHITE="\[\033[0;37m\]"
WHITEB="\[\033[1;37m\]"

# Count number of files/folders in current directory
parse_file_number() {
    ls -1 | wc -l | sed 's: ::g'
}

# Set a specific color for the status of the Git repo
git_color() {
    local STATUS=`git status 2>&1`
    if [[ "$STATUS" == *'Not a git repository'* ]]
        then echo "" # nothing
    else
        if [[ "$STATUS" != *'working tree clean'* ]]
            then echo -e '\033[0;31m' # red if need to commit
        else
            if [[ "$STATUS" == *'Your branch is ahead'* ]]
                then echo -e '\033[0;33m' # yellow if need to push
            else
                echo -e '\033[0;32m' # else green
            fi
        fi
    fi
}

# Get Git branch of current directory
git_branch () {
    if git rev-parse --git-dir >/dev/null 2>&1
        then echo -e "" git:\($(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')\)
    else
        echo ""
    fi
}

# Set tab name to the current directory
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# Add color to terminal outputs
export CLICOLOR=1
export LSCOLORS=GxExBxBxFxegedabagacad

# Modify the main prompt
export PS1=$CYAN'\d \t | \u →'$WHITE' '$BLUE'[\w | $(parse_file_number) files]\e[0m$(git_color)$(git_branch)\n'$WHITE''$GREEN'$'$WHITE' '

#---------------------------------------------------------------------------------------------------------------------------------------
#   3.  FOLDER MANAGEMENT
#---------------------------------------------------------------------------------------------------------------------------------------

# Clear a directory
cleardir() {
    while true; do
        read -ep 'Completely clear current directory? [y/N] ' response
        case $response in
            [Yy]* )
                bash -c 'rm -rfv ./*'
                bash -c 'rm -rfv ./.*'
                break;;
            * )
                echo 'Skipped clearing the directory...'
                break;;
        esac
    done
}

mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }    # Creates a *.tar.gz archive of a file or folder
mkzip() { zip -r "${1%%/}.zip" "$1" ; }               # Create a *.zip archive of a file or folder

# file extract helper
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Start a web server to share the files in the current directory
sharefolder() {
    # PHP
    path="$1"
    if [ -z "$path" ]; then
        path="."
    fi
    php -t $path -S localhost:5555
}

#---------------------------------------------------------------------------------------------------------------------------------------
#   4.  MISC ALIAS'
#---------------------------------------------------------------------------------------------------------------------------------------

# Misc Commands
alias re-source='source ~/.bash_profile'                                        # Source bash_profile
bash-as() { sudo -u $1 /bin/bash; }                                             # Run a bash shell as another user
alias ll='ls -alh'                                                              # List files
alias llr='ls -alhr'                                                            # List files (reverse)
alias lls='ls -alhS'                                                            # List files by size
alias llsr='ls -alhSr'                                                          # List files by size (reverse)
alias lld='ls -alht'                                                            # List files by date
alias lldr='ls -alhtr'                                                          # List files by date (reverse)
alias lldc='ls -alhtU'                                                          # List files by date created
alias lldcr='ls -alhtUr'                                                        # List files by date created (reverse)
alias h="history"                                                               # Shorthand for `history` command
alias perm="stat -f '%Lp'"                                                      # View the permissions of a file/dir as a number
alias mkdir='mkdir -pv'                                                         # Make parent directories if needed
disk-usage() { du -hs "$@" | sort -nr; }                                        # List disk usage of all the files in a directory (use -hr to sort on server)
dirdiff() { diff -u <( ls "$1" | sort)  <( ls "$2" | sort ); }                  # Compare the contents of 2 directories
getsshkey() { pbcopy < ~/.ssh/id_rsa.pub; }                                     # Copy ssh key to the keyboard

# Navigation Shortcuts
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias home='clear && cd ~ && ll'                                                # Home directory
alias downloads='clear && cd ~/Downloads && ls'                                 # Downloads directory
alias desktop='clear && cd ~/Desktop && ls'                                 # Desktop directory
cs() { cd "$@" && ls; }                                                        # Enter directory and list contents with ls

# Terminal auto completion
eval $(thefuck --alias)

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewup-cask='brewup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask upgrade'

# npm
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias recycle="sudo rm -rf node_modules/ && yarn"

# Display the weather using wttr.in
weather() {
    location="$1"
    if [ -z "$location" ]; then
        location="~Los+Angeles"
    fi

    curl http://wttr.in/$location?lang=en
}

#---------------------------------------------------------------------------------------------------------------------------------------
#   5.  GIT SHORTCUTS
#---------------------------------------------------------------------------------------------------------------------------------------

alias gitstats='git-stats'
alias gits='git status -s'
alias gita='git add -A && git status -s'
alias gitcom='git commit -am'
alias gitacom='git add -A && git commit -am'
alias gitc='git checkout'
alias gitcm='git checkout master'
alias gitb='git branch'
alias gitcb='git checkout -b'
alias gitdb='git branch -d'
alias gitDb='git branch -D'
alias gitdr='git push origin --delete'
alias gitf='git fetch'
alias gitr='git rebase'
alias gitpl='git pull'
alias gitfr='git fetch && git rebase'
alias gitpo='git push -u origin'
alias gitm='git merge'
alias gitmm='git merge master'
alias gitcl='git clone'
alias gitundo='git reset --soft HEAD~1'
alias gitrao='git remote add origin'
alias gitrso='git remote set-url origin'
alias gitremoveremote='git rm -r --cached'
alias gitlog="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
alias gitlog-changes="git log --oneline --decorate --stat --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
gitdbr() { git branch -d "$@" && git push origin --delete "$@"; }
gitupstream() { git branch --set-upstream-to="$@"; }
gitreset() {
    while true; do
        read -ep 'Reset HEAD? [y/N] ' response
        case $response in
            [Yy]* )
                bash -c 'git reset --hard HEAD'
                break;;
            * )
                echo 'Skipped reseting the HEAD...'
                break;;
        esac
    done
}

#---------------------------------------------------------------------------------------------------------------------------------------
#   6.  OS X COMMANDS
#---------------------------------------------------------------------------------------------------------------------------------------

alias add-dock-spacer='defaults write com.apple.dock persistent-apps -array-add "{'tile-type'='spacer-tile';}" && killall Dock'   # Add a spacer to the dock
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles 1 && killall Finder'                                   # Show hidden files in Finder
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles 0 && killall Finder'                                   # Hide hidden files in Finder
alias show-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock'                                # Show the Dashboard
alias hide-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock'                               # Hide the Dashboard
alias show-spotlight='sudo mdutil -a -i on'                                                                                       # Enable Spotlight
alias hide-spotlight='sudo mdutil -a -i off'                                                                                      # Disable Spotlight
alias today='grep -h -d skip `date +%m/%d` /usr/share/calendar/*'                                                                 # Get history facts about the day
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'                                  # Merge PDF files - Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias task-complete='say -v "Zarvox" "Task complete"'
alias fix-audio='sudo launchctl unload /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist && sudo launchctl load /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist' # Fix audio control issues

#---------------------------------------------------------------------------------------------------------------------------------------
#   7.  TAB COMPLETION
#---------------------------------------------------------------------------------------------------------------------------------------

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Add tab completion for vagrant commands
if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
    source `brew --prefix`/etc/bash_completion.d/vagrant
fi

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

#---------------------------------------------------------------------------------------------------------------------------------------
#   8.  Docker
#---------------------------------------------------------------------------------------------------------------------------------------

# Main container
alias dz-run='make docker run-devzone run-celery'
alias dz-stop='docker-compose stop'
alias dz-start='docker-compose start'
alias dz-kill='docker-compose down'

# Playpants
alias pp-test='make -f Makefile.rpmvenv run-dev-platform-api.tests.playpants'
alias pp-reset='docker exec devzone_app_1 service celeryd restart'

# Activity Launcher / LSG/MMP / Redis / Ab Testing / Achievement Engine
alias dz-al='make run-activity-launcher'
alias dz-lsg='make run-lsgmmp20'
alias dz-ab='make run-abtesting'
alias dz-ae='make run-ae'
alias dz-redis='make run-redis'
alias dz-flower='make run-flower'
alias dz-sls='make run-sls'

# Run all
alias dz-run-all='dz-run && dz-al && dz-lsg && dz-ab && dz-ae'

# Utils
alias dz-help='make all'
alias dz-lint='make -f Makefile.rpmvenv py-lint'
alias dz-snapshots="make test-update-snapshots"
alias dz-log='make -f Makefile.devenv devzone-dev-logs CONTAINERS="devzone"'
alias dz-mm='docker exec docker_devzone_1 python2.7 manage.py makemigrations'
alias dz-migrate="docker exec docker_devzone_1 python2.7 manage.py migrate"
alias dz-shell='make docker-shell'
alias docker-reset='docker exec docker_devzone_1 service httpd restart'
alias docker-prune='docker system prune -f'
alias docker-req='docker exec -it docker_devzone_1 /bin/bash -c "source /usr/share/venvs/devzone/bin/activate && pip install -r rpm/requirements.txt && service httpd restart"'
