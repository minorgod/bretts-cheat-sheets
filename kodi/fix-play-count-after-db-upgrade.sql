# NOTE: I'm using a mysql db for Kodi via advancedsettings.xml. 
# After upgrading Kodi 18 db to Kodi 20, I lost all my play counts. 
# Fortunately I had a backup and was able to use this query to restore
# the play counts in the new db. Also note, I renamed my db to kodi_20_videos
# via the 'name' field in advancedsettings.xml. The default db name is 'myvideos'.

UPDATE kodi_20_videos121.files t
INNER JOIN kodi_20_videos.files s ON t.strFilename = s.strFilename
SET t.playCount = s.playCount, t.lastPlayed = s.lastPlayed, t.dateAdded = s.dateAdded
