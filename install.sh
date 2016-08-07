#!/bin/sh
#
# install script for backup
#
# (c) 2016 nimmis <kjell.havneskold@gmail.com>
#

etc_dir=/usr/local/etc/backup
lib_dir=/usr/local/lib/backup
exe_dir=/usr/local/bin
cmd=${1}
BASEDIR=$(dirname "$0") 

install() {
  # make sure etc directory exists
  mkdir -p ${etc_dir}
  # make sure lib directory exists
  mkdir -p ${lib_dir}
  # make sure exec directory exists
  mkdir -p ${exe_dir}

  # prevent infinite loop
  if [ "${1}" != "backup" ]; then
    # make sure that the base modules is installed
    pre_check
  fi

  echo "Installing ${1}"
  SOURCE="${BASEDIR}/${1}"

  if [ ! -d ${SOURCE} ]; then
    echo "module ${1} not available for installation"
    exit 1
  fi

  # check for preconfig config file
  if [ -f ${SOURCE}/${1}.conf ]; then
    # check if a version already exists
    if [ -f ${etc_dir}/${1}.conf ]; then
      echo "config file ${etc_dir}/${1}.conf already exists, saving it as ${etc_dir}/${1}.conf.new"
      cp ${SOURCE}/${1}.conf ${etc_dir}/${1}.conf.new
    else
      cp ${SOURCE}/${1}.conf ${etc_dir}/${1}.conf 
    fi
  fi

  # check for library file
  if [ -f ${SOURCE}/${1}.lib ]; then
     # check if a version already exists
    if [ -f ${lib_dir}/${1}.lib ]; then
       echo "config file ${lib_dir}/${1}.lib already exists, renaming old as ${lib_dir}/${1}.lib.old"
       mv ${lib_dir}/${1}.lib ${lib_dir}/${1}.lib.old
    fi
    cp ${SOURCE}/${1}.lib ${lib_dir}/${1}.lib
  fi

  # check if new command file
  if [ -f ${SOURCE}/${1} ]; then
     # check if a version already exists
     if [ -f ${exe_dir}/${1} ]; then
        echo "shell script ${exe_dir}/${1} already exists, renaming old as ${exe_dir}/${1}.old"
        mv ${exe_dir}/${1} ${exe_dir}/${1}.old
     fi
     cp ${SOURCE}/${1} ${exe_dir}/${1}
  else
    # make softlink to master file
    ln -sf ${exe_dir}/backup ${exe_dir}/${1}
  fi  
}

#
# check that backup has been installed before installing any other module
#
pre_check() {
  if [ ! -f ${exe_dir}/backup ]; then
    install backup
  fi
}

#
# list all modules available to install
#

list_all() {
  printf "%-20s%s\n" "Module" "Info"
  for install_mod in `ls -l ${BASEDIR}/ | grep ^d | awk '{print $NF}'`
  do
    INFO=""
    printf "%-20s" ${install_mod}  
    if [ -f ${BASEDIR}/${install_mod}/INFO.TXT ]; then
       head -1 ${BASEDIR}/${install_mod}/INFO.TXT
    else
      echo ""
    fi
  done
}

#
# install all modules
#

install_all() {

  for install_mod in `ls -l ${BASEDIR}/ | grep ^d | awk '{print $NF}'`
  do
    install ${install_mod}
  done
}

show_help() {
  echo "$0 <command>"                                
  echo                                                                                             
  echo "command to install backup program and addons"
  echo                                                       
  echo "Command                Information"                  
  echo "help                   show this information"          
  echo "all                    Install backup and all addons"  
  echo "list                   List all addons available"      
  echo "backup                 Basic installation of backup scripts"
  echo "<addon>                Install <addon> addon to backup"
}

case ${cmd} in
list)
  list_all
  ;;
help)
  show_help
  ;;
all)
  install_all
  ;;
*)
  if [ -z ${cmd} ] ||
     [ ! -d ${BASEDIR}/${cmd} ]; then
    show_help
  else
    install ${cmd}
  fi
  ;;
esac
