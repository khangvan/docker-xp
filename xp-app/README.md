# Docker container for Enonic xp

## Build local
```
git clone https://github.com/enonic/docker-xp.git
cd docker-xp-app/<desired version>
docker build --rm -t enonic/xp-app:<desired version> .
```

## Start enonic xp container with linked storage container
```
docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app:<desired version>
```

## Start enonic xp container standalone
```
docker run -d -p 8080:8080 --name xp-app enonic/xp-app:<desired version>
```
