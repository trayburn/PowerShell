@(
    @{
        Name="jQuery";
        Description="jQuery is the premiere JavaScript DOM manipulation library in the market today.";
        InfoUrl="http://masstransit-project.com/";
        Packages=@("jQuery","jQuery.Migrate","jQuery.UI.Combined","jQuery.Validation")
    },
    @{
        Name="MassTransit";
        Description="MassTransit serves as a Message Bus, coordinating all of the communication";
        InfoUrl="http://masstransit-project.com/";
        Packages=@("MassTransit","MassTransit.CastleWindsor","MassTranit.NLog","MassTransit.RabbitMQ","MassTransit.TestFramework")
    },
    @{
        Name="Highway";
        Description="The Castle Project is an amazing, well respected, group of libraries that include IoC, Logging, and Dynamic Proxies.  Literally hundreds of Open Source projects which rely on Castle, or one of its libraries.";
        InfoUrl="http://www.castleproject.org/";
        Packages=@("Highway.Data","Highway.Data.EntityFramework","Highway.Data.EntityFramework.Castle")
    },
    @{
        Name="Monitoring";
        Description="These components are related to logging, and monitoring of the application.";
        InfoUrl=$null;
        Packages=@("Castle.Core-NLog","Castle.Windsor-NLog","Common.Logging","Common.Logging.NLog20","elmah","elmah.corelibrary",
            "Elmah.MVC","Glimpse","Glimpse.Ado","Glimpse.AspNet","Glimpse.EF5","Glimpse.Elmah","Glimpse.Mvc4")
    },    @{
        Name="Castle";
        Description="The Castle Project is an amazing, well respected, group of libraries that include IoC, Logging, and Dynamic Proxies.  Literally hundreds of Open Source projects which rely on Castle, or one of its libraries.";
        InfoUrl="http://www.castleproject.org/";
        Packages=@("Castle.Core","Castle.Windsor","Castle.Core-NLog","Castle.LoggingFacility","Castle.Windsor-NLog")
    }
)