# Mode Gandalf 

you can set parameters by command-line directly without wizard.

## Example:

```bash
warp init --mode-gandalf \
    --namespace=howard  \
    --project=gandalf  \
    --framework=m2  \
    --vhost=local.magento2.com  \
    --php=7.2-fpm  \
    --mysql=5.7  \
    --postgres=9.6.15  \
    --elasticsearch=5.6.8  \
    --redis=3.2.10-alpine  \
    --rabbit=3.7-management  \
    --mailhog  \
    --varnish=5.2.1
```

## Options availables

|  parameter  |  value  |
|  -------  |  -----------  |
| **--namespace**   | string |
| **--project**   | string |
| **--private-registry**   | string |
| **--framework**   | m1, m2, oro, php |
| **--vhost**   | string |
| **--php**   | 5.6-fpm, 7.0-fpm, 7.1-fpm, 7.2-fpm, 7.3-fpm, 7.1.17-fpm, 7.1.26-fpm  |
| **--mysql**   | 5.6, 5.7 |
| **--postgres**   | 9.6.15 |
| **--elasticsearch**   | 6.4.2, 5.6.8, 2.4.6, 2.4.4, 1.7.6 |
| **--redis**   | 3.2.10-alpine, 4.0, 5.0 |
| **--rabbit**   | 3.7-management |
| **--mailhog**   | empty |
| **--varnish**   | 4.0.5, 5.2.1 |