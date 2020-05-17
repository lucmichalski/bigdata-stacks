# How to install Magento with WARP

## Create new folder

```
mkdir magento_demo
```


## Download WARP

```
curl -L -o warp http://ct.summasolutions.net/warp-engine/warp && chmod 755 warp
```

## Configure services

```
warp init --mode-gandalf \
    --framework=m2  \
    --vhost=local.magento2.com  \
    --php=7.2-fpm  \
    --mysql=5.7  \
    --elasticsearch=5.6.8  \
    --redis=3.2.10-alpine  \
    --mailhog
```

## Download Magento

```
warp magento --download 2.3.2
```

## Start project

```
warp start
```

## Install Magento 

```
warp magento --install
```

## Create access to website

```bash
echo "127.0.0.1   local.magento2.com" | sudo tee -a /etc/hosts > /dev/null
```

### Requeriments

```
Docker
docker-compose

docker-sync (mac only)
rsync ^3.1.1
```

### Access to website or admin/panel

| parameter | value |
| --------  | -----------------------  |
|**website:** | [https://local.magento2.com](https://local.magento2.com) |
|**Url:**   | [https://local.magento2.com/admin](https://local.magento2.com/admin) |
|**User:**  | admin                    |
|**Pass:**  | Password123              |
