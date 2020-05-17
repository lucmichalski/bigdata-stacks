# User Env variables
$userpath = "%SCOOP%\shims;%VSCODE%;"
$path2    = $userpath + $env:Path
[Environment]::SetEnvironmentVariable("PATH", $path2, "User")


[Environment]::SetEnvironmentVariable("IntelliJ IDEA Community Edition", "C:\DevTools\IntelliJ IDEA Community Edition 2019.1\bin", "User")
[Environment]::SetEnvironmentVariable("MOZ_PLUGIN_PATH"                , "D:\Office Tools\Foxit Reader\plugins"                  , "User")
[Environment]::SetEnvironmentVariable("NVM_HOME"                       , "D:\devtools\nodejs\nvm-win"                            , "User")
[Environment]::SetEnvironmentVariable("NVM_SYMLINK"                    , "C:\Program Files\nodejs"                               , "User")
[Environment]::SetEnvironmentVariable("SCOOP"                          , "D:\devtools\Scoop"                                     , "User")
[Environment]::SetEnvironmentVariable("VSCODE"                         , "C:\DevTools\Microsoft VS Code\bin"                     , "User")


## System Env variables

# default conda settings
# $syspath = "C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;%JAVA_HOME%;%JAVA_HOME%\bin;%JAVA_HOME%\lib;%JRE_HOME%;%JRE_HOME%\bin;%JRE_HOME%\lib;%CONDA_HOME%\Library\mingw-w64\bin;%CONDA_HOME%\Library\usr\bin;%CONDA_HOME%\Library\bin;%CONDA_HOME%\Scripts;%NVM_HOME%;%NVM_SYMLINK%;%CMDER_ROOT%;%ConEmuDir%;%CMDER_Git%;%MAVEN%;%SCALA_HOME%;%SCALA_HOME%\bin;%SCALA_HOME%\lib;%SBT_HOME%\bin;%SPARK_HOME%;%SPARK_HOME%\bin;%SPARK_HOME%\sbin;%HADOOP_HOME%\bin;%U_CTAGS%;%GTAGS%;%GTM%;%NEOVIM%;%NEOVIM_REMOTE_SPACEVIM%;%CUDA_HOME%\10.0\bin;%CUDA_HOME%\10.0\include;%CUDA_HOME%\10.0\lib;%PSModulePath%;%SCOOP_GLOBAL%\shims;%VSCODE%;%BANDIZIP%;%NMAKE%;%CLANG_HOME%\bin;%CLANG_HOME%\lib;%CLANG_HOME%\libexec;%GNUWIN32%\bin;%COREUTILS%;%GAWK%;%GREP%;%SED%;%CMAKE%;%MINGW-W64%;"

# use virtual py36 as default python env, 32bit win-gtags version
$syspath = "C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;%JAVA_HOME%;%JAVA_HOME%\bin;%JAVA_HOME%\lib;%JRE_HOME%;%JRE_HOME%\bin;%JRE_HOME%\lib;%CONDA_MINGW64%;%CONDA_HOME%\Library\bin;%CONDA_PY36_HOME%;%CONDA_PY36_HOME%\Scripts;%NVM_HOME%;%NVM_SYMLINK%;%CMDER_ROOT%;%CMDER_Git%;%ConEmuDir%;%MAVEN%;%SCALA_HOME%;%SCALA_HOME%\bin;%SCALA_HOME%\lib;%SBT_HOME%\bin;%SPARK_HOME%;%SPARK_HOME%\bin;%SPARK_HOME%\sbin;%HADOOP_HOME%;%HADOOP_HOME%\bin;%U_CTAGS%;%GTAGS%;%GTM%;%NEOVIM%;%NEOVIM_REMOTE_SPACEVIM%;%CUDA_HOME%\10.0\bin;%CUDA_HOME%\10.0\include;%CUDA_HOME%\10.0\lib;%PSModulePath%;%SCOOP_GLOBAL%\shims;%VSCODE%;%BANDIZIP%;%NMAKE%;%CLANG_HOME%\bin;%CLANG_HOME%\lib;%CLANG_HOME%\libexec;%GNUWIN32%\bin;%COREUTILS%;%GAWK%;%GREP%;%SED%;%CMAKE%;%MINGW-W64%;"
$path1   = $syspath + $env:Path
[Environment]::SetEnvironmentVariable("PATH", $path1, "Machine")


