#!/usr/bin/env bash

# Define directories.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

XDEBUG_VERSION=${1-2.8.0}

INSTALL_PATH="/app/.heroku/php/etc/php/conf.d/";

# echo colors
LED='\033[0;34m'
OK='\033[0;32m'
NC='\033[0m' # No Color
#############

###########################################################################
# COMPILE PHP xDebug
###########################################################################

XDEBUG_RELEASE_URI="https://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz";
SRC_PATH="/tmp";
XDEBUG_SRC_PATH=$SRC_PATH/xdebug-$XDEBUG_VERSION

echo -e "${LED}XDEBUG${NC}: Download $XDEBUG_RELEASE_URI ..."
mkdir -p $XDEBUG_SRC_PATH
curl $XDEBUG_RELEASE_URI| tar --warning=none -xz -C $SRC_PATH
echo -e "${OK}done${NC}"

# Build from repo
#echo -e "${LED}XDEBUG${NC}: Cloning source to $XDEBUG_SRC_PATH ..."
#git clone git://github.com/xdebug/xdebug.git $XDEBUG_SRC_PATH
#echo -e "${OK}done${NC}"

echo -e "${LED}XDEBUG${NC}: Compile at $XDEBUG_SRC_PATH ..."
cd $XDEBUG_SRC_PATH
echo $PWD

LOGFILE=/tmp/xdebug_build.log
echo -e "`date +%H:%M:%S` : Starting work" >> $LOGFILE
phpize > $LOGFILE 2>&1
./configure --enable-xdebug  > $LOGFILE 2>&1
make -k > $LOGFILE 2>&1
echo -e "${OK}done${NC}"

###########################################################################
# INSTALL PHP xDebug
###########################################################################

EXTENSION_PATH=$( php-config --extension-dir );
XDEBUG_INI="20-xdebug.ini";
XDEBUG_INI_PATH=$SCRIPT_DIR/$XDEBUG_INI;

echo -e "${LED}XDEBUG${NC}: Install bin to $EXTENSION_PATH ..."
cp -v modules/xdebug.* $EXTENSION_PATH
echo -e "${OK}done${NC}"

echo -e "${LED}XDEBUG${NC}: Install ini to $INSTALL_PATH ..."
cp -v $XDEBUG_INI_PATH $INSTALL_PATH/$XDEBUG_INI
echo -e "${OK}done${NC}"

###########################################################################
