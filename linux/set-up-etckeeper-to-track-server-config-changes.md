Create a new repository in gitlab under the example-project group. For example, lets call it "example-blog-server-etc-files-OL76". Choose the option to create a default README.md file so it starts with a "master" branch, otherwise there won't be a default branch. 

Check out the new repository to your local machine.

```
cd %USERPROFILE%\Documents
#clone the empty repository
git clone https://gitlab.aws.ccis.com/example-project/example-blog-server-etc-files-OL76.git
#Now create a branch for the qa server files
git checkout -b qa-server
# Add the QA server as a remote
git remote add blog-qa-server git@ec2-3-84-29-80.compute-1.amazonaws.com:/srv/git/example-blog-server-etc-files-OL76.git
git push blog-qa-server
```

Add the new server as a new remote...open a commandline in the local repository folder and run:

git remote add blog-qa-server git@ec2-3-84-29-80.compute-1.amazonaws.com:/srv/git/example-blog-server-etc-files-OL76.git

```
curl http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/e/etckeeper-1.18.8-1.el6.noarch.rpm --output etckeeper-1.18.8-1.el6.noarch.rpm
rpm -Uvh etckeeper-1.18.8-1.el6.noarch.rpm
cd /etc
etckeeper init
git clone /srv/git/project.git
git checkout -b qa

```

Edit the /etc/etckeeper/etckeeper.conf file and add this to the bottom:

```
PUSH_REMOTE="origin"
```

That will start tracking your /etc/ directory in a local repository. 