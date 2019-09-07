#---------------------------------------------------------------------------------------------------------------------------------------
#   1.  TERMINAL & PATH CONFIGURATIONS
#---------------------------------------------------------------------------------------------------------------------------------------

# Source bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# Setup our $PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH=$PATH:./node_modules/.bin

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Set our Homebrew Cask application directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Setting up jenv for java version management
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

# Algorand node
export ALGORAND_DATA='~/node/data'
alias goal="~/node/goal"

# Setup Go path
export GOPATH=/Users/andrewmahoney-fernandes/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export GO111MODULE=on

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# colorls
PATH=$PATH:$(ruby -e 'puts Gem.bindir')

# Tell npm to compile and install all your native addons in parallel and not sequentially
export JOBS=max

# Bump the maximum number of file descriptors you can have open
ulimit -n 10240

# Default editor
export EDITOR="nano"

# Hide TensorFlow log warnings
export TF_CPP_MIN_LOG_LEVEL=3

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

# Directory management
alias md='mkdir -p'                                                             # Make a new directory
alias rd='rmdir'                                                                # Remove a directory
alias mkdir='mkdir -pv'                                                         # Make parent directories if needed
alias perm="stat -f '%Lp'"                                                      # View the permissions of a file/dir as a number
disk-usage() { du -hs "$@" | sort -nr; }                                        # List disk usage of all the files in a directory (use -hr to sort on server)
dirdiff() { diff -u <( ls "$1" | sort)  <( ls "$2" | sort ); }                  # Compare the contents of 2 directories


#---------------------------------------------------------------------------------------------------------------------------------------
#   4.  MISC ALIAS'
#---------------------------------------------------------------------------------------------------------------------------------------

# Misc Commands
alias _="sudo"                                                                  # Shorthand for 'sudo' command
alias q='exit'                                                                  # Shorthand for 'exit' command
alias py='python'                                                               # Shorthand for 'python' command
alias json='fx'                                                                 # Run terminal JSON viewer
alias h="history"                                                               # Shorthand for `history` command
alias network-ip='ipconfig getifaddr en0'                                       # Get Your Network IP Address
alias public-ip='curl ipecho.net/plain; echo'                                   # Get Your External IP Address
alias bash_profile='code ~/.bash_profile'                                       # Open bash_profile in VSCode
alias bashrc='code ~/.bashrc'                                                   # Open bashrc in VSCode
alias re-source='source ~/.bash_profile'                                        # Source bash_profile
bash-as() { sudo -u $1 /bin/bash; }                                             # Run a bash shell as another user

# list files
alias ls='colorls --sd'                                                         # Override ls to use colorls with directories first
alias lsh='colorls -h'                                                          # Displays help prompt for colorls
alias lst='ls --tree'                                                           # List directory tree
alias lsg='ls --git-status'                                                     # Lists files with git status
alias lsl='ls -lA --sd'                                                         # Lists files
alias ll='ls -alh'                                                              # List all files
alias llr='ls -alhr'                                                            # List files (reverse)
alias lls='ls -alhS'                                                            # List files by size
alias llsr='ls -alhSr'                                                          # List files by size (reverse)
alias lld='ls -alht'                                                            # List files by date
alias lldr='ls -alhtr'                                                          # List files by date (reverse)
alias lldc='ls -alhtU'                                                          # List files by date created
alias lldcr='ls -alhtUr'                                                        # List files by date created (reverse)

# Navigation Shortcuts
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias home='clear && cd ~ && ll'                                                # Home directory
alias downloads='clear && cd ~/Downloads && ls'                                 # Downloads directory
alias desktop='clear && cd ~/Desktop && ls'                                     # Desktop directory
cs() { cd "$@" && ls; }                                                         # Enter directory and list contents with ls

# Node environments
alias node-dev='export NODE_ENV=development'
alias node-prod='export NODE_ENV=production'

# Terminal auto correction
eval $(thefuck --alias)
alias please='fuck'

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewup-cask='brewup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask upgrade'
alias brewdr='brew doctor'
alias brewout='brew outdated'
alias brewls='brew list'
alias brewsr='brew search'
alias brewi='brew install'

# npm
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'

# yarn
alias yarni='yarn add'
alias yarnup='yarn upgrade'
alias yarnrm='yarn remove'
alias yarnout='yarn outdated'
alias recycle="sudo rm -rf node_modules/ && yarn"

