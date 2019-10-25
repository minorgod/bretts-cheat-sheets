# Install SOLR 4 and Tomcat 6 on CentOS

Keep in mind, these instructions are very outdated now and reference versions of software that was current at the time. Much of this info is still useful, but I wouldn't recommend using Tomcat6 / Solr4 or CentOS 6. When I wrote these instructions circa 2013, SOLR 4.1 had just been released. As of today, the current stable version is 8.2 and a lot has changed. It's probably a lot easier to set this up now (Spring Boot has a [SOLR starter project](https://spring.io/projects/spring-data-solr) that can jumpstart a project really quickly if you're using Spring Boot already), but this doc will still probably be helpful so I'm keeping these instructions for reference in case I need to set up SOLR from scratch again.  

## Overview 

Why was this necessary? Who even needs a dedicated search server?

At the time, I was the lead web developer for heels.com, a women's shoe retailer that had peak traffic on the site of around 2000 simultaneous users with sales of $10,000/hr. It had a fantastic visual search UI with a "faceted search" interface for an inventory of over 200,000 SKUs. There was a full-text search box for typical keyword searches, plus users could select dozens of attributes to filter the entire inventory with or without search keywords. Despite being powerful, it was very easy to use. Just click any attribute in a dropdown menu and the UI "instantly" updated without a page refresh (and we did this the hard way with jQuery and manual browser history manipulation...yuck!). Users  could filter results simultaneously by size, color, category, style, brand, heel height, persona, availability, on-sale, occasion, etc. Anyone who has had to solve this sort of problem will tell you, this is a clusterfuck to do with MySQL queries. Matching synonyms or misspellings was nearly impossible to do reliably. As users would select more and more attributes on the frontend, queries were "ANDed" together, and shoe attributes that were stored in different tables resulted in increasing numbers of INNER JOINs. With over 200,000 skus in the database, queries were taking 20+ seconds to return results with just a few filters selected. Beyond 3 or 4 filters the server would start grinding to a halt. This was not acceptable, so I was tasked with finding a solution. I researched available options, starting with Apache Lucene, and quickly found Apache SOLR - a search server built on Lucene, but which had solved all the hard problems of actually using Lucene for things that were particularly applicable to ecommerce search problems. Specifically it was great at faceted search, was stable as hell, fast as hell, allowed for serving queries while re-indexing the data source, and it came with a minimal, but very useful admin dashboard. After a few weeks of learning the basics, I was able to set up a prototype for testing and found that the nastiest search queries that would take over a minute to return results with our SQL backend, SOLR could do in milliseconds with far more accuracy and flexibility. Results could be weighted by various factors such as age, keyword relevance or other attributes, and each attribute could weighted differently if desired. Newer shoes could easily be pushed to the top of the results, and matches on things like shoe size and brand could be weighted more heavily which was particularly important to women's shoe retail. It worked better than I ever thought it could. Once we rolled the final solution into production, our database load went to near zero and our search was better and faster than our biggest competitors out there - Zappos, Shoes.com and Amazon. Frankly, their sites were a joke compared to heels.com, and our development team at the time basically consisted of just me and 1 other developer. We were super-proud or what we were able to accomplish. 

But enough backstory.  Let's get on with the instructions!

## Three Server SOLR Cluster from Scratch

This is how I set up the SOLR search cluster for heels.com in late 2012. In our setup we were using a master with 2 slave instances. The master SOLR server was running on the same machine as the main Apache webserver, and 2 slave SOLR instances were running on the same machines as our 2 MySQL DB servers. These were all fairly powerful machines and SOLR was really efficient with a small enough memory footprint that it made sense for us to run it on same machines as our web and DB servers. I don't know if this would still be the case with newer SOLR/Tomcat versions. You mileage may vary. 

Nowadays, you can install SOLR and Tomcat via the package manager on most major distros. On Debian based distros such as Ubuntu you can just run "**sudo apt-get install solr-tomcat**" and you've got a server, albeit one that still needs to be configured properly. But at the time I did this, SOLR was not included in any of the Linux distro package managers, so everything was installed from downloadable binaries. This turned out to be nice because it made the final setup very portable. To save time, you can basically just do all this stuff on the master server, then zip the install directories and transfer them to the slave hosts once it's all set up and running properly on the master. The only difference will be the startup script configuration (at the end of this document) that tells each SOLR instance to start up in either master or slave mode. 

## Install Tomcat 6

Download the Tomcat6 binary release for your platform (It appears there is only 1 version for both 32/64 bit on Linux, but there are separate 32/64 bit versions for Windows). 

As root, make a new directory 

```shell
mkdir /opt/tomcat6
```

This directory will be referred to in config files as $CATALINA_HOME
Extract the tomcat binary archive and move all files/subfolders to the /opt/tomcat6 dir. 

Edit /opt/tomcat6/conf/tomcat-users.xml to enable the manager login as user "tomcat" with password "tomcat" (obviously this is insecure for local dev only...do something way harder for prod servers):

```xml
<role rolename="manager"/><role rolename="admin"/><user username="tomcat" password="tomcat" roles="manager,admin"/>
```

Now try starting the Tomcat server:

```shell
/opt/tomcat6/bin/catalina.sh run
```

The official instructions from http://wiki.apache.org/solr/SolrTomcat mention a tomcat6 startup script that can be placed in /etc/init.d/tomcat6 to allow starting/stopping the server using “service tomcat6 start”, but I couldn’t find the script. To enable auto startup of tomcat when server starts, use chkconfig (init.d script at the end of this document). 

Now Ctrl-C to kill the Tomcat server if you still have it running in your teminal. 

## Install SOLR 4.1

Download the latest stable SOLR4 (currently 4.1.0) package. Extract the archive somewhere. Now create a directory for the solr4 installation

```
mkdir /opt/solr-4.1.0


```

Copy the example, contrib and dist folders from the SOLR archive to :

/opt/solr-4.1.0/example

/opt/solr-4.1.0/contrib

/opt/solr-4.1.0/dist

cd /opt/tomcat6/conf/Catalina/localhost

Next create a file for your domain's solr config such as **example.com.xml** and paste this in there:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<Context docBase='/opt/solr-4.1.0/example.com/solr/solr.war' debug='0' crossContext='true'> 
    <Environment name='solr/home' type='java.lang.String' value='/opt/solr-4.1.0/example.com/solr' override='true'/>
</Context>
```

If you’re replacing a previous solr install, go to /opt/tomcat6/webapps and delete the example.com directory and the solr-example directory, they will be automatically recreated by tomcat. 

You have now configured Tomcat6 to run the SOLR example instance AND the example.com instance (in theory). Since we don’t have a example.com directory in /opt/solr4 yet, you now need to do 1 of the following. Either get a copy of the example.com subdirectory from Brett, or make a copy of the /opt/solr-4.1.0/example folder called example.com. 

If you’re doing this from scratch and you duplicated the /solr-4.1.0/example directory to create the example.com directory, you’ll now need to copy /opt/solr-4.1.0/dist/solr-1.4.0.war file to /opt/solr-4.1.0/example.com/solr/solr.war

Set up MySQL Java connector

 Download a copy of the mysql java connector from http://dev.mysql.com/downloads/connector/j/

Extract the jar file and copy it to/opt/solr-4.1.0/example.com/solr/core1/lib

You may need to create the “lib” folder under core1. No need to rename the jar file. 

Now you’ll need to make a shitload of configuration file changes to get SOLR set up to the point that it will actually start the example.com SOLR instance w/o errors when you start Tomcat. 

## Configuring SOLR 

If you don’t know what you’re doing is a daunting task, so you’re better off just getting copies of all these config files from Brett, but if you want to do it the hard way, open /opt/solr-4.1.0/example.com/solr/core1/conf/solrconfig.xml

The solrconfig.xml file defines all the main solr config stuff, including library locations, request handlers, etc. A little way down from the top of that file you’ll see a bunch of <lib dir=.... /> lines in the xml which all use relative paths to define some lib dirs. If the following relative paths don’t work, just change them to absolute paths, or fix the relative paths for your install. These should work though...

```xml
<lib dir="../../../contrib/extraction/lib" regex=".*\.jar" /><lib dir="../../../dist/" regex="solr-cell-\d.*\.jar" />
<lib dir="../../../contrib/clustering/lib/" regex=".*\.jar" /><lib dir="../../../dist/" regex="solr-clustering-\d.*\.jar" />
<lib dir="../../../contrib/langid/lib/" regex=".*\.jar" /><lib dir="../../../dist/" regex="solr-langid-\d.*\.jar" />
<lib dir="../../../contrib/velocity/lib" regex=".*\.jar" /><lib dir="../../../dist/" regex="solr-velocity-\d.*\.jar" />
<lib dir="../../../contrib/dataimporthandler/lib" regex=".*\.jar" /><lib dir="../../../dist/" regex="solr-dataimporthandler-.*\.jar" />
```

To allow SOLR to index the db directly, you’ll need to make sure there’s a DataImport request handler enabled in the solrconfig.xml. Do a search for DataImport in the file and make sure there’s a section enabled that looks like this:

```xml
<requestHandler name="/dataimport" class="org.apache.solr.handler.dataimport.DataImportHandler"><lst name="defaults">
    <str name="config">data-config.xml</str></lst>
</requestHandler>
```

You’ll also need to create and tweak the following config files:

/opt/solr-4.1.0/example.com/solr/core1/conf/data-config.xml

/opt/solr-4.1.0/example.com/solr/core1/conf/schema.xml

The creation and setup of these data-import and schema files is extremely complex so unless you want to spend a few days learning about creating them from scratch, just get copies of the latest versions from Brett. 

The data-config.xml file will contain the db connection info and queries that populate the data source used for indexing. 

The schema.xml file defines the indexing schema for the actual SOLR index, in other words it defines how the fields from the data-config.xml file are interpreted and indexed. Basically, once you have solr up and running, almost everything you’re likely to need to change can be found in either the data-config.xml or the schema.xml files, though on rare occasions you may want to tweak the solrconfig.xml to change or create a request handler. Below I’m pasting links to my current solr config files for you to copy/paste. 

solrconfig.xml
data-config.xml
schema.xml

That’s basically it. Now start looking at those files, especially the data-config and schema files to see how the indexing works. 

Once you are able to start Tomcat6 with the SOLR instances configured on your testserver you can visit the following urls to see the SOLR admin pages for the example and beta4 indexes:
http://localhost:7575/example.com
Replace the localhost with whatever your server name is.

 To access these pages running on the live db servers, you’ll need to be hooked up the VPN and have an IP address mapping for the db servers  in your hosts file. 

## INIT.D SCRIPT FOR MASTER SERVER (webserver)

I’d be wary of copying and pasting directly from here due to line endings etc.  Also if you changed the installation folder from /opt/tomcat6 to something else you will need to set the CATALINA_HOME value to that path.

Save the following script to /etc/init.d/tomcat then chmod 755 /etc/init.d/tomcat and finally chkconfig --add tomcat

```bash
#!/bin/bash  
# description: Tomcat Start Stop Restart  
# processname: tomcat  
# chkconfig: 234 20 80  
JAVA_HOME=/usr
export JAVA_HOME  
PATH=$JAVA_HOME/bin:$PATH  
export PATH  
CATALINA_HOME=/opt/tomcat6    
  
export JAVA_OPTS="-Denable.master=true -Denable.slave=false -Djetty.port=7575 -Dmaster.hostName=local.example.com"

case $1 in  
start)  
sh $CATALINA_HOME/bin/catalina.sh  start
;;   
verbose)  
sh $CATALINA_HOME/bin/catalina.sh  run
;;   
stop)     
sh $CATALINA_HOME/bin/catalina.sh  stop
;;   
restart)  
sh $CATALINA_HOME/bin/catalina.sh  stop
sleep 5
sh $CATALINA_HOME/bin/catalina.sh  run
;;   
force)  
sh $CATALINA_HOME/bin/catalina.sh  stop -force
;; 
forcerestart)  
sh $CATALINA_HOME/bin/catalina.sh  stop -force
sleep 5
sh $CATALINA_HOME/bin/catalina.sh  run
;; 
esac      
exit 0
```



## INIT.D SCRIPT FOR SLAVE SERVERS (both db servers)

Note the only difference between the master/slave scripts is the JAVA_OPTS line. Be sure to set these up with chkconfig the same way you do the master server script. 

```bash
#!/bin/bash  
# description: Tomcat Start Stop Restart  
# processname: tomcat  
# chkconfig: 234 20 80  
JAVA_HOME=/usr
export JAVA_HOME  
PATH=$JAVA_HOME/bin:$PATH  
export PATH  
CATALINA_HOME=/opt/tomcat6    
  
export JAVA_OPTS="-Denable.master=false -Denable.slave=true -Djetty.port=7575 -Dmaster.hostName=local.example.com"

case $1 in  
start)  
sh $CATALINA_HOME/bin/catalina.sh  start
;;   
verbose)  
sh $CATALINA_HOME/bin/catalina.sh  run
;;   
stop)     
sh $CATALINA_HOME/bin/catalina.sh  stop
;;   
restart)  
sh $CATALINA_HOME/bin/catalina.sh  stop
sleep 5
sh $CATALINA_HOME/bin/catalina.sh  run
;;   
force)  
sh $CATALINA_HOME/bin/catalina.sh  stop -force
;; 
forcerestart)  
sh $CATALINA_HOME/bin/catalina.sh  stop -force
sleep 5
sh $CATALINA_HOME/bin/catalina.sh  run
;; 
esac      
exit 0
```

