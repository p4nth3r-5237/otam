#!/bin/bash

dir=$1
download_ngrok(){
    # wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    unzip ngrok-stable-linux-amd64.zip
    rm ngrok-stable-linux-amd64.zip
}
main(){
    # download_ngrok           # calling download_ngrok fn
    python3 -m http.server --directory $dir &> server.log.txt &   # starting http server
    echo $dir
    ./ngrok http 8000 &> ngrok_url.txt &
    sleep 4
    curl http://localhost:4040/api/tunnels | cut -d '"' -f 14
    temp_file=`tail -n 1 server.log.txt  | cut -d " " -f 7`
    while [ 1 ]
    do
        sleep 6
        filename=`tail -n 1 server.log.txt  | cut -d " " -f 7`
        if [[ $temp_file != $filename && $filename != '/' && $filename != '/favicon.ico' ]]
        then
            rm $dir$filename
            echo "file removed" $filename
            temp_file=$filename
        fi
    done
}

main
