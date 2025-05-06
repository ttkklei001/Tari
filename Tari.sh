#!/bin/bash

# 颜色变量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# 打印署名
function print_signature {
  clear
  echo -e "${BLUE}------------------------"
  echo -e "${YELLOW}Minotari 管理脚本${RESET}"
  echo -e "${RED}📌 作者: K2 节点教程分享${RESET}"
  echo -e "${GREEN}🔗 Telegram: https://t.me/+EaCiFDOghoM3Yzll${RESET}"
  echo -e "${BLUE}🐦 Twitter:  https://x.com/BtcK241918${RESET}"
  echo -e "${BLUE}------------------------${RESET}"
}

# 克隆 Minotari 项目源码
function clone_repo {
  echo "📥 正在克隆 Minotari 项目源码..."
  if [ ! -d "tari" ]; then
    git clone https://github.com/tari-project/tari.git
  fi
  cd tari || exit
}

# 安装所有必备依赖
function install_dependencies {
  echo "🧱 安装 Minotari 所需的依赖..."
  sudo apt-get update
  sudo apt-get -y install \
    openssl libssl-dev pkg-config libsqlite3-dev \
    clang git cmake libc++-dev libc++abi-dev \
    libprotobuf-dev protobuf-compiler \
    libncurses5-dev libncursesw5-dev \
    libudev-dev \
    automake autoconf libtool \
    wget apt-transport-https \
    libevent-dev libzmq3-dev \
    libssl-dev libboost-all-dev \
    screen
  echo -e "${GREEN}依赖安装完成！${RESET}"
}

# 安装 PowerShell
function install_powershell {
  echo "💻 安装 PowerShell..."
  sudo apt-get install -y wget apt-transport-https
  wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt-get update
  sudo add-apt-repository universe
  sudo apt-get install -y powershell
  echo -e "${GREEN}PowerShell 安装完成！${RESET}"
}

# 安装 Rust 编译环境
function install_rust {
  echo "🔧 安装 Rust 编译环境..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source "$HOME/.cargo/env"
  echo -e "${GREEN}Rust 编译环境安装完成！${RESET}"
}

# 编译 Minotari 项目
function compile_project {
  echo "⚙️ 正在编译 Minotari 项目..."
  cargo build --release
  echo -e "${GREEN}Minotari 项目编译完成！${RESET}"
}

# 启动 Minotari 节点（固定命令）
function start_node {
  echo -e "${GREEN}正在启动 Minotari 节点（挖矿中）...${RESET}"
  screen -S minotari_node_session ./target/release/minotari_node --base-path /root/.tari --config /root/.tari/mainnet/config/config.toml
  echo -e "${YELLOW}节点已启动并进入 screen，会话名称：minotari_node_session${RESET}"
  echo "按 Ctrl + A 然后按 D 可返回终端。"
}

# 启动钱包查看程序
function view_wallet {
  echo "📂 启动钱包查看程序..."
  ./target/release/minotari_console_wallet
}

# 查看节点日志
function view_node_logs {
  echo "📜 正在查看节点日志..."
  screen -r minotari_node_session
}

# 显示菜单
function show_menu {
  print_signature
  echo -e "${YELLOW}Minotari 管理菜单${RESET}"
  echo -e "${BLUE}------------------------${RESET}"
  echo -e "1. ${GREEN}安装依赖并编译项目${RESET}"
  echo -e "2. ${GREEN}启动 Minotari 节点（挖矿）${RESET}"
  echo -e "3. ${GREEN}查看钱包${RESET}"
  echo -e "4. ${GREEN}查看节点日志${RESET}"
  echo -e "5. ${RED}退出${RESET}"
  echo -e "${BLUE}------------------------${RESET}"
  echo -n "请选择操作 (1-5): "
  read -r choice

  case $choice in
    1) clone_repo && install_dependencies && install_rust && install_powershell && compile_project ;;
    2) start_node ;;
    3) view_wallet ;;
    4) view_node_logs ;;
    5) exit 0 ;;
    *) echo -e "${RED}无效选择，请重新输入。${RESET}" ;;
  esac
}

# 主循环
while true; do
  show_menu
done
