# Sonarqube

Fix Sonarqube ES
```bash
sudo vim /etc/sysctl.conf

############
vm.max_map_count=262144
############

# Recharger la conf
sudo sysctl -p
```