# Display the weather using wttr.in
weather() {
    location="$1"
    if [ -z "$location" ]; then
        location="Los+Angeles"
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

alias shutdown='sudo shutdown -h now'                                                                                             # Shut down Mac immediately
alias restart='sudo shutdown -r now'                                                                                              # Restart Mac immediately
alias add-dock-spacer='defaults write com.apple.dock persistent-apps -array-add "{'tile-type'='spacer-tile';}" && killall Dock'   # Add a spacer to the dock
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles 1 && killall Finder'                                   # Show hidden files in Finder
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles 0 && killall Finder'                                   # Hide hidden files in Finder
alias show-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock'                                # Show the Dashboard
alias hide-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock'                               # Hide the Dashboard
alias show-spotlight='sudo mdutil -a -i on'                                                                                       # Enable Spotlight
alias hide-spotlight='sudo mdutil -a -i off'                                                                                      # Disable Spotlight
alias today='grep -h -d skip `date +%m/%d` /usr/share/calendar/*'                                                                 # Get history facts about the day
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'                                  # Merge PDF files - Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias dsclean='find . -type f -name .DS_Store -delete'                                                                            # Get rid of those pesky .DS_Store files recursively
alias flush='dscacheutil -flushcache'                                                                                             # Flush your dns cache
alias mute="osascript -e 'set volume output muted true'"                                                                          # Mute the system volume
alias unmute="osascript -e 'set volume output muted false'"                                                                       # Unmute the system volume
alias task-complete='say -v "Zarvox" "Task complete"'
alias fix-audio='sudo launchctl unload /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist && sudo launchctl load /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist' # Fix audio control issues

#---------------------------------------------------------------------------------------------------------------------------------------
#   7.  TAB COMPLETION
#---------------------------------------------------------------------------------------------------------------------------------------

# Git completion
if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

# Docker completion
if [ -f ~/.docker-completion.bash ]; then
  source ~/.docker-completion.bash
fi

# Add tab completion for many Bash commands
if which brew >/dev/null 2>&1; then
  BREW_PREFIX=$(brew --prefix)

  if [ -f "$BREW_PREFIX"/etc/bash_completion.d/brew ]; then
    . "$BREW_PREFIX"/etc/bash_completion.d/brew
  fi

  if [ -f "$BREW_PREFIX"/Library/Contributions/brew_bash_completion.sh ]; then
    . "$BREW_PREFIX"/Library/Contributions/brew_bash_completion.sh
  fi
fi

# Add tab completion for vagrant commands
if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
    source `brew --prefix`/etc/bash_completion.d/vagrant
fi

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add completion for Makefile
complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make

# tab completion for colorls flags
source $(dirname $(gem which colorls))/tab_complete.sh

# Bash completion support for ssh.
export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}
_sshcomplete() {
    local CURRENT_PROMPT="${COMP_WORDS[COMP_CWORD]}"
    if [[ ${CURRENT_PROMPT} == *@*  ]] ; then
      local OPTIONS="-P ${CURRENT_PROMPT/@*/}@ -- ${CURRENT_PROMPT/*@/}"
    else
      local OPTIONS=" -- ${CURRENT_PROMPT}"
    fi
    # parse all defined hosts from .ssh/config and files included there
    for fl in "$HOME/.ssh/config" \
        $(grep "^\s*Include" "$HOME/.ssh/config" | 
            awk '{for (i=2; i<=NF; i++) print $i}' | 
            sed "s|^~/|$HOME/|")
    do
        if [ -r "$fl" ]; then
            COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$(grep -i ^Host "$fl" |grep -v '[*!]' | awk '{for (i=2; i<=NF; i++) print $i}' )" ${OPTIONS}) )
        fi
    done
    # parse all hosts found in .ssh/known_hosts
    if [ -r "$HOME/.ssh/known_hosts" ]; then
        if grep -v -q -e '^ ssh-rsa' "$HOME/.ssh/known_hosts" ; then
            COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( awk '{print $1}' "$HOME/.ssh/known_hosts" | grep -v ^\| | cut -d, -f 1 | sed -e 's/\[//g' | sed -e 's/\]//g' | cut -d: -f1 | grep -v ssh-rsa)" ${OPTIONS}) )
        fi
    fi
    # parse hosts defined in /etc/hosts
    if [ -r /etc/hosts ]; then
        COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( grep -v '^[[:space:]]*$' /etc/hosts | grep -v '^#' | awk '{for (i=2; i<=NF; i++) print $i}' )" ${OPTIONS}) )
    fi
    return 0
}
complete -o default -o nospace -F _sshcomplete ssh scp slogin

#---------------------------------------------------------------------------------------------------------------------------------------
#   8.  Docker
#---------------------------------------------------------------------------------------------------------------------------------------

alias dk='docker'
alias dklc='docker ps -l'  # List last Docker container
alias dklcid='docker ps -l -q'  # List last Docker container ID
alias dklcip='docker inspect -f "{{.NetworkSettings.IPAddress}}" $(docker ps -l -q)'  # Get IP of last Docker container
alias dkps='docker ps'  # List running Docker containers
alias dkpsa='docker ps -a'  # List all Docker containers
alias dki='docker images'  # List Docker images
alias dkrmac='docker rm $(docker ps -a -q)'  # Delete all Docker containers

