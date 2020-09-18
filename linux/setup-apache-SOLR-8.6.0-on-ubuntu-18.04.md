# Install Apache SOLR 8.6.0 on Ubuntu 18.04

This is NOT a prod install, this is for testing on local servers only, specifically Ubuntu on WSL2. You probably don't need to make all the config tweaks for garbage collection, or alter the ulimit settings if you are not running under WSL. 

```shell
cd /root
wget https://mirror.olnevhost.net/pub/apache/lucene/solr/8.6.0/solr-8.6.0.tgz
tar xzf solr-8.6.0.tgz solr-8.6.0/bin/install_solr_service.sh --strip-components=2
bash ./install_solr_service.sh solr-8.6.0.tgz

# IMPORTANT: by default solr logs and data will be in /var/solr

# wsl doesn't play nice with open files limit and max processes. Try to increase it
# ulimit -a
# ulimit -c unlimited
ulimit -n 65000
ulimit -u 65000
# also see
# https://medium.com/@muhammadtriwibowo/set-permanently-ulimit-n-open-files-in-ubuntu-4d61064429a
```

Now try to start the solr service...

```bash
service solr start
```

The default SOLR install will not work on WSL version of Ubuntu due to issues with Java G1 garbage collection. To fix this, change the garbage collection config by editing the default JAVA options in /etc/default/solr.in.sh

```bash
nano /etc/default/solr.in.sh

# find the line that looks like this...
#GC_TUNE=-XX:-UseG1GC \
# this is a commented-out java option. 
# Add a new line below it that looks like this:
GC_TUNE=-XX:+UseSerialGC
# it should not be commented out. 
```

After adding that config option try starting solr again via `service solr start`. If it still does not work, edit the config again and uncomment the SOLR_JAVA_MEM variable and set it to this:

```bash
SOLR_JAVA_MEM="-Xms256m -Xmx256m"
```

Try again to start the server. You will likely see a message like:

```
Waiting up to 60 seconds to see Solr running on port 8983
```

It will not ever see the solr instance, but the solr instance will be started if there's no other error. When it stops looking it will spit out some log info that will end with this if there was no error: 

```
2020-08-10 00:26:15.997 INFO  (main) [   ] o.e.j.s.Server Started @3352ms
```

If it doesn't look like there was an error, try to load up the web admin interface in a browser at:

```
http://localhost:8983
```

If it loads up, you can set up your first core. Yay!

## Set up a core

```shell
#the standalone solr server will not create a default core, even if you follow the official documentation 
# because apparently the SOLR devs can't come to a consensus on something this simple even after 10 years
# despite the fact that Elasticsearch managed to do it on version 1 anyway, create your core dirs manually
# before trying to use the solr admin to create the core for real...
mkdir /var/solr/data/beta9.brettbrewer.com
echo "name=beta9.brettbrewer.com" > /var/solr/data/beta9.brettbrewer.com/core.properties
cp -r  /opt/solr/server/solr/configsets/_default/conf /var/solr/data/beta9.brettbrewer.com/
sudo su solr
bash /opt/solr/bin/solr create -c beta9.brettbrewer.com
```



## Debugging Startup Errors

You might have issues starting the server. Java gives you very little help on this front. Try manually running the solr binary like so:

```
./solr start -force
```

Then when the server fails to start you can view the error at the top of the log file:

```
nano /root/solr-8.6.0/server/logs/solr-8983-console.log
```

Then you'll see some error such as:

```shell
#  A fatal error has been detected by the Java Runtime Environment:
#
#  Internal Error (g1PageBasedVirtualSpace.cpp:49), pid=13794, tid=13797
#  guarantee(is_aligned(rs.base(), page_size)) failed: Reserved space base 0x00007f6954670000 
#  is not aligned to requested page size 2097152
```

Try starting the server again with some custom java options to fix the memory size:

```
./solr start -force -a "-Xmx500m -Xms100m -XX:ParallelGCThreads=2 -XX:+CMSClassUnloadingEnabled -XX:-Use
ConcMarkSweepGC -XX:CompressedClassSpaceSize=256m -XX:+UnlockExperimentalVMOptions -XX:G1ReservePercent=10"
```

or

```
export _JAVA_OPTIONS="-Xmx500m -Xms100m"
```

This basically means that Java could not reserve contiguous memory space for the g1 garbage collection. If you can't fix it by reducing the memory size, you may need to rebase your wsl dlls, or just restart your machine to free up all memory addresses and try again. 