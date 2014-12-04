#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "----------------------------------------------------"
echo "PATCHING MICROBOSH FOG FOR NIMBUS/CCS COMPATABILITY"
echo "----------------------------------------------------"
echo ""

cd ~ ; wget --no-check-certificate https://raw.githubusercontent.com/FreightTrain/MicroBosh-Patcher/master/create_server.rb.patch


echo "Finding..."
find /var/vcap -iname create_server.rb | grep openstack > ~/patchlist.txt

echo "Patching..."
for i in $(<~/patchlist.txt) ; do patch -p0 $i ~/create_server.rb.patch ; done

echo "Checking..."

for patchedfile in $(<~/patchlist.txt); 

do if grep -q "config_drive" "$patchedfile" ;
then echo "File $patchedfile SUCCEESS"; 
else echo "File $patchedfile FAILED"; 
fi ;
done

echo "-----------------------------------------------------"
echo "PATCHING MICROBOSH EXCON FOR NIMBUS/CCS COMPATABILITY"
echo "-----------------------------------------------------"
echo ""

cd ~ ; wget --no-check-certificate https://raw.githubusercontent.com/FreightTrain/MicroBosh-Patcher/master/constants.rb.patch


echo "Finding..."
find /var/vcap -iname constants.rb | grep excon > ~/patchlist2.txt

echo "Patching..."
for i in $(<~/patchlist2.txt) ; do patch -p0 $i ~/constants.rb.patch ; done

echo "Checking..."

for patchedfile in $(<~/patchlist2.txt); 

do if grep -q "600" "$patchedfile" ;
then echo "File $patchedfile SUCCEESS"; 
else echo "File $patchedfile FAILED"; 
fi ;
done

echo "Patching TMP directory location"

mv /var/vcap/data/tmp /var/vcap/store/.
ln -s /var/vcap/store/tmp /var/vcap/data/.

echo "Restarting services"

monit restart all

echo "-----------------------"
echo "          Done!        "
echo "Check for errors above!"
echo "-----------------------"











