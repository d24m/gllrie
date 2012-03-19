Bash-Script for creating a simple web-gallery
============

Based on [html5slides](http://code.google.com/p/html5slides)

## Requirements
[ImageMagick](http://www.imagemagick.org)

## Usage
    cp mkgllrie.sh /path/to/pictures
    cd /path/to/pictures
    ./mkgllrie.sh
    scp -r gllrie webmaster@webserver.example.com:/var/www/mygallery
    google-chrome webserver.example.com/mygallery
