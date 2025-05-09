FROM node:14

# 安装依赖
RUN apt-get update && apt-get install -y build-essential imagemagick libwebp-dev libclang-dev clang cmake git ffmpeg

# 安装 Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# 安装 rlottie
RUN git clone https://github.com/Samsung/rlottie.git
RUN mkdir /rlottie/build
WORKDIR /rlottie/build
RUN cmake ..
RUN make
RUN make install

WORKDIR /

# 安装 lottieconv
RUN cargo install lottieconv --features="clap gif webp"

# 复制项目文件
COPY . /app
WORKDIR /app

# 安装 Node.js 依赖
RUN npm install

# 运行机器人
CMD ["npm", "start"]