case $OSTYPE in
  darwin*|*bsd*|*BSD*)
    alias dkrmui='docker images -q -f dangling=true | xargs docker rmi'  # Delete all untagged Docker images
    ;;
  *)
    alias dkrmui='docker images -q -f dangling=true | xargs -r docker rmi'  # Delete all untagged Docker images
    ;;
esac

if [ ! -z "$(command ls "${BASH_IT}/enabled/"{[0-9][0-9][0-9]${BASH_IT_LOAD_PRIORITY_SEPARATOR}docker,docker}.plugin.bash 2>/dev/null | head -1)" ]; then
# Function aliases from docker plugin:
    alias dkrmlc='docker-remove-most-recent-container'  # Delete most recent (i.e., last) Docker container
    alias dkrmall='docker-remove-stale-assets'  # Delete all untagged images and exited containers
    alias dkrmli='docker-remove-most-recent-image'  # Delete most recent (i.e., last) Docker image
    alias dkrmi='docker-remove-images'  # Delete images for supplied IDs or all if no IDs are passed as arguments
    alias dkideps='docker-image-dependencies'  # Output a graph of image dependencies using Graphiz
    alias dkre='docker-runtime-environment'  # List environmental variables of the supplied image ID
fi
alias dkelc='docker exec -it $(dklcid) bash --login' # Enter last container (works with Docker 1.3 and above)
alias dkrmflast='docker rm -f $(dklcid)'
alias dkbash='dkelc'
alias dkex='docker exec -it ' # Useful to run any commands into container without leaving host
alias dkri='docker run --rm -i '
alias dkrit='docker run --rm -it '

# Added more recent cleanup options from newer docker versions
alias dkip='docker image prune -a -f'
alias dkvp='docker volume prune -f'
alias dksp='docker system prune -a -f'

# Docker compose
alias dco="docker-compose"
alias dcofresh="docker-compose-fresh"
alias dcol="docker-compose logs -f --tail 100"
alias dcou="docker-compose up"

# Devzone container
alias dz-run='make docker run-devzone run-celery'
alias dz-stop='docker-compose stop'
alias dz-start='docker-compose start'
alias dz-kill='docker-compose down'

# Playpants
alias pp-test='make -f Makefile.rpmvenv run-dev-platform-api.tests.playpants'
alias pp-build='docker exec -it devzone_app_1 /bin/bash -c "python ./devzone/manage.py dumpdata playpants.ProjectSettingGroup --indent 4 > ./devzone/playpants/fixtures/initial_project_settings.json"'

# Activity Launcher / LSG/MMP / Redis / Ab Testing / Achievement Engine
alias dz-al='make run-activity-launcher'
alias dz-lsg='make run-lsgmmp20'
alias dz-ab='make run-abtesting'
alias dz-ae='make run-ae'
alias dz-redis='make run-redis'
alias dz-flower='make run-flower'
alias dz-sls='make run-sls'

# Run all Devzone
alias dz-run-all='dz-run && dz-al && dz-lsg && dz-ab && dz-ae'

# Devzone Utils
alias dz-help='make all'
alias dz-shell='make docker-shell'
alias dz-lint='make -f Makefile.rpmvenv py-lint'
alias dz-log='docker logs -f devzone_app_1'
alias dz-mm='docker exec devzone_app_1 python ./devzone/manage.py makemigrations'
alias dz-migrate='docker exec devzone_app_1 python ./devzone/manage.py migrate'
alias dz-req='docker exec -it devzone_app_1 /bin/bash -c "source /usr/share/venvs/devzone/bin/activate && pip install -r rpm/requirements.txt && service httpd restart"'
alias docker-prune='docker system prune --volumes -f'

# Crypto Bot
alias build-bot="docker build -t bot-img ."
alias run-bot="docker run -d -ti --name crypto-bot bot-img"
alias kill-bot="docker stop crypto-bot"
alias bot-logs="docker logs crypto-bot"
alias bot-shell="docker attach crypto-bot"

#---------------------------------------------------------------------------------------------------------------------------------------
#   9.  SSH
#---------------------------------------------------------------------------------------------------------------------------------------

alias ping-pi='ping pi.local'
alias ssh-pi="ssh andrewmahoney-fernandes@192.168.1.208"
getsshkey() { pbcopy < ~/.ssh/id_rsa.pub; }                                     # Copy ssh key to the keyboard

function add_ssh() {
  about 'add entry to ssh config'
  param '1: host'
  param '2: hostname'
  param '3: user'
  group 'ssh'

  echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >> ~/.ssh/config
}

function sshlist() {
  about 'list hosts defined in ssh config'
  group 'ssh'

  awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
}

function ssh-add-all() {
  about 'add all ssh private keys to agent'
  group 'ssh'

  grep -slR "PRIVATE" ~/.ssh | xargs ssh-add
}