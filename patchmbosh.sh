#!/bin/bash

echo "----------------------------------------------------"
echo "PATCHING MICROBOSH DIRECTOR FOR NIMBUS COMPATABILITY"
echo "----------------------------------------------------"
echo ""
echo "You will be prompted for your SUDO password..."

cd ~ ; wget https://raw.githubusercontent.com/FreightTrain/MicroBosh-Patcher/master/create_server.rb.patch


echo "Finding..."
sudo find /var/vcap -iname create_server.rb | grep openstack > ~/patchlist.txt

echo "Patching..."
sudo for i in $(<~/patchlist.txt); do patch -p0 $i ~/create_server.rb.patch ; done

echo "Checking..."

for patchedfile in $(<~/patchlist.txt); 

do if grep -q "config_drive" "$patchedfile" ;
then echo "File $patchedfile SUCCEESS"; 
else echo "File $patchedfile FAILED"; 
fi ;
done

echo "Patching TMP directory location"

sudo mv /var/vcap/data/tmp /var/vcap/store/.
sudo ln -s /var/vcap/store/tmp /var/vcap/data/.

echo "-----"
echo "Done!"
echo "-----"











