#!/bin/bash
echo "### Enonic XP demo instance configurator ###"

MY_HOSTNAME=$1

if [[ "x$1" = "x" ]]
	then
	echo "hostname argument is missing, using hostname on instance"
	MY_HOSTNAME="$HOSTNAME.tryme.enonic.io"
fi

PWD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c14)

function set_password()
{
	ADMIN_URL=$1
	PWD=$2

	AUTH="su:password"
	JSON="{\"key\":\"user:system:su\",\"password\":\"$PWD\"}"
	eval "curl -u $AUTH -H \"Content-Type: application/json\" -XPOST '$ADMIN_URL/rest/security/principals/setPassword' -d '$JSON' "
}

function publish_demosite()
{
	ADMIN_URL=$1
	
	AUTH="su:password"
	JSON="{\"ids\":[\"e1f57280-d672-4cd8-b674-98e26e5b69ae\"]}"
	eval "curl -u $AUTH -H \"Content-Type: application/json\" -XPOST '$ADMIN_URL/rest/content/publish' -d '$JSON' "
}

echo "### Pulling docker images"
echo "    - enonic/xp-home"
docker pull enonic/xp-home

echo "    - enonic/xp-app"
docker pull enonic/xp-app

echo "    - enonic/xp-frontend"
docker pull enonic/xp-frontend

echo "### Creating persistant storage container"
docker run -d -it --name xp-home-demo enonic/xp-home
docker wait xp-home-demo
echo "### Creating Enonic XP installation"
docker run -d --volumes-from xp-home-demo --name xp-app-demo enonic/xp-app
sleep 5
echo "### Starting up frontend"
docker run -d --name xp-frontend -p 80:80 --link xp-app-demo:app enonic/xp-frontend

echo "Sleeping for 20 seconds to make shure Enonic XP is up and running"
sleep 20

echo "### Injecting superhero module"

DEMO_MODULE_VERSION=1.1.0

docker exec xp-app-demo wget -O /tmp/superhero-1.0.0-SNAPSHOT.jar http://repo.enonic.com/public/com/enonic/theme/superhero/1.0.0-SNAPSHOT/superhero-1.0.0-SNAPSHOT.jar
docker exec xp-app-demo cp /tmp/superhero-1.0.0-SNAPSHOT.jar /enonic-xp/home/deploy/superhero-1.0.0-SNAPSHOT.jar

echo "Sleeping for 20 seconds to get the demo deployment ready"
sleep 20

#echo "### Publishing demo site"
#publish_demosite http://localhost/admin

echo "### Setting up vhost properties"
docker exec xp-app-demo wget -O /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg.template https://raw.githubusercontent.com/enonic/docker-xp/master/xp-demo/com.enonic.xp.web.vhost.cfg.template-superhero
docker exec xp-app-demo sed -i "s/HOSTNAME/$MY_HOSTNAME/g" /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg.template
docker exec xp-app-demo rm /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg
docker exec xp-app-demo mv /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg.template /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg

echo "### Changing su password to $PWD"
set_password http://localhost/admin $PWD

echo ""
echo "### Finished configuring Enonic XP demo environment ###"

echo "

--- mail this part to customer ---
Subject: Enonic XP demo instance

Hi.
I see that you have requested a demo installation of Enonic XP.
You can access it here:

Public site: http://$MY_HOSTNAME/
Admin: http://$MY_HOSTNAME/admin 
Username: su
password: $PWD

For documentation, please see https://enonic.com/docs/latest/
And if there are any questions, please contact either Kristian or me ( I've added Kristian on cc. )

We'll keep the installation up for three days for you. If you wan't to keep it longer, just let us know. 

" > /home/user/demo-instance.txt