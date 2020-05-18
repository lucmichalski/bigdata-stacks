docker container rm dev-env
docker container run --name=dev-env -it \
       -v ~/workspace:/home/jovyan/workspace:cached \
       -v ~/workspace/python:/opt/pythonlibs/mnt:cached \
       -v ~/datasource:/home/jovyan/datasource:cached \
       -v ~/.m2:/home/jovyan/.m2:cached \
       -p 8888:8888 \
       georgezhu/dev-env start-notebook.sh \
       --ip=* --no-browser --port=8888 --NotebookApp.token='' /home/jovyan/workspace
