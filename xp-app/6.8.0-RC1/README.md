# Docker container for Enonic XP 6.8.0-RC1

## Build local

    git clone https://github.com/enonic/docker-xp-app.git
    cd docker-xp-app/6.8.0-RC1
    docker build --rm -t enonic/xp-app:6.8.0-RC1 .

## Start enonic xp container standalone

    docker run -d -p 8080:8080 --name xp-app enonic/xp-app:6.8.0-RC1

## Start enonic xp container with linked storage container

    docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app:6.8.0-RC1
