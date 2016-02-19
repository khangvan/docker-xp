# Docker container for Enonic XP 6.4.0-RC4

## Build local

    git clone https://github.com/enonic/docker-xp-app.git
    cd docker-xp-app/6.4.0-RC4
    docker build --rm -t enonic/xp-app:6.4.0-RC4 .

## Start enonic xp container standalone

    docker run -d -p 8080:8080 --name xp-app enonic/xp-app:6.4.0-RC4

## Start enonic xp container with linked storage container

    docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app:6.4.0-RC4
