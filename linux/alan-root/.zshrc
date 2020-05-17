#! /usr/bin/env zsh


# ==================================================================================
# ZSH Configuration
# ============================================================================== {{{
ZshSettings() {
  # Path to your oh-my-zsh installation.
  export ZSH=~/.oh-my-zsh

  # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
  #ZSH_THEME="ys"
  ZSH_THEME="lambda-mod"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
  COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories much, much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  HIST_STAMPS="yyyy/mm/dd"

  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  plugins=(git wd	z extract history web-search sbt
          git-open zsh-syntax-highlighting zsh-autosuggestions docker docker-compose)
  fpath+=$HOME/.oh-my-zsh/custom/plugins/conda-completion
  fpath+=$HOME/.oh-my-zsh/custom/plugins/gradle-completion
  # fpath+=$HOME/.oh-my-zsh/custom/plugins/ninja-completion
  fpath+=$HOME/.oh-my-zsh/custom/plugins/rustcompletion

  zstyle ':completion::complete:*' use-cache 1

  # Enable autosuggestions automatically.
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

  export UPDATE_ZSH_DAYS=30

  #@ User configuration
  export MANPATH="/usr/local/man:$MANPATH"

  # You may need to manually set your language environment
  export LANG=en_US.UTF-8

  # Compilation flags
  export ARCHFLAGS="-arch x86_64"

  # ssh
  export SSH_KEY_PATH="~/.ssh"

  source $ZSH/oh-my-zsh.sh

  # autocomplete keybinding
  bindkey '`' autosuggest-accept

  # man 着色
  export LESS_TERMCAP_mb=$'\e[1;32m'
  export LESS_TERMCAP_md=$'\e[1;32m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[1;4;31m'


  HISTSIZE=10000
  SAVEHIST=10000

  # 不保留重复的历史记录项
  setopt hist_ignore_all_dups
  # 在命令前添加空格，不将此命令添加到记录文件中
  setopt hist_ignore_space
  # zsh 4.3.6 doesn't have this option
  setopt hist_fcntl_lock 2>/dev/null
  setopt hist_reduce_blanks
  setopt no_nomatch

  # disable Vim freeze after pressing <C-s>
  stty -ixon
}
# }}}


# ==================================================================================
# Function Tools Definition
# =============================================================================== {{{
pidCheck() {
  # check pid tid, locate thread problem
  ps -mp ${1} -L -o pcpu,pmem,pid,THREAD,tid,time,tname,cmd
  # ps -mp pid -o THREAD,tid,time
}


decimalToHex() {
  printf "%x\n" $1
}
jstackCheck() {
  local pid=decimalToHex $1
  jstack -l $pid > $HOME/jstack.log
}


removewps() {
  cd /usr/share/applications && sudo rm wps-office-et.desktop wps-office-pdf.desktop wps-office-wpp.desktop wps-office-wps.desktop
}


# hadoop 集群运维函数
slave_do() {
    if (($#==0)); then
       echo no args;
       return;
    fi

    echo '=========== in hadoop100 ============'
    eval $1
    echo '\n'

    for (( i = 1; i < 3; i++ )); do
        echo '=========== in hadoop10'${i}' ============'
        ssh hadoop10$i $1
        echo '\n'
    done
}


# Fzf
FzfConfig() {
  [ -f /opt/vim/fzf/.fzf.zsh ] && source /opt/vim/fzf/.fzf.zsh
  export FZF_COMPLETION_TRIGGER='jj'
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || bat {}) 2> /dev/null | head -500'"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude={.git, .idea, .vscode, .project, .sass-cache, .pyc, node_modules, build, target}"
  export FZF_TMUX=1
  # export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # export FZF_CTRL_T_OPTS="--select-1 --exit-0"
  export FZF_ALT_C_OPTS="--preview --select-1 --exit-0 'tree -C -p -s {} | head -200'"
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }

  # 命令行模糊搜索文件，进入选中文件所在的文件夹
  cdf() {
    local dir
    dir=$(dirname "$1") && cd "$dir"
  }
  
  # 运行选中的历史命令
  fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
  }

}


