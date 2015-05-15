#!/bin/bash

  CHARLIST=$1
  DUMP=${CHARLIST%%.*}.svg

  CONF=README.txt

# --------------------------------------------------------------------------- #
# INTERACTIVE CHECKS 
# --------------------------------------------------------------------------- #
  if [ ! -f ${CHARLIST%%.*}.nam ]; then echo; echo "We need a character list!"
                                        echo "e.g. $0 font.nam"; echo
      exit 0;
  fi
  FONTFAMILY=`grep $CHARLIST $CONF | head -n 1 | cut -d ":" -f 2`
   FONTSPEC=`grep $CHARLIST $CONF | head -n 1 | cut -d ":" -f 3`

  if [ `echo $FONTFAMILY | wc -c` -lt 2 ] ||
     [ `echo $FONTSPEC   | wc -c` -lt 2 ]; then 

      echo; echo "Font for output not specified!"
            echo "Please edit $CONF"; echo
      exit 0;
  fi
  if [ -f $DUMP ]; then
       echo "$DUMP does exist"
       read -p "overwrite ${DUMP}? [y/n] " ANSWER
       if [ X$ANSWER != Xy ] ; then echo "Bye"; exit 0; fi
  fi
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- # 
  e() { echo $1 >> ${DUMP}; }
   
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $DUMP
  e '<svg width="800" height="2400" id="svg" version="1.1"'
  e 'xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">'
  e '<g inkscape:label="letter" inkscape:groupmode="layer" id="X">'
  e '<flowRoot xml:space="preserve" id="flowRoot"'
  e "style=\"font-size:36px;\
             line-height:130%;\
             letter-spacing:0px;\
             fill:#000000;\
             fill-opacity:1;\
             stroke:none;\
             font-family:$FONTFAMILY;\
            -inkscape-font-specification:$FONTSPEC\""
  e '><flowRegion id="flowRegion">'
  e '<rect id="rect" width="760" height="2360" x="20" y="20" />'
  e '</flowRegion><flowPara id="flowPara">'

  for CHARACTER in `cat $CHARLIST  | #
                    grep -v space  | #
                    cut -d " " -f 1`
   do
       CHARACTER=`echo -n $CHARACTER | recode u2/x2..h0`
       echo "$CHARACTER" >> $DUMP
  done
  
  e '</flowPara></flowRoot>'
  e '</g>'
  e '</svg>'
# http://stackoverflow.com/questions/21858806/
# remove-n-newline-if-string-contains-keyword
  sed -i -r ':a;$!{N;ba};s/((flowPara)[^\n]*)\n/\1/g' $DUMP


exit 0;


