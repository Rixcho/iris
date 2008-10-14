#!/bin/sh
mkdir -p compiled
rm -f compiled/*.js

cd js
cat version.js jslib.js irc/ircconnection.js irc/irclib.js irc/baseircclient.js irc/irctracker.js irc/commandparser.js irc/ircclient.js ui/baseui.js ui/baseuiwindow.js ui/colour.js ui/theme.js qwebircinterface.js > ../compiled/qwebirc-concat.js
cat ui/swmlayout.js ui/swmui.js > ../compiled/swmui-concat.js

error() {
  cd ..
  rm compiled/*-compiled.js
  exit 1
}

catit() {
  cat js/copyright.js compiled/$1-compiled.js > static/js/$1.js
}

xjarit() {
  SRC=$1
  DST=$2
  cd compiled
  java -jar ../bin/yuicompressor-2.3.5.jar $SRC.js > $DST.js
  if [ "$?" != 0 ]; then
    error
  fi
  cd ..
}

jarit() {
  SRC=$1
  DST=$2-compiled
  
  xjarit $SRC $DST
  catit $DST
  rm compiled/$DST.js
}

cd ..
xjarit ../static/js/mochaui/mocha ../static/js/mochaui/mocha-compressed

jarit qwebirc-concat qwebirc
jarit ../js/ui/uglyui uglyui
jarit swmui-concat swmui
jarit ../js/ui/mochaui mochaui

rm compiled/{swmui,qwebirc}-concat.js

rmdir compiled