[Environment]::SetEnvironmentVariable("JAVA_HOME"             , "D:\devtools\java\jdk"                                    , "Machine")
[Environment]::SetEnvironmentVariable("JRE_HOME"              , "%JAVA_HOME%\jre"                                         , "Machine")
[Environment]::SetEnvironmentVariable("MAVEN"                 , "D:\devtools\java\apache-maven-3.6.0\bin"                 , "Machine")
[Environment]::SetEnvironmentVariable("CONDA_HOME"            , "D:\devtools\python\Anaconda3"                            , "Machine")
[Environment]::SetEnvironmentVariable("CONDA_MINGW64"         , "%CONDA_HOME%\Library\mingw-w64\bin"                      , "Machine")
[Environment]::SetEnvironmentVariable("CONDA_PY36_HOME"       , "%CONDA_HOME%\envs\py36"                                  , "Machine")
[Environment]::SetEnvironmentVariable("CLANG_HOME"            , "D:\devtools\cpp\LLVM"                                    , "Machine")
[Environment]::SetEnvironmentVariable("CMDER_Git"             , "C:\DevTools\cmder\vendor\git-for-windows\bin"            , "Machine")
[Environment]::SetEnvironmentVariable("CMDER_ROOT"            , "C:\DevTools\cmder"                                       , "Machine")
[Environment]::SetEnvironmentVariable("ConEmuDir"             , "C:\DevTools\cmder\vendor\conemu-maximus5"                , "Machine")
[Environment]::SetEnvironmentVariable("NVM_HOME"              , "D:\devtools\nodejs\nvm-win"                              , "Machine")
[Environment]::SetEnvironmentVariable("NVM_SYMLINK"           , "C:\Program Files\nodejs"                                 , "Machine")
[Environment]::SetEnvironmentVariable("NEOVIM"                , "C:\DevTools\Vim\Neovim-qt\bin"                           , "Machine")
[Environment]::SetEnvironmentVariable("NEOVIM_REMOTE_SPACEVIM", "C:\Users\Administrator\.SpaceVim\bin"                    , "Machine")
[Environment]::SetEnvironmentVariable("NMAKE"                 , "C:\DevTools\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.20.27508\bin\Hostx86\x86",  "Machine")
[Environment]::SetEnvironmentVariable("CMAKE"                 , "D:\\devtools\cpp\CMake\bin"                              , "Machine")
[Environment]::SetEnvironmentVariable("MINGW-W64"             , "D:\\devtools\cpp\\MinGW-W64 GCC-8.1.0\bin"               , "Machine")
[Environment]::SetEnvironmentVariable("SCALA_HOME"            , "D:\devtools\scala\scala-2.12.8"                          , "Machine")
[Environment]::SetEnvironmentVariable("SBT_HOME"              , "D:\devtools\scala\sbt1.2.8"                              , "Machine")
[Environment]::SetEnvironmentVariable("SPARK_HOME"            , "D:\devtools\spark\spark-2.4.1-bin-hadoop2.7"             , "Machine")
[Environment]::SetEnvironmentVariable("HADOOP_HOME"           , "D:\devtools\spark\hadoop-3.0.0"                          , "Machine")
[Environment]::SetEnvironmentVariable("GNUWIN32"              , "C:\DevTools\GnuWin32"                                    , "Machine")
[Environment]::SetEnvironmentVariable("COREUTILS"             , "C:\DevTools\GnuWin32\coreutils"                          , "Machine")
[Environment]::SetEnvironmentVariable("GAWK"                  , "C:\DevTools\GnuWin32\gawk"                               , "Machine")
[Environment]::SetEnvironmentVariable("GREP"                  , "C:\DevTools\GnuWin32\grep"                               , "Machine")
[Environment]::SetEnvironmentVariable("GTAGS"                 , "C:\DevTools\GnuWin32\gtags"                              , "Machine")
# this will cause conflict with clion mingw-w64-32-make.exe
# [Environment]::SetEnvironmentVariable("MAKE"                  , "C:\DevTools\GnuWin32\make"                               , "Machine")
[Environment]::SetEnvironmentVariable("SED"                   , "C:\DevTools\GnuWin32\sed"                                , "Machine")
[Environment]::SetEnvironmentVariable("U_CTAGS"               , "C:\DevTools\GnuWin32\universal-ctags"                    , "Machine")
[Environment]::SetEnvironmentVariable("GTM"                   , "C:\DevTools\Vim\gtm"                                     , "Machine")
[Environment]::SetEnvironmentVariable("CUDA_HOME"             , "C:\DailySoftware\Cuda"                                   , "Machine")
[Environment]::SetEnvironmentVariable("SCOOP"                 , "D:\devtools\Scoop"                                       , "Machine")
[Environment]::SetEnvironmentVariable("SCOOP_GLOBAL"          , "%SCOOP%\GlobalScoopApps"                                 , "Machine")
[Environment]::SetEnvironmentVariable("VS140COMNTOOLS"        , "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\", "Machine")
[Environment]::SetEnvironmentVariable("VSCODE"                , "C:\DevTools\Microsoft VS Code\bin"                       , "Machine")
[Environment]::SetEnvironmentVariable("BANDIZIP"              , "C:\DailySoftware\Bandizip"                               , "Machine")
