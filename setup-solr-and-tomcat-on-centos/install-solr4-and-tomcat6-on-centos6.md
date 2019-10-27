# A Three Server SOLR Cluster from Scratch

This is how I set up the SOLR search cluster for heels.com in late 2012. In our setup we were using a master with 2 slave instances. The master SOLR server was running on the same machine as the main Apache webserver, and 2 slave SOLR instances were running on the same machines as our 2 MySQL DB servers. These were all fairly powerful machines and SOLR was really efficient with a small enough memory footprint that it made sense for us to run it on same machines as our web and DB servers. I don't know if this would still be the case with newer SOLR/Tomcat versions. You mileage may vary. 

Nowadays, you can install SOLR and Tomcat via the package manager on most major distros. On Debian based distros such as Ubuntu you can just run "**sudo apt-get install solr-tomcat**" and you've got a server, albeit one that still needs to be configured properly. But at the time I did this, SOLR was not included in any of the Linux distro package managers, so everything was installed from downloadable binaries. This turned out to be nice because it made the final setup very portable. To save time, you can basically just do all this stuff on the master server, then zip the install directories and transfer them to the slave hosts once it's all set up and running properly on the master. The only difference will be the startup script configuration (at the end of this document) that tells each SOLR instance to start up in either master or slave mode. 

## Install Tomcat 6

Download the [Tomcat6 binary release for your platform](https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.32/bin/) (It appears there is only 1 version for both 32/64 bit on Linux, but there are separate 32/64 bit versions for Windows). We'll assume you're doing this on Linux (CentOS 6).

```shell
sudo wget https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.32/bin/apache-tomcat-6.0.32.tar.gz
```


Extract the tomcat binary archive and move all files/subfolders to the /opt/tomcat6 dir. This directory will be referred to in config files as $CATALINA_HOME.

```
sudo tar -xzf apache-tomcat-6.0.32.tar.gz
sudo mv ./apache-tomcat-6.0.32 /opt/apache-tomcat6
```

Edit /opt/tomcat6/conf/tomcat-users.xml to enable the manager login as user "tomcat" with password "tomcat" (obviously this is insecure for local dev only...do something way harder for prod servers):

```bash
#yes, I use nano because I'm not a massochist and I'm not trying to prove I'm a "hardcore" unix guru
nano /opt/tomcat6/conf/tomcat-users.xml
```

Give your tomcat user some permissions by adding this to the <tomcat-users> block.

```xml
<role rolename="manager"/>
<role rolename="admin"/>
<user username="tomcat" password="tomcat" roles="manager,admin"/>
```

Now try starting the Tomcat server:

```shell
/opt/tomcat6/bin/catalina.sh run
```

Assuming it starts, check to see if you can access the default Tomcat page on port 8080:

http://localhost:8080

Hoooray, it works! You can access check the status and management pages using the username/password you set earlier (tomcat/tomcat):

http://localhost:8080/manager/status
http://localhost:8080/manager/html

The official instructions from http://wiki.apache.org/solr/SolrTomcat mention a tomcat6 startup script that can be placed in /etc/init.d/tomcat6 to allow starting/stopping the server using “service tomcat6 start”, but I couldn’t find the script. To enable auto startup of tomcat when server starts, use chkconfig with the init.d scripts at the end of this document. 

Now Ctrl-C to kill the Tomcat server if you still have it running in your teminal. 

## Install SOLR 4.1

