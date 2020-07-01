# Digital Ocean Cheat Sheet

## Make a backup image of a droplet 

Digital Ocean is kinda annoying for not giving you an easy way to backup and restore your droplet images. Whether or not that's a ploy to keep you paying for storage for your offline Droplets is another discussion. But here's a way you can archive a droplet to your local machine -- it's not a true "image" of a droplet, but it's a full backup of the entire filesystem, which is nearly as good. 

**Zero-fill all free drive space**

Before running the archiving command you may want to zero-fill all avail space on the drive first to make the archive compression more efficient. If so, ssh into a root shell on the remote host and run:

```shell
dd if=/dev/zero of=zeros.txt
```

Once this command errors out due to no space left on drive, delete the text file.

Then, from a local environment that has access to gzip or pixz (or xz) compression tools, run one of these commands. I recommend using the pixz command over xz. Pixz is the "parallel, indexing version of XZ". Even though multi-threaded support was added to xz, as of the writing of this doc, pixz has the added benefit of being much fast at decompression on large archives because it indexes the contents of the archive.  See [this discussion](https://superuser.com/questions/886783/difference-between-pixz-and-xz-with-t-option) for details.

**Using Pixz to generate xz archive:**

```shell
#obviously substitute your own ip address here and maybe give your archive a better name...
ssh -i your.private.key root@104.131.187.185 "dd conv=sparse if=/dev/vda1 | pixz -6" | dd of=image.xz
```

**Using gzip to generate gz archive:**

```shell
#obviously substitute your own ip address here and maybe give your archive a better name...
ssh -i your.private.key root@104.131.187.185 "dd conv=sparse if=/dev/vda1 | gzip -1 -" | dd of=image.gz
```

