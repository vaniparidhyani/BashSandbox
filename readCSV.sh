#!/bin/bash

csv_file=$1
admin_passwd=$2
server_url=$3

while read PDF
do
	pdf_path=`echo $PDF | sed -e 's/http:\/\/author-server\:4502//g' | tr -d '\r'`
	curl -s -u admin:$admin_passwd -X POST -F path=$pdf_path -F cmd="deactivate" "$server_url/bin/replicate.json"
	sleep 10
	curl -u admin:$admin_passwd -X DELETE "$server_url$pdf_path"
	sleep 10
	status=$(curl -s --head -w %{http_code} http://author-server$pdf_path -o /dev/null -u admin:$admin_passwd)
	if [ "$status" == "404" ]
		then
		echo "$pdf_path Page deleted successfully from Oregon"
	else
		echo "$pdf_path Page not deleted from Oregon"
		exit 1
	fi
	status=$(curl -s --head -w %{http_code} http://author-server$pdf_path -o /dev/null -u admin:$admin_passwd)
        if [ "$status" == "404" ]
                then
                echo "$pdf_path Page deleted successfully from Ireland"
        else
                echo "$pdf_path Page not deleted from Ireland"
                exit 1
        fi
	status=$(curl -s --head -w %{http_code} http://author-server$pdf_path -o /dev/null -u admin:$admin_passwd)
        if [ "$status" == "404" ]
                then
                echo "$pdf_path Page deleted successfully from Tokyo"
        else
                echo "$pdf_path Page not deleted from Tokyo"
                exit 1
        fi
	

done < $csv_file