codi() {
# Codi Usage: codi [filetype] [filename]
  local syntax="${1:-python}"
  shift
  vim -c \
    "set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermby=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}
# }}}


# ==================================================================================
# Commands Aliases Definition
# =============================================================================== {{{
DefAlias() {
  # -------------------------------------------------------------------------------------------------
  # 普通应用
  # ---------------------------------------------------------------------------------------------- {{{
  # system operation
  alias pdf='synclient touchpadoff=1'
  alias pdo='synclient touchpadoff=0'
  alias alc='update-alternatives --config'
  alias ali='update-alternatives --install'
  alias apti="apt-get install"
  alias aptug="apt-get upgrade"
  alias aptud="apt-get update"
  alias aptf="apt-get -f install"
  alias aptre="apt-get remove"
  alias aptar='apt-get autoremove && apt-get autoclean && apt-get clean'
  alias aptsh='apt show'

  alias cl="colorls -A --sd"
  alias clf="colorls -A -f --sd"
  alias cld="colorls -A -d --sd"
  alias cll="colorls -lA --sd"
  alias cgt="colorls --gs -t"
  alias cgl="colorls --gs -lA --sd"

  alias md="mkdir -p"
  alias df="df -h"
  alias mv="mv -i"
  alias cp="cp -rf"
  alias rm="rm -rf"
  alias la="ls -a -htrF"
  alias ll="ls -la -lhtrF"
  alias l.="ls -lhtrdF .*"

  alias sysbackup='sh /mnt/fun+downloads/linux系统安装/systembackup/sysbackup.sh'

  # config files
  alias zrc="nv ~/.zshrc"
  alias brc="nv ~/.bashrc"
  alias vrc="nv ~/.SpaceVim.d/vimrc"
  alias trc="nv ~/.tmux.conf"
  alias szsh="source ~/.zshrc"

  # -------------------------------------------------------------------------------------------------
  # windows 编码 解码
  # ---------------------------------------------------------------------------------------------- {{{
  # alias unzip="-O CP936"
  # alias zipinfo="-O CP936"
  # alias convmv="convmv -f GBK -t utf-8 -notest "
  # }}}

  # editor
  alias ge='gedit'
  alias em='emacs -nw'
  alias nv='nvim'
  alias typora='~/software/Typora/Typora'
  alias tmk="tmux kill-server"

  # App
  alias yinyue='sudo netease-cloud-music'
  alias irc='irssi'
  # acinema
  alias acinema='asciinema'
  alias arec='asciinema rec'
  alias arect='asciinema rec -t'
  alias apl='asciinema play'
  alias aul='asciinema upload'
  alias aauth='asciinema auth'
  alias acat='asciinema cat'
  # fun
  alias rcat="nyancat"
  alias clock="while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done&"
  # translator
  alias jj='python3 /home/alanding/.SpaceVim.d/extools/translator/translator.py '
  # }}}


  # -------------------------------------------------------------------------------------------------
  # 常用开发工具
  # ---------------------------------------------------------------------------------------------- {{{
  # grep keyword file | keyword
  alias grep="grep --color=auto"

  # Git
  alias gch='git checkout'
  alias grh='git reset --hard'
  alias gpod='git push origin --delete'
  alias grro='git remote remove origin'
  alias grru='git remote remove upstream'

  # Database
  # alias mysql='mysql -u root -p'
  # alias mongod='mongod --dbpath /home/alanding/software/database/mongodb'

  # docker
  alias drmc-all="docker rm $(docker ps -a -q) -f"

  # Cargo
  alias rr='cargo run'
  alias rb='cargo build'

  # Sphinx
  alias sphstart='sphinx-quickstart'
  alias sphbuild='sphinx-build'
  alias sphapidoc='sphinx-apidoc'
  alias sphgen='sphinx-autogen'
  # Jupyter
  alias jpnb='jupyter-notebook'
  alias jpto='jupyter nbconvert --to'

  # Python template
  alias cookieml='cookiecutter https://github.com/drivendata/cookiecutter-data-science'
  alias cookiegeneral='cookiecutter git@github.com:audreyr/cookiecutter-pypackage.git'
  # }}}


  # -------------------------------------------------------------------------------------------------
  # 大数据集群管理，必须要在每台机 .bashrc 环境变量设置好才起作用
  # ------------------------------------------------------------------------------------------------{{{
  # 单机伪分布式
  # alias starthdfs='start-dfs.sh && start-yarn.sh && start-master.sh && start-slaves.sh'
  # alias stophdfs='stop-dfs.sh && stop-yarn.sh && stop-master.sh && stop-slaves.sh'
  #
  # 普通集群模式
  # alias starthdfs='start-dfs.sh && ssh hadoop101 start-yarn.sh && ssh hadoop102 mr-jobhistory-daemon.sh start historyserver'
  # alias stophdfs='stop-dfs.sh && ssh hadoop101 stop-yarn.sh && ssh hadoop102 mr-jobhistory-daemon.sh stop historyserver'

  alias startvm='vboxmanage startvm "hadoop101" -type headless && vboxmanage startvm "hadoop102" -type headless'
  alias stopvm='vboxmanage controlvm "hadoop101" acpipowerbutton && vboxmanage controlvm "hadoop102" acpipowerbutton'
  alias listvm='vboxmanage list runningvms'
  alias ssh100='ssh hadoop100'
  alias ssh101='ssh hadoop101'
  alias ssh102='ssh hadoop102'
  alias ssh103='ssh hadoop103'
  alias hjps='slave_do "jps -l"'
  alias hf='hadoop fs'
  alias hyarn='/home/alanding/software/bigdata/hadoop/bin/yarn'


  # 高可用集群模式
  # 要先起 Zookeeper，服务器端口 2181
  alias zkstart='slave_do "zkServer.sh start"'
  alias zkstatus='slave_do "zkServer.sh status"'
  alias zkstop='slave_do "zkServer.sh stop"'

  alias hdfs-startall='start-dfs.sh && start-yarn.sh && ssh hadoop101 "yarn-daemon.sh start resourcemanager" && printf "\n\n" && hdfs-status'
  alias hdfs-stopall='stop-dfs.sh && stop-yarn.sh && ssh hadoop101 "yarn-daemon.sh stop resourcemanager"'
  alias log-start="ssh hadoop102 mr-jobhistory-daemon.sh start historyserver"
  alias log-stop="ssh hadoop102 mr-jobhistory-daemon.sh stop historyserver"

  # 查看及切换主从状态
  alias hdfs-status='printf "hdfs hadoop100:\n" && hdfs haadmin -getServiceState nn1 && printf "\n yarn hadoop100:\n" && hyarn rmadmin -getServiceState rm1'
  alias hdfs-trans='hdfs haadmin -transitionToStandby nn2 --forcemanual && hdfs haadmin -transitionToActive nn1 --forcemanual'
  alias yarn-trans='hyarn rmadmin -transitionToStandby rm2 --forcemanual && hyarn rmadmin -transitionToActive rm1 --forcemanual'

  # hbase
  alias hbase-start='${HBASE_HOME}/bin/start-hbase.sh'
  alias hbase-stop='${HBASE_HOME}/bin/stop-hbase.sh'
  alias hbase-service-start='hbase-daemon.sh start thrift'
  alias hbase-service-stop='hbase-daemon.sh stop thrift'
 
  # hive服务
  alias hive-start='(${HIVE_HOME}/bin/hive --service metastore &) && ${HIVE_HOME}/bin/hive --service hiveserver2 &'
  # alias hivestop=''

  # Kafka，服务器端口 9092
  # kafka 每个节点上的 server.properties 配置中 broker.id 都要不一样，否则出错
  # 开启Jmx端口，JMX_PORT=9988 bin/kafka-server-start -daemon config/server.properties
  alias kfk-start='slave_do "kafka-server-start.sh -daemon ${KAFKA_HOME}/config/server.properties"'
  alias kfk-stop='slave_do "kafka-server-stop.sh"'
  alias kfk-monitor='${BIGDATA_HOME}/kafka-offset-console/start.sh && ${BIGDATA_HOME}/kafka-manager/bin/kafka-manager'
  # alias kfkmanager='${BIGDATA_HOME}/kafka-manager/bin/kafka-manager'
  # alias kfkmonitor='${BIGDATA_HOME}/kafka-offset-console/start.sh'
  
  # hue 前面的是hadoop的服务
  alias hue-start="httpfs.sh start | docker-compose -f /home/alanding/software/bigdata/hue/docker-compose.yml up -d"
  alias hue-stop="httpfs.sh stop | docker stop hue"

  # oozie
  alias oozie-start='${OOZIE_HOME}/bin/oozied.sh start'
  alias oozie-stop='${OOZIE_HOME}/bin/oozied.sh stop'


  # ha 集群 hdfs 初始化时步骤
  alias startjn='slave_do "hadoop-daemon.sh start journalnode"'
  alias hdfsfmt='hdfs namenode -format'
  #
  # 搭ha时分步进行
  # alias startnn1='hadoop-daemon.sh start namenode'
  # alias startnn2='ssh hadoop101 "hdfs namenode -bootstrapStandby && hadoop-daemon.sh start namenode"'
  # alias activenn1='set -e slave_do "hadoop-daemon.sh start datanode" && hdfs haadmin -transitionToActive nn1 && hdfs haadmin -getServiceState nn1'
  #
  # 初始化 hadoop-ha 在 zookeeper 中的状态
  # stop-dfs.sh && zkServer.sh start && hdfs zkfc -formatZK
  # }}}


  # -------------------------------------------------------------------------------------------------
  # 系统运维命令
  # ----------------------------------------------------------------------------------------------{{{
  # less tail head 查看文件内容
  # systemctl status 查看应用状况

  #@## 1. top 查看系统整体性能

  #@## 2. CPU性能
  # vmstat -n 采样时间间隔 + 采样次数
  #   -procs
  #     r：运行等待CPU时间片的进程数，原则上1核的CPU运行队列不要超过2，整个系统的运行队列不能超过总核数的2倍，否则代表系统压力过大。
  #   -cpu
  #     us：用户进程消耗CPU时间百分比，us值高，用户进程小号CPU时间多，如果长期大于50%，优化程序；
  #     sy：内核进程消耗的CPU百分比；

  #@## 3. 查看系统已使用及可用内存信息
  #
  # !!! 查看某个进程的内存占用信息
  # pidstat -p 进程号 -r(指内存统计) + 采样间隔
  #
  alias free='free -h -s3'

  #@## 4. 查看文件系统及硬盘空间状况
  alias du="du -h --max-depth=1"

  #@## 5. 查看磁盘IO性能
  alias iostat='iostat -xdk 2, 3'
  # pidstat -p 进程号 -d(指磁盘IO统计) + 采样间隔

  #@## 6. ifstat 查看网络IO性能

  #@## 7. 监控Tcp/Ip 网络工具。显示路由表，实际网络连接，端口占用，每个网络接口设备的状态信息  
  #       -tunlp 参数说明: tcp udp --numeric-直接使用ip地址，--listening-显示监听的服务器的Socket --program-显示Socket的PID和程序名称
  #       加上 | grep PID 查看具体进程占用端口
  #       加上 | grep port 查看port 端口是否被占用
  alias netstat='netstat -tunlp'
  #
  # lsof -i tcp:80
  alias portcheck="lsof -i"

  #@## 8. 查找对应进程　PID 后接应用程序名
  alias psgrep='ps -ef | grep '

  #@## 9. CPU占用过高原因定位
  # 先用`top`找到CPU占用最高的进程，然后用`ps -mp pid -o THREAD,tid,time`，得到该**进程**里面占用最高的**线程**。
  # 这个线程是10进制的，用printf %x <填十进制数字> 将其转成16进制。将十六进制转为十进制要用printf %d 0x<填十六进制数>
  # 然后用`jstack pid | grep tid`可以定位到具体哪一行导致了占用过高。

  #@## 输出某进程<pid>并检查该进程内运行的线程状况
  # top -H -p <pid>
  # }}}


  # -------------------------------------------------------------------------------------------------
  # Java 诊断工具
  # ----------------------------------------------------------------------------------------------{{{
  # 阿里Java命令行可视化诊断工具
  alias arthas='java -jar $HOME/software/lang-tools/Java/Arthas/arthas-boot.jar'

  # jps -v JVM启动时参数列表
  #     -m 传给主类参数
  #     -l 列出主类、Jar包位置
  alias jps='jps -l'

  # jstat -gcutil `pid` 3s
  #       监视虚拟机内存使用情况百分比
  #       -gc `pid` 3s
  #       监视虚拟机内存使用情况实际大小
  # alias jstat='jstat -gcutil'

  # jinfo 实时查看和调整虚拟机各项参数
  # 查看某个参数
  # jps -l 配合 jinfo -flag  JVM参数名 pid
  # jps -l 配合 jinfo -flags pid

  # 查看JVM运行线程状态，定位CPU占用过高，线程长时间停顿原因，如死锁、死循环、请求外部资源等。
  # -l 输出锁信息，
  # -F 强制输出线程堆栈，
  # -m 如调用本地方法，可显示C/C++堆栈。
  alias jstack='jstack -l'

  # jmap 生成堆转储快照，手工直接导，PID为进程号
  # jmap -dump:live,format=b,file=m.hprof PID

  # -XX:+PrintGCDetails
  # }}}

}
# }}}


# ==================================================================================
# Environment Variable Definition
# =============================================================================== {{{
DefEnVar() {
  export TERM=xterm-256color

  export ALANDOTFILE=/mnt/fun+downloads/my-Dotfile
  export DEVFILE=/home/alanding/0_Dev/

  # Preferred editor for local and remote sessions
  export EDITOR=/opt/vim/nvim-linux64/bin/nvim

  # Browser for ensime
  export BROWSER="google-chrome %s"

  # Git
  export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
  export LESSCHARSET=utf-8

  # Conda
  export CONDA=/home/alanding/software/anaconda3
  export PATH=$CONDA/envs/py37/bin:$PATH
  \. $CONDA/etc/profile.d/conda.sh
  # MiniConda
  # export PATH=//home/alanding/software/lang-tools/miniconda/bin:$PATH
  # \. /home/alanding/software/lang-tools/miniconda/etc/profile.d/conda.sh
  alias condacheat='okular $HOME/.SpaceVim.d/cheats/conda-cheatsheet.pdf'

  # Pip cli completion
  eval "`pip completion --zsh`"

  # CUDA
  export CUDA_HOME=/home/alanding/software/lang-tools/cuda/cuda-10.0
  export PATH=$CUDA_HOME/bin:$PATH
  export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
  export CUDA_DEVICE_ORDER="PCI_BUS_ID"
  export CUDA_VISIBLE_DEVICES="0,1,2,3"

  # OpenCV
  export OPENCV_HOME=/opt/lang-tools/cpp/opencv/
  export PATH=$OPENCV_HOME/bin:$PATH

  # Clang
  export CLANG_HOME=/opt/lang-tools/cpp/clang
  export PATH=${CLANG_HOME}/bin:${CLANG_HOME}/lib:${CLANG_HOME}/libexec:$PATH
  # Cmake
  # export PATH=/opt/lang-tools/cpp/cmake/bin:$PATH

  # Rust
  export RUSTUP_HOME=/opt/lang-tools/rust/rustup
  export CARGO_HOME=/home/alanding/software/lang-tools/cargo
  export PATH=$CARGO_HOME/bin:$PATH

  export RUST_SRC_PATH=$RUSTUP_HOME/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
  export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
  export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

  # Go
  export GOROOT=/opt/lang-tools/go/go
  export PATH=$GOROOT/bin:$PATH
  export GOPATH=/home/alanding/software/lang-tools/go
  export PATH=$GOPATH/src:$PATH
  export GOBIN=/home/alanding/software/lang-tools/go/bin
  export PATH=$GOBIN:$PATH
  # export GO111MODULE=on


  # Tomcat
  # export PATH=/home/alanding/software/web-server/tomcat/bin:$PATH

  # Java
  export JAVA_HOME=/opt/lang-tools/java/jdk
  export JRE_HOME=${JAVA_HOME}/jre
  export PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin:$PATH
  # Maven
  export MAVEN_HOME=/opt/lang-tools/java/maven
  export PATH=${MAVEN_HOME}/bin:$PATH
  # Gradle
  export GRADLE_User_HOME=/opt/lang-tools/java/gradle
  export PATH=${GRADL_HOME}/bin:$PATH
  # Ant
  export ANT_HOME=/opt/lang-tools/java/ant
  export PATH=${ANT_HOME}/bin:$PATH


  # Scala
  export SCALA_HOME=/opt/lang-tools/scala/scala
  export PATH=${SCALA_HOME}/bin:$PATH
  export PATH=/opt/lang-tools/scala:$PATH
  export PATH=/opt/lang-tools/scala/coc:$PATH
  # Sbt
  export PATH=/opt/lang-tools/scala/sbt/bin:$PATH


  export BIGDATA_HOME=/home/alanding/software/bigdata
  # Redis
  export REDIS_HOME=$BIGDATA_HOME/redis
  export PATH=${REDIS_HOME}/bin:$PATH

  # Hadoop
  export HADOOP_HOME=$BIGDATA_HOME/hadoop
  export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH
  # Spark
  export SPARK_HOME=$BIGDATA_HOME/spark
  export PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH
  # Pyspark
  export PYSPARK_DRIVER_PYTHON=jupyter
  export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
  export PYSPARK_PYTHON=$CONDA/envs/py37/bin/python3.7
  # Flink
  export FLINK_HOME=$BIGDATA_HOME/spark
  export PATH=${FLINK_HOME}/bin:$PATH
  # Hive
  export HIVE_HOME=$BIGDATA_HOME/hive
  export PATH=${HIVE_HOME}/bin:$PATH
  # Hbase
  export HBASE_HOME=$BIGDATA_HOME/hbase
  export PATH=${HBASE_HOME}/bin:$PATH
  # Zookeeper
  export ZOOKEEPER_HOME=$BIGDATA_HOME/zookeeper
  export PATH=${ZOOKEEPER_HOME}/bin:$PATH
  # Kafka
  export KAFKA_HOME=$BIGDATA_HOME/kafka
  export PATH=${KAFKA_HOME}/bin:$PATH
  # Oozie
  export OOZIE_HOME=$BIGDATA_HOME/oozie
  export PATH=${OOZIE_HOME}/bin:$PATH


  # Node version manager
  export NVM_DIR="/opt/lang-tools/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  # autoload -U add-zsh-hook
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

  # Node yarn not hadoop`s
  export PATH=`dirname $(which node)`:$PATH

  #lua
  export PATH=/opt/lang-tools/lua/luarocks/bin:$PATH

  # # Ruby
  # # if [ $UID -ne 0 ]; then
  # if [[ `whoami` != "root" ]]; then
  #   export PATH=$HOME/.rbenv/bin:$PATH
  #   eval "$(rbenv init -)"
  #   if [[ -x gem ]]; then
  #     \. $(dirname $(gem which colorls))/tab_complete.sh
  #   fi
  # fi


  # Vim
  export VIM_HOME=/opt/vim
  export PATH=${VIM_HOME}/vim8.1/bin:$PATH
  export PATH=${VIM_HOME}/nvim-linux64/bin:$PATH
  # Neovim-remote/spacevim
  export PATH=$HOME/.SpaceVim/bin:$PATH
  # Ctags and Gtags
  export PATH=/opt/vim/universal-ctags/bin:$PATH
  export PATH=/opt/vim/gtags/bin:$PATH
  export GTAGSLABEL=native-pygments
  export GTAGSCONF=$HOME/.globalrc
  # LanguageTool
  export LANGUAGE_TOOL_HOME=/opt/vim/LanguageTool


  # .net
  # export PATH=/opt/lang-tools/csharp:$PATH

  # Julia
  # export PATH=/opt/lang-tools/julia/julia/bin:$PATH

  # Emacs
  # export EMACS_HOME=/opt/emacs
  # export PATH=${EMACS_HOME}/emacs/bin:$PATH

  # TEX
  export PATH=/home/alanding/software/command-line-tools/texlive/2018/bin/x86_64-linux:$PATH
  export MANPATH=/home/alanding/software/command-line-tools/texlive/2018/texmf-dist/doc/man:$MANPATH
  export INFOPATH=/home/alanding/software/command-line-tools/texlive/2018/texmf-dist/doc/info:$INFOPATH

  # postman, vagrant, chromedriver ...
  export PATH=/home/alanding/software/command-line-tools:$PATH
}
# }}}


# ==================================================================================
# Load Configuration
# ==============================================================================# {{{
ZshSettings
DefAlias
DefEnVar

FzfConfig
# nv jj 触发fzf搜索当前目录文件
# }}}

