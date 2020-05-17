#!/bin/sh
#

# PROJECTPATH contains the full
# directory path of the project itself
PROJECTPATH=$(pwd)

# CONFIGFOLDER contains the path
# to the config folder.
CONFIGFOLDER="$PROJECTPATH/.warp/docker/config"

# SSLCERTIFICATEFOLDER contains the path
# to the SSL certificate folder that is used by Nginx.
SSLCERTIFICATEFOLDER="$CONFIGFOLDER/nginx/ssl"

# ENVIRONMENTVARIABLESFILE contains the path
# to the file that holds the required environment
# variables for this script.
ENVIRONMENTVARIABLESFILESAMPLE="$PROJECTPATH/.env.sample"

# ENVIRONMENTVARIABLESFILE contains the path
# to the file that holds the required environment
# variables for this script.
ENVIRONMENTVARIABLESFILE="$PROJECTPATH/.env"

# Check self update
CHECK_UPDATE_FILE="$PROJECTPATH/.self-update-warp"
CHECK_FREQUENCY_DAYS=7

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose.yml sample file
DOCKERCOMPOSEFILESAMPLE="$PROJECTPATH/docker-compose-warp.yml.sample"

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose.yml file
DOCKERCOMPOSEFILE="$PROJECTPATH/docker-compose-warp.yml"

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose for selenium yaml file
DOCKERCOMPOSEFILESELENIUM="$PROJECTPATH/docker-selenium-warp.yml"

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose.yml file
DOCKERCOMPOSEFILEMAC="$PROJECTPATH/docker-compose-warp-mac.yml"

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose.yml sample file
DOCKERCOMPOSEFILEMACSAMPLE="$PROJECTPATH/docker-compose-warp-mac.yml.sample"

# DOCKERCOMPOSEFILE contains the path
# to the docker-sync.yml file
DOCKERSYNCMAC="$PROJECTPATH/docker-sync.yml"

# DOCKERCOMPOSEFILE contains the path
# to the docker-sync.yml sample file
DOCKERSYNCMACSAMPLE="$PROJECTPATH/docker-sync.yml.sample"

# PROJECTPATH FRAMEWORK
WARPFOLDER="$PROJECTPATH/.warp"

# FILE TO GIT IGNORE
GITIGNOREFILE="$PROJECTPATH/.gitignore"

# FILE TO IGNORE WARP FOLDER IN DOCKER CP
DOCKERIGNOREFILE="$PROJECTPATH/.dockerignore"

# NETWORK NAME
NETWORK_NAME="warp_net"

# Set minimum range IP in Containers
MIN_RANGE_IP=20

# SET PATH TO BINARY WARP
WARP_BINARY_FILE="/usr/local/bin/warp"

# SET STRONG PASSWORD LENGTH
STRONG_PASSWORD_LENGTH=8

# Set minimum version for docker-compose
DOCKER_COMPOSE_MINIMUM_VERSION=1.21

# Set minimum version for rsync
RSYNC_MINIMUM_VERSION=3.1.1

# Set docker-compose timeout, default 60
DOCKER_COMPOSE_HTTP_TIMEOUT=300

# Set minimum version for Docker
DOCKER_MINIMUM_VERSION=17.05

## SANDBOX MODE
VHOST_M22_CE="local.m229-ce.com"
VHOST_M23_CE="local.m231-ce.com"

DB_M22_CE="m229_ce"
DB_M23_CE="m231_ce"

ES_SBMEM="1g"
ES_SB1="5.6.8"
ES_SB2="6.4.2"
ES_SBVER="5.6.8|6.4.2"
ES_SBHOST="elasticsearch56|elasticsearch64"

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose.yml file
DOCKERCOMPOSEFILEDEV="$PROJECTPATH/docker-compose-warp-dev.yml"

# DOCKERCOMPOSEFILE contains the path
# to the docker-compose.yml sample file
DOCKERCOMPOSEFILEDEVSAMPLE="$PROJECTPATH/docker-compose-warp-dev.yml.sample"