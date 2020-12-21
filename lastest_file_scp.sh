#scp the lastest file to the dest path of server
#!/bin/bash
TIME_INTERVAL=60 #default 60s
function scp_the_latest_file_to_server()
{
    #get parameters
    server_ip=$1
    server_dest_path=$2
    local_file_path=$3
    #get the lastest file
    lastest_file=`ls -t $local_file_path | head -n 1`
    echo "the lastest file:"$lastest_file
    #get the system and file tiimestamp
    system_timestamp=$(date +%s)
    echo "system current timestamp:"$system_timestamp
    lastest_file_path=$local_file_path/$lastest_file
    echo "lastest file path:"$lastest_file_path
    lastest_file_timestamp=$(stat -c %Y $lastest_file_path)
    echo "lastest file current timestamp:"$lastest_file_timestamp
    #judge the time difference
    let difference=lastest_file_timestamp-system_timestamp
    if [ $difference -lt 0 ];then
        let difference=-difference
    fi
    echo "timestamp difference:"$difference
    if [ $difference -le $TIME_INTERVAL ];then
        scp $lastest_file_path $server_ip:$server_dest_path
        if [ $? -eq 0 ];then
            echo 'scp work ok.'
        fi
    fi
}
while true
do
    scp_the_latest_file_to_server 10.50.21.167 /home/ /home/wangbin/test
    sleep $TIME_INTERVAL
done