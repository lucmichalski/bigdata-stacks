# Path to your oh-my-zsh installation.
# export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH
export ZSH=~/.oh-my-zsh
export wslroot=/mnt/c/Users/Administrator/AppData/Local/Packages/CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc/LocalState/rootfs/root

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="lambda-mod"
#ZSH_THEME="ys"
export TERM=xterm-256color

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git wd	z extract history web-search sbt
git-open zsh-syntax-highlighting zsh-autosuggestions	)

# Enable autosuggestions automatically.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

source $ZSH/oh-my-zsh.sh


#@ User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
#export EDITOR="/opt/vim/nvim-app/nvim.appimage"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# For a full list of active aliases, run `alias`.
# @@------------------------Example aliases-----------------------------
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias pdf='synclient touchpadoff=1'
alias pdo='synclient touchpadoff=0'
alias upalc='update-alternatives --config'
alias upali='update-alternatives --install'
alias apti="apt-get install"
alias aptug="apt-get upgrade"
alias aptud="apt-get update"
alias aptfi="apt-get -f install"
alias aptre="apt-get remove"
alias aptar='apt-get autoremove && apt-get autoclean && apt-get clean'
alias aptsh='apt show'
alias md="mkdir -p"
alias df="df -h"
alias mv="mv -i"
alias cp="cp -rf"
alias rm="rm -rf"
alias la="ls -a -htrF"
alias ll="ls -la -lhtrF"
alias l.="ls -lhtrdF .*"
alias cl="colorls -A --sd"
alias clf="colorls -A -f --sd"
alias cld="colorls -A -d --sd"
alias cll="colorls -lA --sd"
alias cgt="colorls --gs -t"
alias cgl="colorls --gs -lA --sd"
alias zrc="nv ~/.zshrc"
alias vrc="nv ~/.SpaceVim.d/vimrc"
alias trc="nv ~/.tmux.conf"
alias szsh="source ~/.zshrc"
alias grep="grep --color=auto"
# git
alias git='/mnt/c/DevTools/cmder/vendor/git-for-windows/bin/git.exe'
alias gch='git checkout'
alias gcp='git cherry-pick'
# apps
alias tmk="tmux kill-server"
alias upomz='cd ~/.oh-my-zsh & git pull'
alias arec='asciinema rec'
alias shdfs='start-dfs.sh && start-yarn.sh && start-master.sh && start-slaves.sh'
alias stophdfs='stop-all.sh && stop-master.sh && stop-slaves.sh'
alias nv='nvim'
alias idea='/opt/ide-tools/idea-IC-183.4886.37/bin/idea.sh'
alias pycharm='/opt/ide-tools/pycharm-community-2018.3.1/bin/pycharm.sh'

# 自动补全快捷键
bindkey '`' autosuggest-accept

export UPDATE_ZSH_DAYS=7
HIST_STAMPS="yyyy-mm-dd"


funcFBI() {

_COLUMNS=$(tput cols)
_MESSAGE=" FBI Warining "
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")

echo " "
echo -e "${spaces}\033[41;37;5m FBI WARNING \033[0m"
echo " "
_COLUMNS=$(tput cols)
_MESSAGE="Ferderal Law provides severe civil and criminal penalties for"
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="the unauthorized reproduction, distribution, or exhibition of"
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="copyrighted motion pictures (Title 17, United States Code,"
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="Sections 501 and 508). The Federal Bureau of Investigation"
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="investigates allegations of criminal copyright infringement"
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="(Title 17, United States Code, Section 506)."
y=$(( ( $_COLUMNS - ${#_MESSAGE} )  / 2 ))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"
echo " "
}

#funcFBI

# Conda
#export PATH=/mnt/d/devtools/python/anaconda3/envs/py36:$PATH
#. /mnt/d/devtools/python/anaconda3/etc/profile.d/conda.sh

# CUDA
#export PATH=/mnt/c/Daily Software/cuda/10.0/bin:$PATH
#export PATH=/mnt/c/Daily Software/cuda/10.0/include:$PATH
#export PATH=/mnt/c/Daily Software/cuda/10.0/lib:$PATH
export CUDA_DEVICE_ORDER="PCI_BUS_ID"
export CUDA_VISIBLE_DEVICES="0,1,2,3"

# Java
export JAVA_HOME=/opt/lang-tools/java/jdk
export JDK_HOME=/opt/lang-tools/java/jdk
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin:$PATH

# Scala
export SCALA_HOME=/opt/lang-tools/scala/scala-2.12.8
export PATH=${SCALA_HOME}/bin:$PATH
export SCALA_DOC=/opt/lang-tools/scala/scala-2.12.8/bin/scaladoc
export SCALA_COMPILER=/opt/lang-tools/scala/scala-2.12.8/bin/scalac
export PATH=/opt/lang-tools/scala:$PATH

# Sbt
export SBT_HOME=/opt/lang-tools/scala/sbt
export PATH=${SBT_HOME}/bin:$PATH

# Spark
export SPARK_HOME=/opt/spark/spark-2.4.0
export PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH

# Pyspark
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
export PYSPARK_PYTHON=/home/alanding/software/anaconda3/envs/py36/bin/python3.6

# Hadoop
export HADOOP_HOME=/opt/spark/hadoop-2.9.2
export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH

# Maven
export MAVEN_HOME=/opt/lang-tools/maven-3.6.0
export PATH=${MAVEN_HOME}/bin:$PATH

# Idea
# export IDEA_PROPERTIES=$HOME/.idea.properties

# TEX
export PATH=/home/alanding/software/texlive/2018/bin/x86_64-linux:$PATH
export MANPATH=/home/alanding/software/texlive/2018/texmf-dist/doc/man:$MANPATH
export INFOPATH=/home/alanding/software/texlive/2018/texmf-dist/doc/info:$INFOPATH

# Vim
export VIM_HOME=/opt/vim
export PATH=${VIM_HOME}/vim8.1/bin:$PATH
export PATH=${VIM_HOME}/nvim-linux64/bin:$PATH

# Neovim-remote/spacevim
export PATH=$PATH:$HOME/.SpaceVim/bin

# Gtags
export UNIVERSAL_CTAGS_HOME=/opt/vim/universal-ctags
export PATH=${UNIVERSAL_CTAGS_HOME}/bin:$PATH
export GTAGSLABEL=native-pygments
export GTAGSCONF=$HOME/.globalrc

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  vim -c \
    "set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermby=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}

# Browser for ensime
export BROWSER='google-chrome %s'

# Gtm
export PATH=/opt/vim/gtm.v1.3.5.linux:$PATH

# Node version manager
export NVM_DIR="/opt/lang-tools/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Yarn
export YARN_HOME=/opt/lang-tools/nvm/versions/node/v11.9.0/bin/yarn

# Ruby
#export PATH=$HOME/.rbenv/bin:$PATH
#export PATH=$HOME/.rbenv/bin:$PATH
#eval "$(rbenv init -)"
#source $(dirname $(gem which colorls))/tab_complete.sh

# Go
export PATH=/opt/lang-tools/go/go1.12.linux-amd64/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# Fzf
[ -f /opt/vim/fzf/.fzf.zsh ] && source /opt/vim/fzf/.fzf.zsh
export FZF_TMUX=1
export FZF_COMPLETION_TRIGGER='ff'
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude={.git, .idea, .vacode, .project, .sass-cache, node_modules, build}"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || bat {}) 2> /dev/null | head -500'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_ALT_C_OPTS="--preview --select-1 --exit-0 'tree -C -p -s {} | head -200'"
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"}
cdf() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"}
fh() {
  eval $( ([ -n "$ZSH_NAME"] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')}
