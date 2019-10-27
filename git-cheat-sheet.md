# git-cheatsheet

Various tips and tricks on using GIT, Gitlab, Github, Bitbucket, etc. 

# Untracking files with GIT

If you end up with config files or other files in your repos that shouldn't be there and you want to keep them locally, but remove them from the repository and the repository history (making git basically forget they ever existed), use these commands...

```bash
# add the file to your .gitignore first..you can do this 
# manually or via commandline, eg:
# echo "FILE_NAME" >> .gitignore
# You might want to grab the preconfigured .gitignore file in this
# repository if you don't already have one, it has ignore rules for
# most java/javascript/python/ruby files you'd want to keep out of
# your repository. 

# now remove the file from git's commit history
git rm --cached FILE_NAME

#If you want to remove a whole directory from the commit history just add the -r flag:
git rm --cached -r DIRECTORY_NAME

# Now update the index just where it already has an entry matching <pathspec>. 
# This removes as well as modifies index entries to match the working tree, but adds no new files.
git add -u

# Now commit the file removal
git commit -m "Removing files from version control"

# pull to be sure you're up to date with any new remote changes, then push
git pull
git push
```