git clone git@github.com:trayburn/PowerShell.git
git clone git@github.com:trayburn/trayburn.github.com.git blog -b source
cd blog
git clone git@github.com:trayburn/trayburn.github.com.git _deploy -b master
cd ..
git clone git@github.com:trayburn/ChocolateyPackages.git
mkdir higway
cd highway
git clone git@github.com:HighwayFramework/Highway.Data.git data
git clone git@github.com:HighwayFramework/Highway.Onramp.MVC.git onramp-mvc
git clone git@github.com:HighwayFramework/highwayframework.github.io.git website -b source
cd website
git clone git@github.com:HighwayFramework/highwayframework.github.io.git _deploy -b master
cd ..
git clone git@github.com:HighwayFramework/Highway.RoadCrew.git roadcrew
git clone git@github.com:HighwayFramework/Highway.Pavement.git pavement
git clone git@github.com:HighwayFramework/Highway.Insurance.git insurance
git clone git@github.com:HighwayFramework/Highway.Onramp.Services.git onramp-services
git clone git@github.com:HighwayFramework/Highway.OnRamper.git onramper
cd ..
mkdir improving
cd improving
git clone git@github.com:trayburn/ConsultingGame.git
cd ..

