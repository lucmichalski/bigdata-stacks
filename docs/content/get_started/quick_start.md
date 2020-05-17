# Quick Start

Download Vigie and run tests
{: .subtitle }

!!! tip "Standalone Vigie"
    This step by step quickstart will run Vigie in its simplest operating mode : _Standalone_.
    More advanced and automated deployments are available in [Vincoll/vigie-deploy](https://github.com/Vincoll/vigie-deploy)

## Get Vigie

### Download the binary

_Vigie is a single binary with no dependencies._

```bash tab="Linux"
wget https://github.com/Vincoll/vigie/releases/download/v0.6.0/vigie_v0.6.0_linux_amd64.tar.gz && \
tar -xzvf vigie_v0.6.0_linux_amd64.tar.gz
```

```bash tab="Windows"
wget "https://github.com/Vincoll/vigie/releases/download/v0.6.0/vigie_v0.6.0_linux_amd64.zip" -outfile "vigie_v0.6.0_linux_amd64.zip"
```

```bash tab="With Docker"
docker pull vincoll/vigie:0.6.0
```

### Get a Vigie configuration file

_Grab a pre-configure Vigie Config, ready to run._

!!! info "Vigie tests auto-provisioning"
    Tests will be downloaded by Vigie from the [vigie-demo-test](https://github.com/Vincoll/vigie-demo-test) git repo.

```bash tab="Linux"
wget -O vigieconf_standalone.toml https://raw.githubusercontent.com/Vincoll/vigie-demo-test/master/vigieconf_standalone.toml
```

```bash tab="Windows"
wget https://raw.githubusercontent.com/Vincoll/vigie-demo-test/master/vigieconf_standalone.toml -outfile "vigieconf_standalone.toml"
```

```bash tab="With Docker"
wget -O vigieconf_standalone.toml https://raw.githubusercontent.com/Vincoll/vigie-demo-test/master/vigieconf_standalone.toml
```

**Edit VigieConf (optional)**

You can quickly edit the config to configure the alerting, or change the API port if you wish.

## Run Vigie

*Adding capacity to Vigie is mandatory in order to send icmp requests.*

```bash tab="Linux"
chmod +x ./vigie && \
sudo setcap cap_net_raw,cap_net_bind_service=+ep ./vigie && \
vigie run --config vigieconf_standalone.toml
```

```bash tab="Windows"
vigie run --config vigieconf_standalone.toml
```

```bash tab="With Docker"
docker run \
-v $(pwd)/vigieconf_standalone.toml:/app/config/vigie.toml \
--name vigie-demo \
-p 6680:80
vincoll/vigie:0.6.0
```

## Access the API
_No WebUI yet :/_

Go to [http://localhost:6680/api/testsuites/all](http://localhost:6680/api/testsuites/all)