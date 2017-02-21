#!/bin/sh                                                                         
                                                                                     
echo "Switching Wifi band" | logger -s -t "LongPress" -p user.info                  
                                                                                     
# Orange LED for 2 seconds                                                           
(BLDC_Test_Bench -G 1 1 0 >/dev/null; sleep 2; BLDC_Test_Bench -G 0 1 0 >/dev/null) &
                                                                                     
#pipe="/tmp/.dragon-pipe-in"                                                         
#switch_message="switch_wifi_band"                                                   
                                                                                     
#if [ -p $pipe ]                                                                     
#then                                                                                
#    echo $switch_message > $pipe &                                                  
#fi                                                                                  
                                                                                     
ESSID=DroneAP                                                                        
DEFAULT_WIFI_SETUP=/sbin/broadcom_setup.sh                                           
                                                                                     
echo "Trying to connect to $ESSID" | logger -s -t "LongPress" -p user.info           
                                                                                     
#Bring access point mode down                                                             
$DEFAULT_WIFI_SETUP remove_net_interface                                             
                                                                                     
# Configure wifi to connect to given essid                                           
ifconfig eth0 down                                                                   
bcmwl country us                                                                     
bcmwl ap 0                                                                           
bcmwl down                                                                           
bcmwl ap 0                                                                           
bcmwl auth 0                                                                         
bcmwl band auto                                                                      
bcmwl ssid ${ESSID}                                                                  
bcmwl join ${ESSID}                                                                  
bcmwl up                                                                             
bcmwl join ${ESSID}                                                                  
bcmwl ssid > /home/ssid1.txt                                                         
ifconfig eth0 192.168.1.<drone_ip> netmask 255.255.255.0 up
                                                                                     
#Set light back to green after 1 second                                              
(sleep 1; BLDC_Test_Bench -G 0 1 0 > /dev/null) &                                    
                                                                                     
ifconfig > /home/config2.txt                                                         
bcmwl ssid > /home/ssid2.txt                                                         
bcmwl ap > /home/ap.txt                                                              
bcmwl status > /home/status_nuevo.txt
