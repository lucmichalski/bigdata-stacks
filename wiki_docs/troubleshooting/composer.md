## command **warp composer**

`warp composer install`

```bash
warp composer install --ignore-platform-reqs

Cannot create cache directory /var/www/.composer/cache/repo/https---repo.magento.com/, or directory is not writable. Proceeding without cache
Cannot create cache directory /var/www/.composer/cache/repo/https---composerep.stg.aws3.net/, or directory is not writable. Proceeding without cache
Cannot create cache directory /var/www/.composer/cache/repo/https---composerm2.stg.aws3.net/, or directory is not writable. Proceeding without cache
Cannot create cache directory /var/www/.composer/cache/repo/https---repo.onestepcheckout.com-IY2HYKW9UX4N2CWTSHLF/, or directory is not writable. Proceeding without cache
Cannot create cache directory /var/www/.composer/cache/repo/https---composerexternalm2.stg.aws3.net/, or directory is not writable. Proceeding without cache
Cannot create cache directory /var/www/.composer/cache/repo/https---repo.packagist.org/, or directory is not writable. Proceeding without cache
Cannot create cache directory /var/www/.composer/cache/files/, or directory is not writable. 
Proceeding without cache
```

### possible solutions
- `warp fix --composer`

-------------

## Error **chmod()**

```bash
  [ErrorException]                  
  chmod(): Operation not permitted  
```

### possible solutions
- `warp fix --composer`