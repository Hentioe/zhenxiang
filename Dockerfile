FROM bluerain/zhenxiang:runtime


ARG APP_HOME=/home/zhenxiang


RUN ln -s "$APP_HOME/zhenxiang" /usr/local/bin/zhenxiang


COPY bin $APP_HOME
COPY public "$APP_HOME/public"


WORKDIR $APP_HOME


ENTRYPOINT zhenxiang --prod -r /resources -o /outputs
