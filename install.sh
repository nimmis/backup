#!/bin/sh

etc_dir=/etc/backup
lib_dir=/usr/local/lib/backup
exe_dir=/usr/local/bin


install() {
  # make sure etc directory exists
  mkdir -p ${etc_dir}
  # make sure lib directory exists
  mkdir -p ${lib_dir}
  # make sure exec directory exists
  mkdir -p ${exe_dir}

  BASEDIR=$(dirname "$0")
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
       echo "config file ${lib_dir}/${1}.lib already exists, renaming old as ${lib_dir}/${1}.conf.old"
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

install_all() {
  for install_mod in `ls -l | grep ^d | awk '{print $NF}'`
  do
    echo "mod=${install_mod}"
  done
}
install_all

