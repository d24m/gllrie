Bash-Script for creating a simple web-gallery
============

Based on (html5slides)[http://code.google.com/p/html5slides]

## Requirements
(ImageMagick)[http://www.imagemagick.org]

## Usage
    cp mkgllry /path/to/pictures
    cd /path/to/pictures
    ./mkgllry.sh
    scp -r gllry webmaster@webserver.example.com:/var/www/mygallery
    google-chrome webserver.example.com/mygallery
