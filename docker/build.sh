

cd  $( dirname $0 )
## git clone 
if [[ ! -e ../webvirtcloud ]]; then
  cd ..
  git clone https://github.com/retspen/webvirtcloud.git
  cd -
fi
## working copy 
rsync -a  ../webvirtcloud .


## modify dockerfile 
cp webvirtcloud/Dockerfile .
if [[ ! -e  webvirtcloud.settings.py && ! -e webvirtcloud/webvirtcloud/settings.py ]];then 
  cp webvirtcloud/webvirtcloud/settings.py.template webvirtcloud.settings.py
  sed -i "s|SECRET_KEY = \"\"|SECRET_KEY = \"$(openssl rand -base64 30)\"|" webvirtcloud.settings.py 
  cp webvirtcloud.settings.py webvirtcloud/webvirtcloud/settings.py
fi


sed -i 's|COPY \. |COPY \./webvirtcloud |g' Dockerfile
sed -i 's|COPY conf/|COPY ./webvirtcloud/conf/|g' Dockerfile


## ssh 設定
if [[ ! -e ./ssh ]]; then 
  mkdir ssh 
  ssh-keygen -t rsa -f ssh/id_rsa.hoge < /dev/null
  truncate -s0 ssh/known_hosts
fi

kvm_hosts=(
  192.168.111.5
  192.168.111.9
  192.168.11.240
  192.168.11.12.10
)
truncate -s0 ssh/known_hosts
for host_ip in kvm_hosts;do 
  ssh-keyscan  -H $kvm_hosts 2>/dev/null >> ssh/known_hosts
done
echo "

RUN mkdir /var/www/.ssh
COPY ./ssh/ /var/www/.ssh 
RUN chown www-data: -R  /var/www/ ; chmod 700 /var/www/.ssh -R 

" >> Dockerfile

docker build -t takuya/webvirtcloud  .

