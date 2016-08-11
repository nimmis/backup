# Backup
A shell script to make backups using cron. The script make it possible to

- specify a backup scheduled interval
- define source of backups
- define destination of backups
- define number of copies to retain

For a description of the backup commands, please go to the [**Basic commands**](#basic) section.

## Using backup in docker containers


This backup application is used in my docker containers to make backups of vital information, for installing the application yourself please goto the [**Installation**](#installation) section in this description. The backup is included in the following docker containers

- [nimmis/alpine-micro](https://hub.docker.com/r/nimmis/alpine-micro/)
- [nimmis/alpine-apache](https://hub.docker.com/r/nimmis/alpine-apache/)

For the schedule (cron) in backup to work the container must be started as a daemon and no new start command used. Otherwise you are responsible to start the cron daemon.

In a comming release there will be instruction who do do a multihost replication of the backup data, stay tuned

There is no need to open a shell to the container to do backup configuration, this can be done with the **docker exec**, starting an apache container and then enable backup for the /web/html as the application writes data inside this directory.

Begin by creating the container

	~$ docker run -d --name web -P nimmis/alpine-apache
	
executing the **backup** command without parameters gives list of avaliable commands
  
  	~$ docker exec web backup
	creating backupdirectory /backup/2866fd20493d/backup
	/usr/local/bin/backup <command> [<parameters>]
	
	command to controll backup of database in container

	Command                Information
	status                 gives the status of backup (active/	disabled/number of backups/disk size)
	disable                disable backup
	enable                 enable backup
	destination <dir>      set backup-file destination (default /	backup/<hostname>/<cmdname>)
	retain <num>           set number of backup to retain
	schedule <inter>       set sceduled intervall between backups (hour/day/week/month)
	show                   show currently saved backups
	backup                 run backup now
	help                   Show this information
	list                   list current directories
	add <src>              add directory to backup
	remove <src>           remove directory from backup

First setup which directories to do backup of, repeat for each directory

	~$ docker exec web backup add /web/html
	
Check which directories is listed for backup

	~$ docker exec web backup list
	backup of /web/html, estimated size 8.0KB


Set up a backup plan, daily and retain for 30 days

	~$ docker exec web backup schedule 1d
	~$ docker exec web backup retain 30
	
Check the setting so that they are correct

	~$ docker exec web backup status
	Backup is disabled
	Active backups 0 of maximum 30
	Backup interval 1d (cron 0 0 */1 * *)
	Latest backup file 
	Total size of backups 4.0KB
	Backup destination directory is /backup/2866fd20493d/backup
 
Default destination is /backup/<hostname>/<backup module name>, you can change this with

	~$ docker exec web backup destination /new/directory/path
	
but the naming is used for the possibility to share a commong volume for all container backups, making uniq directories for earch container.

Last command to do is to activate the defined backup schema
	
	~$ docker exec web backup enable

It is possible to add manual backups to the backup, please remember that they are counted in the number of copies to retain

	~$ docker exec web backup backup
	backup of /web/html, size 8.0KB compressed 4.0KB
	
You can always check the current status with (i have used 1m interval just to create more files)

	~$ docker exec web backup status
	Backup is active
	Active backups 11 of maximum 30
	Backup interval 1d (cron 0 0 */1 * *)
	Latest backup file backup-2016_08_11_10_25.tar
	Total size of backups 48.0KB
	Backup destination directory is /backup/2866fd20493d/backup


and list current backups available 

	~$ docker exec web backup show
	list of backups
	-rw-r--r--    1      3072 Aug 11 10:15 backup-2016_08_11_10_15.tar
	-rw-r--r--    1      3072 Aug 11 10:16 backup-2016_08_11_10_16.tar
	-rw-r--r--    1      3072 Aug 11 10:17 backup-2016_08_11_10_17.tar
	-rw-r--r--    1      3072 Aug 11 10:18 backup-2016_08_11_10_18.tar
	-rw-r--r--    1      3072 Aug 11 10:19 backup-2016_08_11_10_19.tar
	-rw-r--r--    1      3072 Aug 11 10:20 backup-2016_08_11_10_20.tar
	-rw-r--r--    1      3072 Aug 11 10:21 backup-2016_08_11_10_21.tar
	-rw-r--r--    1      3072 Aug 11 10:22 backup-2016_08_11_10_22.tar
	-rw-r--r--    1      3072 Aug 11 10:23 backup-2016_08_11_10_23.tar
	-rw-r--r--    1      3072 Aug 11 10:24 backup-2016_08_11_10_24.tar
	-rw-r--r--    1      3072 Aug 11 10:25 backup-2016_08_11_10_25.tar

To pause the backup do

	~$ docker exec web backup disable
	
## extra modules included

The following modues are included (besides the base module)

- [database mysql/mariadb](#mysql)


## <a name="installation"></a>Installation

Download the scripts from the github repository either as 
[zip](https://github.com/nimmis/backup/archive/master.zip) or [tar](https://github.com/nimmis/backup/archive/master.tar.gz)

### Download and unpack

Download and unpack it in /tmp,

for zip

	wget https://github.com/nimmis/backup/archive/master.zip
	unzip master.zip
	rm master.zip
	cd backup-master
	
and for tar

	wget https://github.com/nimmis/backup/archive/master.tar.gz
	tar xfz master.tar.gz
	rm master.tag.gz
	cd backup-master
	
of alternative for tar

	curl --sL https://github.com/nimmis/backup/archive/master.tar.gz | tar xfz -
	cd backup-master

### running ./install.sh

To install the scripts an installation script is used, run

	./install.sh
	
	command to install backup program and addons

	Command                Information
	help                   show this information
	all                    Install backup and all addons
	list                   List all addons available
	backup                 Basic installation of backup scripts
	<addon>                Install <addon> addon to backup


### showing available backup modules

The command *backup* is the basecommand for backing up directories, then additional modules are added to do backups on other types of data, databases etc. Using *./install.sh list* gives a list of all currently avaliable modules

	./install.sh list
	Module              Info
	backup              base module (installs always)
	backup_mysql        backup module for mysql/mariadb
	backup_skel         Skeleton layout for new backup module
	
### installing all modules

Using the command ./install.sh all, all modules are installed.
This command needs permission to create and write files in /etc/ and /usr/local so it has to be run as root

	sudo ./install.sh all
	Installing backup
	Installing backup_mysql
	Installing backup_skel

The command lists all modules it installes

### installing specific modules

If only one of the modules is needed, using ./install <module name> only installs that module. All backup modules need the base modules backup so it is automaticly installed

Installing the mysql bakup modules

	sudo ./install.sh backup_mysql
	Installing backup
	Installing backup_mysql
	
### optional, remove install directory

The install files are not needed any more so they can be removed

	cd ..
	rm -Rf backup-master

## Konfigurationfiles in /usr/local/etc/backup

Each backupcommand as a configuration file in the directory /usr/local/etc/backup/ with the syntax < backup command name >.conf

## Basic commands (applies to all modules)

### status

    >backup status
    Active backups 10 of maximum 10
    Backup interval 1m (cron */1 * * * *)
    Latest backup file backup-2016_07_29_20_24.tar
    Total size of backups 2.2MB
    Backup destination directory is /backup/57375490a540

### enable

	>backup enable
	
enable activate the cronjob to do backups with the interval defined by *set-interval*

### disable

	>backup disable
	
deisable the cronjob to do backups, no backupfile is removed by this command

### destination < destination directory >

	>backup destination /backup/server1
	
*destination* defines where the backups should be stored, if the directory does not exist it will be created.

Default the backup directory will be set to the following directory path

	/backup/<server host name>/<name of backup command>
	
So for the standard backup command *backup* on a machine with the follow hostname

	>hostname
	2932bf7bc114
	
will do backups to directory

	/backup/2932bf7bc114/backup
	
The use of hostname makes it possible to use a shared volume to backup multiple hosts without overwriting other host backups

### retain < copies to retain >

	>backup retain 5
	
Defines how many backups to retain, when the defined number is reached the oldest will be removed.

Default setting i 5

### schedule < backup interval >

	>backup schedule 1d
	
This command defined the scheduled interval between the backups. The interval is defined as <number><unit> where units are

|unit name|description|
|--------:|-----------|
| m | <num>m interval i minutes |
| h | <num>h interval i hours |
| d | <num>d interval i days |
| M | <num>M interval i months |



### show

    >backup show
    list of backups
    -rw-r--r--    1    214016 Jul 29 20:19 backup-2016_07_29_20_19.tar
    -rw-r--r--    1    214016 Jul 29 20:20 backup-2016_07_29_20_20.tar
    -rw-r--r--    1    214016 Jul 29 20:21 backup-2016_07_29_20_21.tar
    -rw-r--r--    1    214016 Jul 29 20:22 backup-2016_07_29_20_22.tar
    -rw-r--r--    1    214016 Jul 29 20:23 backup-2016_07_29_20_23.tar
    -rw-r--r--    1    214016 Jul 29 20:24 backup-2016_07_29_20_24.tar
    -rw-r--r--    1    214016 Jul 29 20:25 backup-2016_07_29_20_25.tar
    -rw-r--r--    1    214016 Jul 29 20:26 backup-2016_07_29_20_26.tar
    -rw-r--r--    1    214016 Jul 29 20:27 backup-2016_07_29_20_27.tar
    -rw-r--r--    1    214016 Jul 29 20:28 backup-2016_07_29_20_28.tar
    
Shows the current backups stored at the backupdirectory
    
### backup

    >backup backup
	backup of /etc, size 1.3MB compressed 192.0KB
	backup of /lib, size 3.3MB compressed 1.6MB
    
Execute a manual backup of the selected items (directories, databases etc)

Show one line for each backuped item with uncompressed/compressed size

## Commands for /usr/local/bin/backup

### list

Lista all directories configured for backup

	backup add /etc
	backup add /lib
	backup list
	backup of /etc, estimated size 1.3MB
	backup of /lib, estimated size 3.3MB
	
The list show the estimated uncompessed size of the backup

### remove < source directory >

Removes one directory from the list, previous backups are not affected. 

	backup remove /lib
	removning source /lib
	backup remove /notinlist
	directory not in source list

### add < source directory >

Add a directory to the list of directories to be backuped

	backup add /lib
	backup add /notadirectory
	source not a directory
	
## <a name="mysql">Commands for /usr/local/bin/mysql_backup

### check

Check if mysql server and selected databases are accessable

This command should always be run before active backup to check that all i OK

	backup_mysql check
	Accessing mysql server : FAIL
	
This response is either because the database server is not running or the user/password selected are incorrect.

	backup_mysql check
	Accessing mysql server : OK
	
Means that the user/password is correct and the databaseserver can be accessed

If databases are specified, a check to see that they are selectable is done also

	backup_mysql check
	Accessing mysql server : OK
	Check database information_schema : OK
	Check database mysql : OK
	Check database performance_schema : OK

### list-db

This command shows all found databases on the database-server

	backup_mysql list-db
	databases available for backup
	information_schema
	mysql
	performance_schema

### list

This command shows all databases scheduled for backup

	backup_mysql list
	mysql
	
Output shows that the database mysql is scheduled for backup

### user < user name >

This command defined which username should be used to connect to the database.

Default value for user name is *root*

After changing user name and/or password check that it is correct with the command

	backup_mysql check

### password < password >

This command defined which password should be used to connect to the database

Default value is a blank password

To set a black password again use the command

	backup_mysql password -
	
After changing user name and/or password check that it is correct with the command

	backup_mysql check
	
### add < database name >

This command adds the selected daatabase to the backup schema

### remove < database name >

This command removes the selected database from the backup schema

### using the 'all' database to add and remove databases