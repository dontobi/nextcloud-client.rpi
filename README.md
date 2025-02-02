[![Source](https://img.shields.io/badge/source-github-blue)](https://github.com/dontobi/nextcloud-client.rpi)
[![Github Issues](https://img.shields.io/github/issues/dontobi/nextcloud-client.rpi)](https://github.com/dontobi/nextcloud-client.rpi/issues)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/dontobi/nextcloud-client.rpi/latest)](https://hub.docker.com/repository/docker/dontobi/nextcloud-client.rpi)
[![Docker Pulls](https://img.shields.io/docker/pulls/dontobi/nextcloud-client.rpi)](https://hub.docker.com/repository/docker/dontobi/nextcloud-client.rpi)
[![License](https://img.shields.io/github/license/dontobi/nextcloud-client.rpi)](https://github.com/dontobi/nextcloud-client.rpi/blob/main/LICENSE.md)

# Nextcloud docker-client
This image provides you an alpine based image for syncing your files with a remote [nextcloud server ](https://nextcloud.com/)

This image is based on the work made by: [Martin Peters](https://github.com/FreakyBytes) and [Juan Ignacio Borda](https://github.com/juanitomint)

Any comment or propblem feel free to [fill an issue](https://github.com/dontobi/nextcloud-client.rpi/issues/new) or make a PR!

## Example without settings folder
```
docker run -d --name nextcloud-client \
    -v [nextcloud-folder]:/media/nextcloud \
    -e NC_USER=[nextcloud-user] \
    -e NC_PASS=[nextcloud-password] \
    -e NC_URL=[nextcloud-server_url] \
    --restart=always \
    dontobi/nextcloud-client.rpi:latest
```

## Example with settings folder. You have to place a "exclude" file and a "unsyncfolders" file into one directory and mount it into the docker container
```
docker run -d --name nextcloud-client \
    -v [nextcloud-folder]:/media/nextcloud \
    -v [nextcloud-folder]:/settings \
    -e NC_USER=[nextcloud-user] \
    -e NC_PASS=[nextcloud-password] \
    -e NC_URL=[nextcloud-server_url] \
    --restart=always \
    dontobi/nextcloud-client.rpi:latest
```

## Example for the file "exclude" in the settings folder
```
    file1
    file2
```

## Example for the file "unsyncfolders" in the settings folder
```
    folder1
    folder2
```


## ENV variables to customize your deploy

##### NC_URL
URL to the Nextcloud instance. Example: `https://cloud.example.com`

##### NC_USER
The user name to log in
Default: username

##### NC_PASS 
Valid password for the user above in clear text
Default: password

##### NC_SOURCE_DIR
The directory inside de docker container to be synced, usually you will have a local mount here or a named volume
default: /media/nextcloud/

##### NC_PATH
You can sync specific folders by providing the full path like `/path/to/custom/dir`. This will only sync the contents of this folder inside `$NC_SOURCE_DIR`.
default: "" i.e. root folder

##### NC_SILENT
whether or not output activity to console
default: false

##### NC_INTERVAL
Sets the interval between syncs in seconds
default: 300 (300 / 60 = 5 Minutes)

##### NC_EXIT
If "true" the sync will happen once and then the container will exit, very usefull for using 
in conjunction with cron or schedulers
default: false
 
## Advanced settings

##### USER
The system user inside the container you want to use for runing the sync

default: ncsync

##### USER_GID
The system user group id inside the container you want to use for runing the sync

default: 1000

##### USER_UID
The system user id inside the container you want to use for runing the sync

default: 1000

##### NC_TRUST_CERT
whether or not trust self signed certificates or invalid certificates

default: false

##### NC_HIDDEN
whether or not nextcloud should be forced to sync hidden files

default: false


## License
MIT License

Copyright (c) 2022-2025 [Tobias 'dontobi' Schug]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
