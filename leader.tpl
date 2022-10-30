#!/bin/bash
sudo yum -y update
sudo mkdir /opt/cribl
sudo useradd cribl
sudo chown cribl:cribl /opt/cribl
sudo mkdir /opt/cribl/local 
sudo sh -c "echo '${efsname}.efs.${awsregion}.amazonaws.com:/ /criblshare  nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0' >> /etc/fstab"
sudo mount -a
sudo curl -Lso - $(curl https://cdn.cribl.io/dl/latest-arm64) > /tmp/cribl.tgz
sudo tar xvzf /tmp/cribl.tgz -C /opt
sleep 10
sudo /opt/cribl/bin/cribl mode-master
sudo chown -R cribl:cribl /opt/cribl
sleep 10
sudo /opt/cribl/bin/cribl boot-start enable -m systemd -u cribl
sudo systemctl start cribl
