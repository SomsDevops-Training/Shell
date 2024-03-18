#!/bin/bash

# Function to check filesystems
check_filesystem() {
    read -p "Enter filesystem to check: " fsanswer
    echo "Below are the mounts for $fsanswer: "
    df -h | grep -i "$fsanswer"
}

# Function to check the status of services
check_services() {
    read -p "Enter the service name to check status: " svc_name
    echo ""
    if [ "$svc_name" = "ab-reporter" ]; then
        "$svc_name" status
        echo ""
        read -p "Do you see the $svc_name service running (yes/no): " user_answer
        if [ "$user_answer" = "no" ]; then
            echo "Restarting the $svc_name service"
            echo "================================="
            echo ""
            unset HTTPS_PROXY
            unset https_proxyn
            unset __AB_PROJECT_INVOKED environment
            export AB_HOME=/dsap/opt/abinitio/abinitio
            export PATH=$AB_HOME/bin:$PATH
            export AB_APPLICATION_HUB=/dsap/opt/abinitio/abinitio-app-hub
            $svc_name start
            sleep 5
            $svc_name status
        fi
    else
        systemctl status "$svc_name"
    fi
}

# Function to check file or directory permissions
check_files_permissions() {
    echo ""
    echo "====================================================================="
    echo "Checking teradata library files & Python version with permissions"
    echo "====================================================================="
    echo ""
    cd /usr/lib64
    ls -ld /opt/teradata/client/15.10/odbc_64/lib/libodbc.so linodbc.so
    echo ""
    ls -ld /opt/teradata/client/15.10/lib64/libodbcinst.so libodbcinst.so
    echo ""
    echo "====================================================================="
    echo "checking python version and its permissions"
    echo "====================================================================="
    python --version
    ls -ltra /usr/lib/python2.7/site-packages/requests-2.26.0.dist-info
    echo ""
    ls -ltra /usr/lib/python2.7/site-packages/urllib3-1.26.6.dist-info
    echo ""
    ls -ltra /usr/lib/python2.7/site-packages/idna-2.10.dist-info
    echo ""
    ls -ltra /usr/lib/python2.7/site-packages/chardet-4.0.0.dist-info
    echo ""
    ls -ltra /usr/lib/python2.7/site-packages/certifi-2021.5.30.dist-info
    echo ""
    ls -ltra /usr/lib/python2.7/site-packages/requests
    echo ""
}

# Function to check air commands
check_air_commands() {
    air ls
}

# Function to check AbInitio key validation
check_abinitio_keyvalidation() {
    echo ""
    echo "AbInitio Key Validation"
    ab-key show
}

# Function to check process/service
process_check_abksd_telegraf_protegrity_connectdirect() {
    ps -ef | grep -i "$1"
}

# Function to check whether python-requests modules are patched
check_python_requestsRPM() {
    output=$(rpm -qa --last | grep python-requests)
	if [ -z $output ];
	then
	echo "there is no python-request installed"
	else
	echo "$output"
	fi
}

# Function to check Java/openJDK version
check_openjdk() {
    java -version
}

# Main Menu
while true; do
    clear
    echo "1. Check filesystem mount points GPFS/NAS"
    echo "2. Check the status of services [ab-reporter/datahub/livequeue/spread/prtgrty]"
    echo "3. Check file or directory permissions [teradata/python]"
    echo "4. Check air commands"
    echo "5. Check AbInitio key Validatio"
    echo "6. Process/service checking [abksd/tele/pepserve/cdp]"
    echo "7. Check whether python-requests modules are patched"
    echo "8. Check Java/openJDK version"
    echo "9. Exit"
    echo "=========================================================="
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1) check_filesystem ;;
       # 2) read -p "Enter the service name to check status: " svc_name
       #     check_services "$svc_name" ;;
        2) check_services ;;
        3) check_files_permissions ;;
        4) check_air_commands ;;
        5) check_abinitio_keyvalidation ;;
        6) read -p "Enter the process/service name to check (abksd/tele/pepserve/cdp): " pcs_name
           process_check_abksd_telegraf_protegrity_connectdirect "$pcs_name" ;;
        7) check_python_requestsRPM ;;
        8) check_openjdk ;;
        9) echo "Exiting..."; exit ;;
        *) echo "Invalid choice. Please enter choices between 1 to 9." ;;
    esac

    echo -n "Do you want to return to the main menu? (yes/no): "
    read return_choice
    if [ "$return_choice" != "yes" ]; then
        echo "Exiting...."
        exit
    fi
done

