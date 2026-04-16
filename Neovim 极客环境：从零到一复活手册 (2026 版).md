# 🌌 Neovim 极客环境：从零到一复活手册 (2026 版)

## 🛠️ 第一阶段：核心工具“全家桶”安装

不要一个一个安装，直接用这一段复合命令完成底座搭建。

### 1. 基础依赖 (Ubuntu/Debian)

Bash

```shell
sudo apt update && sudo apt install -y \
  git curl wget build-essential xclip \
  nodejs npm python3-pip luarocks \
  ripgrep fd-find
```

### 2. 核心神器 (手动下载最新版)

> **极客提示：** 官方仓库太旧，直接去 GitHub 拿二进制包。

Bash

```shell
# 安装 Neovim (AppImage 方式最稳)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# 安装最新版 fd (解决旧版冲突)
curl -LO https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb
sudo dpkg -i fd_10.2.0_amd64.deb && rm fd_10.2.0_amd64.deb

# 安装 Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit && sudo install lazygit /usr/local/bin/ && rm lazygit.tar.gz
```

------

## 📂 第二阶段：配置文件“一键回蓝”

这是最重要的资产。建议你现在就把 `~/.config/nvim` 上传到你的 GitHub。

### 1. 恢复配置目录

如果你有 GitHub 备份，下次只需一行：

Bash

```sh
git clone https://github.com/你的用户名/你的配置仓库.git ~/.config/nvim
```

### 2. 建立私人武器库 (PATH 路径)

Bash

```sh
mkdir -p ~/.local/bin
# 这里的软链接确保插件能找到 fd
ln -sf $(which fd) ~/.local/bin/fdfind 
```

------

## 🎨 第三阶段：视觉美化 (视觉党必看)

没有图标的 Neovim 是没有灵魂的。

### 1. 宿主机字体 (Nerd Font)

在你的 **Windows/Mac 宿主机**上安装 [JetBrainsMono Nerd Font](https://www.google.com/search?q=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip)。

- **终端设置**：字体选择 `JetBrainsMono NFM`。
- **效果**：你会看到彩色的 Git 分支、文件图标和状态栏。

### 2. 解决 Treesitter 编译报错 (补丁)

在新机器上，务必记得我们今天写的那个 `treesitter.lua` 补丁，防止 Glibc 版本过低：

Lua

```shell
-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  opts = { auto_install = true },
  config = function(_, opts)
    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup(opts)
  end,
}
```

------

## 🚀 第四阶段：首次启动“大保健”

第一次输入 `nvim` 后，请保持耐心，依次执行：

1. **自动下载**：LazyVim 会自动弹窗安装所有插件（确保你的代理 `https_proxy` 已开启）。
2. **健康检查**：输入 `:checkhealth`。
3. **语法更新**：输入 `:TSUpdate`。
4. **工具补全**：输入 `:Mason`，手动安装你需要的 LSP（如 `pyright` 或 `clangd`）。

------

## 📜 懒人总结表

| **动作**   | **快捷键**    | **备注**            |
| ---------- | ------------- | ------------------- |
| **找文件** | `<Space> f f` | 极速秒搜            |
| **搜代码** | `<Space> /`   | 全局搜索文本        |
| **搞 Git** | `<Space> g g` | 弹出 Lazygit 界面   |
| **看历史** | `<Space> u u` | 时间旅行 (UndoTree) |
| **退程序** | `:q!`         | 别忘了加冒号        |

------

### 💡 最后的极客建议

**“配置文件就是你的数字大脑。”** 既然环境已经调得这么顺手了，今晚就把 `~/.config/nvim` 文件夹变成一个 Git 仓库传到 GitHub 吧！下次换电脑，你只需要 `git clone`，剩下的交给自动化。

**如果你准备好了，我可以教你如何快速把配置推送到 GitHub？**