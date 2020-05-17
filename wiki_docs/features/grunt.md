# How to config Grunt on Magento 2

Just 5 steps, you can config **Grunt** 

1) From the Magento_root directory, copy and paste the contents of the following files:

```bash
cp package.json.sample package.json
cp Gruntfile.js.sample Gruntfile.js
cp grunt-config.json.sample grunt-config.json
```

2) Install Grunt Cli

Inside the container, run the following command in a command prompt:

```bash
warp php ssh --root
```

After that install **npm** and **grunt**. 

```bash
npm install
npm install -g grunt-cli
```

3) Modify file **grunt-config.json** like that:

```bash
{
    "themes": "dev/tools/grunt/configs/themes"
}
```

4) Config theme in file **dev/tools/grunt/configs/themes.js**

by default you have **luma**, and you can use example to add **warp**

Example path: **app/design/frontend/WarpTheme/default**

```
warp: {
        area: 'frontend',
        name: 'WarpTheme/default',
        locale: 'en_US',
        files: [
            'css/styles-m',
            'css/styles-l'
        ],
        dsl: 'less'
    },
```

5) Ready!!, every time we need to compile content, we run console:

```
warp grunt exec
warp grunt less
```

After that, you can see:

![grunt-exec](../img/grunt.jpg)


## Grunt commands

The following table describes the grunt commands you can use to perform different customization tasks. Run all commands from your Magento installation directory.

|  Grunt task  |  Action  |
|  ----------  |  -----------  |
| **warp grunt clean** | Removes the theme related static files in the `pub/static` and var directories. |
| **warp grunt exec** | Republishes symlinks to the source files to the `pub/static/frontend/` directory. Use `warp grunt exec:<theme>` to republish symlinks for a specific theme. |
| **warp grunt less** | Compiles CSS files using the symlinks published in the `pub/static/frontend/` directory. Use `warp grunt less:<theme>` to use the symlinks published for a specific theme. |
| **warp grunt watch** | Tracks the changes in the source files, recompiles `.css` files, and reloads the page in the browser. |

[Ref. Magento Docs:](https://devdocs.magento.com/guides/v2.3/frontend-dev-guide/css-topics/css_debug.html)

