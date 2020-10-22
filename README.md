# dashify-tools

Some tools to "MPEG-DASH"ify a source video

Requirements: You need to have the x264, gpac, ffmpeg, unzip, and Bento4 packages installed on your system.

If you are using Amazon AWS, you must use the "Ubuntu Server 20.04 LTS (HVM), SSD Volume Type" or similar.
Once you start up a VM using Ubuntu, you log into it using the 'ubuntu' username via:

$ ssh ubuntu@<ip-address>

To set up the packages you need:

$ sudo apt-get update
$ sudo apt-get install x264 gpac ffmpeg unzip
$ wget http://zebulon.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip
$ unzip Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip
$ export PATH=${PATH}:Bento4-SDK-1-6-0-637.x86_64-unknown-linux/bin

Now you can start dashifying mp4 videos.  For example, to use the Caminandes Llamigo video
from the Blender Foundation, you would do the following:

$ wget http://www.caminandes.com/download/03_caminandes_llamigos_1080p.mp4
$ ./dashify.sh 03_caminandes_llamigos_1080p.mp4

Finally, copy the stream.mpd file, the video subdirectory tree, and mpeg-dash-test.html into your
web server's document root.

Enjoy!
