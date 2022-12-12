# Release info

All notable changes to this project will be documented in this file.

## [1.0.0] - 22/Feb/2021
#### Added
* Added a directory for sharing files between the host and docker container.
* Remove dangling images after the image build.
#### Modified
* Fix the broken Maven download link.

## [2.0.0] - 13/Jun/2022
#### Added
* Added `Netcat` tool to the image.
* Added `Nmap` tool to the image.
* Added `tree` tool to the image.
#### Modified
* Optimize the unix environment variables defined in `Dockerfile`.
* Update Java from `server-jre-8u231-linux-x64` to `jdk-8u331-linux-x64`.
* Improve the build bash script.

## [2.1.0] - 12/Dec/2022
#### Added
* Set the Unix `root` password to `password`.
* Adding `OpenSSH Server`.
  * The SSH Server is not started in this image because the Docker `CMD` command defined in this image will be overwritten and erased by the child images.
    It is also not a good practice to start a background process from Docker `CMD` because after the background process has been started the container will be aborted immediately.
    Using the `ENTRYPOINT` to start the SSH Server is also does not look a good idea because the value defined in this stage can not be overridden from the `docker` command and that blocks the manual instantiation of this image (`docker run --name java-8 -d oracle/jre-8:2.1.0 tail -f /dev/null`).
  * So the SSH server must be started with `echo "$ROOT_PASSWORD" | su "root" -c "/usr/sbin/sshd -D &"` in the child images.
    Once the SSH has been started, you can use SCP this way: `sshpass -p "$ROOT_PASSWORD" scp -o StrictHostKeyChecking=no root@<remote-host>:/<remote-path> .`
* Adding `sshpass` command

<a href="https://trackgit.com"><img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/kv444g8vf7bti919dcgk" alt="trackgit-views" /></a>