[Download the SOLR 4.1 package](https://archive.apache.org/dist/lucene/solr/4.1.0/) and extract the archive somewhere, then move it to /opt/solr-4.1.0

```shell
sudo wget https://archive.apache.org/dist/lucene/solr/4.1.0/solr-4.1.0.tgz
tar -xzf solr-4.1.0.tgz
sudo mv ./solr-4.1.0 /opt/solr-4.1.0
```

cd /opt/tomcat6/conf/Catalina/localhost

Next create a file for your domain's solr config such as **example.com.xml**:

```
nano /opt/tomcat6/conf/Catalina/localhost/example.com.xml
```

and paste this in there:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<Context docBase='/opt/solr-4.1.0/example.com/solr/solr.war' debug='0' crossContext='true'> 
    <Environment name='solr/home' type='java.lang.String' value='/opt/solr-4.1.0/example.com/solr' override='true'/>
</Context>
```

If you’re replacing a previous solr install, go to /opt/tomcat6/webapps and delete the example.com directory and the solr-example directory, they will be automatically recreated by tomcat. 

You have now configured Tomcat6 to run the SOLR example instance AND the example.com instance (in theory). Since we don’t have a example.com directory in /opt/solr4 yet, you now need to do 1 of the following. Either get a copy of the example.com subdirectory from Brett, or make a copy of the /opt/solr-4.1.0/example folder called example.com. 

If you’re doing this from scratch and you duplicated the /solr-4.1.0/example directory to create the example.com directory, you’ll now need to copy /opt/solr-4.1.0/dist/solr-1.4.0.war file to /opt/solr-4.1.0/example.com/solr/solr.war

## Set up MySQL Java connector

 Download a copy of the mysql java connector from [http://dev.mysql.com/downloads/connector/j/](http://dev.mysql.com/downloads/connector/j/)

Extract the jar file and copy it to/opt/solr-4.1.0/example.com/solr/core1/lib

mv mysql-connector-java-8.0.18/mysql-connector-java-8.0.18.jar example.com/lib/

You may need to create the “lib” folder under core1. No need to rename the jar file. 

Now you’ll need to make a shitload of configuration file changes to get SOLR set up to the point that it will actually start the example.com SOLR instance w/o errors when you start Tomcat. 

## Configuring SOLR 

If you don’t know what you’re doing is a daunting task, so you’re better off just getting copies of all these config files from Brett, but if you want to do it the hard way, open /opt/solr-4.1.0/example.com/solr/core1/conf/solrconfig.xml

The solrconfig.xml file defines all the main solr config stuff, including library locations, request handlers, etc. A little way down from the top of that file you’ll see a bunch of <lib dir=.... /> lines in the xml which all use relative paths to define some lib dirs. If the following relative paths don’t work, just change them to absolute paths, or fix the relative paths for your install. These should work though...

```xml
<lib dir="../../../contrib/extraction/lib" regex=".*\.jar" />
<lib dir="../../../dist/" regex="solr-cell-\d.*\.jar" />
<lib dir="../../../contrib/clustering/lib/" regex=".*\.jar" />
<lib dir="../../../dist/" regex="solr-clustering-\d.*\.jar" />
<lib dir="../../../contrib/langid/lib/" regex=".*\.jar" />
<lib dir="../../../dist/" regex="solr-langid-\d.*\.jar" />
<lib dir="../../../contrib/velocity/lib" regex=".*\.jar" />
<lib dir="../../../dist/" regex="solr-velocity-\d.*\.jar" />
<!-- MAKE SURE THESE NEXT 2 LINES ARE HERE -->
<lib dir="../../../contrib/dataimporthandler/lib" regex=".*\.jar" />
<lib dir="../../../dist/" regex="solr-dataimporthandler-.*\.jar" />
<!-- OR JUST USE THIS TO LOAD EVERYTHING IN THE DIST AND CONTRIB DIRS -->
<lib dir="../../../dist/" />
<lib dir="../../../contrib/" />
```

To allow SOLR to index the db directly, you’ll need to make sure there’s a DataImport request handler enabled in the solrconfig.xml. Do a search for DataImport in the file and make sure there’s a section enabled that looks like this:

```xml
<requestHandler name="/dataimport" class="org.apache.solr.handler.dataimport.DataImportHandler"><lst name="defaults">
    <str name="config">data-config.xml</str></lst>
</requestHandler>
```

You’ll also need to create and tweak the following config files:

[/opt/solr-4.1.0/example.com/solr/core1/conf/data-config.xml](data-config.xml)
[/opt/solr-4.1.0/example.com/solr/core1/conf/schema.xml](schema.xml)

The creation and setup of these data-import and schema files is extremely complex so unless you want to spend a few days learning about creating them from scratch, just get copies of the latest versions from Brett. 

The data-config.xml file will contain the db connection info and queries that populate the data source used for indexing. 

The schema.xml file defines the indexing schema for the actual SOLR index, in other words it defines how the fields from the data-config.xml file are interpreted and indexed. Basically, once you have solr up and running, almost everything you’re likely to need to change can be found in either the data-config.xml or the schema.xml files, though on rare occasions you may want to tweak the solrconfig.xml to change or create a request handler. 

Here are links to examples of the solr config files we used to set up the heels.com search indexer.

[solrconfig.xml](solrconfig.xml)
[data-config.xml](data-config.xml)
[schema.xml](schema.xml)

 Old-school php ecoomerce devs will recognize the table names from some version of xcart 4.x. Heels.com was originally built on x-cart, but then the whole frontend was re-written in the Kohana framework (a CodeIgniter fork) because that was cutting-edge at the time. It was actually a pretty nice framework for its day -- considering it pre-dated PSR standards, composer and frameworks like Laravel. But that's another story. 

That’s basically it. Now start looking at those files, especially the data-config and schema files to see how the indexing works. 

Once you are able to start Tomcat6 with the SOLR instances configured on your testserver you can visit the following urls to see the SOLR admin pages for the example.com index:
http://localhost:8080/example.com
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

