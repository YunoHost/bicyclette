#!/bin/bash

BASE_URL="http://vindler.netlib.re"

INDEXTMP="www/index.tmp"
rm -f $INDEXTMP

cat << EOF >> $INDEXTMP
<h3>Recent tests</h3>
<table class="u-full-width">
  <thead>
    <tr>
      <th>Date</th>
      <th>Init errors</th>
      <th>Install errors</th>
      <th>Postinstall errors</th>
    </tr>
  </thead>
  <tbody>
EOF


for SUMMARY in `ls logs/*/summary.log`;
do
    echo "<tr>"  >> $INDEXTMP
    
    INPUT=`dirname $SUMMARY`
    DATE=`basename $INPUT`
    OUTPUT="www/tests/$DATE"
    mkdir -p $OUTPUT

    HUMAN_READABLE_DATE=`sed -e "s/\(...........\)\(..\)\(..\)/\1:\2:\3/" <<< $DATE | tr '-' ' '`
    HUMAN_READABLE_DATE=`date --date="$HUMAN_READABLE_DATE"`
    echo "<td>$HUMAN_READABLE_DATE</td>" >> $INDEXTMP
    for FILE in 00_init 10_install 20_postinstall;
    do
        STEP=`echo $FILE | tr '_' ' ' | awk '{print $2}'` 
        TMP=$OUTPUT/$FILE.tmp
        rm -f $TMP
cat << EOF >> $TMP
<h3>$HUMAN_READABLE_DATE</h3>
<h4>$STEP</h4>
<div class="row">
<pre><code>
EOF
        cat $INPUT/$FILE.log | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' | sed ':a;N;$!ba;s@\n--\n@\n</code></pre>\n</div>\n<div class="row">\n<pre><code>@g' >> $TMP
cat << EOF >> $TMP
</code></pre>
</div>
EOF
        HTML=$OUTPUT/$FILE.html
        cp www/template.html $HTML
        sed -i -e "/THE_CONTENT/{r $TMP" -e "d}" $HTML
        sed -i "s@BASE_URL@$BASE_URL@g" $HTML
        rm $TMP
    
        
        
        
        
        N_ERRORS=`cat $SUMMARY | grep "^$STEP:" | awk '{print $2}'`
        echo "<td><a href=\"$BASE_URL/tests/$DATE/$FILE.html\">$N_ERRORS</a></td>" >> $INDEXTMP
    done

    echo "</tr>" >> $INDEXTMP
done

cat << EOF >> $INDEXTMP
</tbody>
</table>
EOF

cp www/template.html www/index.html
sed -i -e "/THE_CONTENT/{r $INDEXTMP" -e "d}" www/index.html
sed -i "s@BASE_URL@$BASE_URL@g" www/index.html
rm $INDEXTMP
