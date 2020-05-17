import os

with open("warp.conf", "a") as f:

    for osKey in os.environ.keys():
        key = osKey
        if not key.startswith("WARPENV_"):
            continue

        keys = key.split("_")[1:]
        #print(keys)
        keys = [key.lower() for key in keys]
        keyWarp = '.'.join(keys)
        #print(keyWarp + ' = ' + os.environ[osKey] + '\n')
        f.write(keyWarp + ' = ' + os.environ[osKey] + '\n')

f.close()