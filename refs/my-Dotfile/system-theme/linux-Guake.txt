

###  版本修改
1. gcc and g++  
```sh
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60  
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40  
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60  
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 40  
```

2. 切换版本  
```sh
update-alternatives --config gcc
```

3. 删除  
```sh
update-alternatives --remove gcc /usr/bin/gcc-4.6
```


### Guake 终端颜色
#555753 #F9555F #83ADDA #FDF029 #FCAF3E #AD7FA8 #1E9EE6 #BBBBBB #FFFFFF

#8AE234 #FA8B8E #34BB99 #FFFF55 #589CF5 #E75598 #8AE234 #FFFFFF #1C2836


###  WPS图标
- 表格 /usr/share/icons/hicolor/256x256/apps/wps-office-etmain.png  
- PPT /usr/share/icons/hicolor/256x256/apps/wps-office-wppmain.png  
- WORD /usr/share/icons/hicolor/256x256/apps/wps-office-wpsmain.png
