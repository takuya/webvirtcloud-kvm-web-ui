## webvirtcloud docker を動かす


[webvirtcloud](https://github.com/retspen/webvirtcloud) の dockerfile はそのままでは動かない。

公式配布のdocker image がないのでビルドする。


## ビルド

```
export DOCKER_HOST=tcp://172.25.105.131:2375  
bash docker/build.sh
```

## 起動

```
docker run --rm -p 8080:80 -p  6080:6080 takuya/webvirtcloud
```


## dockerfile の書き換えポイント

ssh 経由でほかホストのlibvirtd へ接続できるように

ssh の known_hosts とサーバーの公開鍵を追加した。


