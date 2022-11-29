#!/bin/bash


checkcronallsec()
{
#    grep -ri "\*/15 \* \* \* \*" $@ > /croncheck/tmp/results
#    echo "$(grep -rc "\*/15 \* \* \* \*" /var/spool/cron | cut -d: -f2 | awk 'BEGIN { sum=0 } { sum+=$1 } END {print sum }') CRONS WERE FOUND RUNNING EVERY SECOND" >> /croncheck/tmp/results

    if [[ -s /croncheck/tmp/results ]];
    then
        mv /croncheck/tmp/results /croncheck/tmp/results.$(date -I|tr : -).txt
        touch /croncheck/tmp/results
        echo "EVERY SECOND CRONS" >> /croncheck/tmp/results
        thecrons=$(grep -ri "\* \* \* \* \*" $@);
        croncount=$(grep -rc "\* \* \* \* \*" $@ | cut -d: -f2 | awk 'BEGIN { sum=0 } { sum+=$1 } END {print sum }');
        if [ "$croncount" -gt 0 ]
        then
            echo "$thecrons" >> /croncheck/tmp/results
            echo "$croncount ACCOUNTS FOUND RUNNING CRONS EVERY SECOND" >> /croncheck/tmp/results
        else
            echo "NO RESULT FOUND" >> /croncheck/tmp/results
        fi
    

    else
        echo > /croncheck/tmp/results
        echo "EVERY SECOND CRONS" >> /croncheck/tmp/results    
        thecrons=$(grep -ri "\* \* \* \* \*" $@);
        croncount=$(grep -rc "\* \* \* \* \*" $@ | cut -d: -f2 | awk 'BEGIN { sum=0 } { sum+=$1 } END {print sum }');
 
        if [ "$croncount" -gt 0 ]
        then
            echo "$thecrons" >> /croncheck/tmp/results
            echo "$croncount ACCOUNTS FOUND RUNNING CRONS EVERY SECOND" >> /croncheck/tmp/results
        
        else
            echo "NO RESULT FOUND" >> /croncheck/tmp/results
        fi
    fi
}

checkcronfive()
{
    echo "FIVE MINUTE CRON" >> /croncheck/tmp/results
    thecronsfive=$(grep -ri "\*/5 \* \* \* \*" $@);
    croncountfive=$(grep -rc "\*/5 \* \* \* \*" $@ | cut -d: -f2 | awk 'BEGIN { sum=0 } { sum+=$1 } END {print sum }');
    if [ "$croncountfive" -gt 0 ]
    then
        echo "$thecronsfive" >> /croncheck/tmp/results
        echo "$croncountfive ACCOUNTS FOUND RUNNING CRONS EVERY FIVE MINUTES" >> /croncheck/tmp/results
    else
        echo "NO RESULT FOUND" >> /croncheck/tmp/results
    fi

}

checkcronten()
{
    echo "TEN MINUTE CRON" >> /croncheck/tmp/results
    thecronsten=$(grep -ri "\*/10 \* \* \* \*" $@);
    croncountten=$(grep -rc "\*/10 \* \* \* \*" $@ | cut -d: -f2 | awk 'BEGIN { sum=0 } { sum+=$1 } END {print sum }');
    if [ "$croncountten" -gt 0 ]
    then
        echo "$thecronsten" >> /croncheck/tmp/results
        echo "$croncountten ACCOUNTS FOUND RUNNING CRONS EVERY TEN MINUTE" >> /croncheck/tmp/results
    else
        echo "NO RESULT FOUND" >> /croncheck/tmp/results
    fi

}

createhtml()
{
    $div = '    <ul class="didyoufind-sec">'
    $li = '<li data-edit="text">$line</li>'
    cp -v /croncheck/template.html /croncheck/tmp/emailtemplate.html
#    for line in $(cat /croncheck/tmp/results); do sed '/\$div/a printf \$li' /croncheck/tmp/emailtemplate.html ; done
    $f1="$(</croncheck/tmp/results)"
     awk -vf1="$f1" '/$div/{print;print f1;next}1' /croncheck/tmp/emailtemplate.html
}
   
createhtml

checkcron()
{
    echo "Cron Check 2.1 in progress"
    checkcronallsec $@
    checkcronfive $@
    checkcronten $@
    echo "Done. Full report at /croncheck/tmp/results"
}

checkcron $@


