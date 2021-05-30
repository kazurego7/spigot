# ***************************************
# spigot ビルダー
# ***************************************
FROM openjdk:16-jdk-slim AS spigot-builder

# ビルド済みのファイル置き場
WORKDIR /usr/src/

# ツールのインストール
RUN apt-get update && apt-get install -y \
    git \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# spigot のビルド
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
    && java -jar BuildTools.jar --rev latest \
    && rm BuildTools.jar \
    && rm -r Spigot BuildData Bukkit CraftBukkit apache-maven-*

ENTRYPOINT [ "bash" ]


# ***************************************
# spigot サーバー
# ***************************************
FROM openjdk:16-jdk-slim AS spigot-server

# ファイル置き場
RUN mkdir /var/minecraft
WORKDIR /var/minecraft

# ツールのインストール
RUN apt-get update && apt-get install -y \
    screen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# spigot サーバー & サーバー起動スクリプトの配置
COPY --from=spigot-builder /usr/src/spigot-*.jar spigot.jar
COPY docker-entrypoint.sh docker-entrypoint.sh

ENTRYPOINT [ "./docker-entrypoint.sh" ]