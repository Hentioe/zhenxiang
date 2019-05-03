FROM bluerain/crystal:runtime


RUN apt update && \
    apt install ffmpeg fonts-noto-cjk -y && \
    rm -rf /var/lib/apt/lists/*  && \
    rm -rf /var/lib/apt/lists/partial/*