FROM alpine:3.6
MAINTAINER wencaizhang <1052642137@qq.com>

# ENV 设置环境变量，方便下面调用
ENV HUGO_VERSION=0.23 \
    HUGO_USER=hugo \
    HUGO_SITE=/srv/hugo

ENV HUGO_URL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# ADD 后面的 <源路径> 可以是一个 URL，这种情况下，Docker 引擎会试图去下载这个链接的文件放到 <目标路径> 去
# 这里是从 GitHub 下载 hugo 二进制安装包到 /tmp/ 目录下
ADD ${HUGO_URL} /tmp/

# 上面下载的是个压缩包，需要解压缩
RUN tar -xzf /tmp/*.tar.gz -C /tmp \
    && mv /tmp/hugo /usr/local/bin/ \
    && rm -rf /tmp/* \
    && adduser ${HUGO_USER} -D

# 指定当前用户
USER ${HUGO_USER}  

# 指定工作目录，如该目录不存在，WORKDIR 会帮你建立目录
WORKDIR ${HUGO_SITE}

# 定义匿名卷，容器运行时应该尽量保持容器存储层不发生写操作，动态数据文件应该保存于卷(volume)中
VOLUME ${HUGO_SITE}

# 声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务
# 在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；
# 另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口
EXPOSE 1313

# 容器启动命令
CMD ["hugo", "server", "--bind", "0.0.0.0"]