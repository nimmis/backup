# Backup
A shell script to make backup using cron. The script make in possible to
- specify backup interval
- define source of backup
- define destination of backups
- define number of copies to keep

## Installation

## Konfiguration file in /etc/backup

## Basic commands

### status

    >backup status
    Active backups 10 of maximum 10
    Backup interval 1m (cron */1 * * * *)
    Latest backup file backup-2016_07_29_20_24.tar
    Total size of backups 2.2MB
    Backup destination directory is /backup/57375490a540

### enable

### disable

### set-dest <destination directoy>

### set-copies <copies to keep>

### set-interval <backup interval>

### show-backup

    >backup show-backups
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
    
### backup

    >backup backup
    backup of /etc, size 1.5MB compressed 208.0KB
    backup of /home, size 4.0KB compressed 4.0KB
    
## Commands for /usr/local/bin/backup

### show-sources

### remove-source <source directory>

### add-source <source directory>

## Commands for /usr/local/bin/mysql_backup

### show-databases

### remove-database <source directory>

### add-dababase <source directory>

