git clone https://github.com/davidspoofy/AmberVM
cd AmberVM
pip install textual
sleep 2
python3 installer.py
docker build -t ambervm . --no-cache
cd ..

sudo apt update
sudo apt install -y jq

mkdir Save
cp -r AmberVM/root/config/* Save

json_file="AmberVM/options.json"
if jq ".enablekvm" "$json_file" | grep -q true; then
    docker run -d --name=AmberVM-e PUID=1000 -e PGID=1000 --device=/dev/kvm --security-opt seccomp=unconfined -e TZ=Etc/UTC -e SUBFOLDER=/ -e TITLE=AmberVM -p 3000:3000 --shm-size="2gb" -v $(pwd)/Save:/config --restart unless-stopped ambervm
else
    docker run -d --name=AmberVM -e PUID=1000 -e PGID=1000 --security-opt seccomp=unconfined -e TZ=Etc/UTC -e SUBFOLDER=/ -e TITLE=AmberVM -p 3000:3000 --shm-size="2gb" -v $(pwd)/Save:/config --restart unless-stopped ambervm
fi
clear
echo "AmberVM Installed with 0 errors."
