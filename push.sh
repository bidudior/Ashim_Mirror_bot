#bin/bash
echo "Auto Deploy Bash."
sleep 1
echo "Enter your Exiting/New Heroku appname - "
read herokuappname
echo "Make sure you are logged in."

echo "1. New."
echo "2. Update."
read update 
if  ! [ "$update" == "2" ]
then 
echo "New Bot"
if ! [ -f config.env ]
then 
    echo "Config Not Found" 
    exit
fi
echo -e "Trying Deploying your bot... Please Enter a uniqe appname"

echo -e "Choose The Server Region\n"
echo -e "1. US\n2. EU\n\nJust Press Enter For EU Region(Default)"
read region
region="${region:=1}"
if [ $region == 1 ]
then
region=us
elif [ $region == 2 ]
then
region=eu
else
echo -e "Wrong Input Detected"
echo -e "EU Server Is Selected"
region=eu
fi
git add . -f
git commit -m changes 
git commit -m token 
echo "Using $herokuappname As Name."
echo "Using $region As Region For The Bot."
heroku create --region $region $herokuappname
heroku git:remote -a $herokuappname
heroku stack:set container -a $herokuappname
echo "Done"
echo "Deploying"
git push heroku master -f

echo "Destroying and Deploying"
heroku apps:destroy --confirm $herokuappname
heroku create --region $region $herokuappname
heroku git:remote -a $herokuappname
heroku stack:set container -a $herokuappname
echo "Done"
echo "Deploying"
git push heroku master -f

echo "Done"
else 
echo "Updating Bot."
git add . -f 
git commit -m changes
heroku git:remote -a $herokuappname
heroku stack:set container -a $herokuappname
echo "Updating"
git push heroku master -f
fi 

echo "Done"
echo "Auto Log Check"
echo "heroku logs -t"