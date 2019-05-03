FROM bluerain/zhenxiang:runtime


ARG APP_HOME=/home/zhen_xiang


RUN ln -s "$APP_HOME/zhen_xiang" /usr/local/bin/zhen_xiang


COPY bin $APP_HOME
COPY public "$APP_HOME/public"


WORKDIR $APP_HOME


ENTRYPOINT zhen_xiang --prod -r /resources -o /outputs
