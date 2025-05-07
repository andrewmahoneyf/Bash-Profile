#---------------------------------------------------------------------------------------------------------------------------------------
#   1. CORE ENVIRONMENT SETTINGS
#---------------------------------------------------------------------------------------------------------------------------------------

# Ignore ZSH shell update notification
export BASH_SILENCE_DEPRECATION_WARNING=1

# Default editor
export EDITOR="nano"

# Bump the maximum number of file descriptors
ulimit -n 10240

# Parallel native builds for Node
export JOBS=max

#---------------------------------------------------------------------------------------------------------------------------------------
#   2. PATH CONFIGURATIONS
#---------------------------------------------------------------------------------------------------------------------------------------

# Helper to safely prepend to PATH
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;  # already in PATH
    *) PATH="$1:$PATH" ;;
  esac
}

# Core paths
add_to_path "/usr/local/bin"
add_to_path "/usr/local/sbin"
add_to_path "$HOME/bin"

#---------------------------------------------------------------------------------------------------------------------------------------
#   3. DEVELOPER TOOLING (Languages, Runtimes, Version/Package Managers)
#---------------------------------------------------------------------------------------------------------------------------------------

# Bun (JavaScript runtime)
export BUN_INSTALL="$HOME/.bun"
add_to_path "$BUN_INSTALL/bin"

# Composer (PHP dependency manager)
add_to_path "$HOME/.composer/vendor/bin"

# Go (Golang)
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
add_to_path "$GOBIN"

# jEnv (Java environment manager)
add_to_path "$HOME/.jenv/bin"
eval "$(jenv init -)"
export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

# Local node modules binaries
if [ -f "./package.json" ] && [ -d "./node_modules/.bin" ]; then
  add_to_path "./node_modules/.bin"
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm (Node package manager)
export PNPM_HOME="$HOME/Library/pnpm"
add_to_path "$PNPM_HOME"

# Python
add_to_path "$(brew --prefix)/opt/python/libexec/bin"

# Ruby
add_to_path "/usr/local/opt/ruby/bin"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# SQLite (SQL/Database)
add_to_path "/usr/local/opt/sqlite/bin"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/sqlite/lib/pkgconfig"

#---------------------------------------------------------------------------------------------------------------------------------------
#   4. MOBILE DEVELOPMENT
#---------------------------------------------------------------------------------------------------------------------------------------

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
add_to_path "$ANDROID_HOME/emulator"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/cmdline-tools/latest/bin"

# Flutter
add_to_path "$HOME/Development/flutter/bin"

#---------------------------------------------------------------------------------------------------------------------------------------
#   5. OTHER TOOLS & FRAMEWORKS
#---------------------------------------------------------------------------------------------------------------------------------------

# Algorand node
export ALGORAND_DATA="$HOME/node/data"
alias goal="$HOME/node/goal"

# colorls (Ruby gem)
add_to_path "$(ruby -e 'puts Gem.bindir')"

# TensorFlow (ML Framework) - hide log warnings
export TF_CPP_MIN_LOG_LEVEL=3

# Windsurf (AI IDE)
add_to_path "$HOME/.codeium/windsurf/bin"

#---------------------------------------------------------------------------------------------------------------------------------------
#   6. SYSTEM UTILS & PACKAGE MANAGERS
#---------------------------------------------------------------------------------------------------------------------------------------

# Set Homebrew Cask application directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Homebrew path (should come after everything else)
eval "$(/opt/homebrew/bin/brew shellenv)"

#---------------------------------------------------------------------------------------------------------------------------------------
# 7. BASHRC (Interactive Shell Configuration)
#---------------------------------------------------------------------------------------------------------------------------------------

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
