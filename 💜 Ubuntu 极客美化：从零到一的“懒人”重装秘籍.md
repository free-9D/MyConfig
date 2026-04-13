# 💜 Ubuntu 极客美化：从零到一的“懒人”重装秘籍

本方案采用 **Orchis 深紫** 视觉体系与 **WezTerm** 现代渲染架构，完美契合 408 考研人的生产力需求。

------

## 🛠️ 第一阶段：系统基石与 Shell 灵魂

**目标：** 告别简陋的 Bash，换上带“记忆”和“高亮”的 Zsh 交互环境。

### 1. 核心包安装

Bash

```shell
sudo apt update && sudo apt install -y zsh git curl wget fonts-jetbrains-mono
```

### 2. Oh My Zsh 一键部署

Bash

```shell
# 安装 OMZ
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 注入插件：自动补全 + 语法高亮
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 修改配置：启用插件并设置 agnoster 主题
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
source ~/.zshrc
```

------

## 🎨 第二阶段：视觉整容 (Orchis Purple)

**目标：** 统一系统 UI 与图标，消除 Ubuntu 原始的“土味橙”。

### 1. 桌面工具准备

Bash

```shell
sudo apt install -y gnome-tweaks gnome-shell-extension-manager
```

### 2. 主题与图标自动化下载

Bash

```sh
# 下载并安装 Orchis 主题 (紫色版)
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme && ./install.sh -t purple -s standard && cd ..

# 下载并安装 Tela 图标 (紫色圆角)
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme && ./install.sh -c purple && cd ..
```

> **手动动作（仅需一次）：** > 打开 **Tweaks (优化)** 软件 -> **Appearance (外观)**：
>
> - **Cursor:** 选择你喜欢的图标。
> - **Icons:** 选择 `Tela-circle-purple`。
> - **Shell / Legacy Windows:** 选择 `Orchis-Purple-Dark`。

------

## 🚀 第三阶段：WezTerm 终极终端

**目标：** 解决 Webkit 内存报错痛点，实现丝滑的**连体字 (Ligatures)** 效果。

### 1. 离线包安装 (绕过网络卡顿)

Bash

```shell
wget https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb
sudo apt install ./wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb -y
```

### 2. 注入“紫色极客”配置文件

直接执行此命令，自动创建 `~/.wezterm.lua`：

Bash

```shell
cat <<EOF > ~/.wezterm.lua
local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 13.0
config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.color_scheme = 'Catppuccin Mocha'
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

return config
EOF
```

------

## ⚙️ 第四阶段：系统接管与快捷键

**目标：** 让 WezTerm 成为系统的亲儿子，一键唤醒。

### 1. 设置为默认终端模拟器

Bash

```shell
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/wezterm 50
sudo update-alternatives --config x-terminal-emulator # 执行后选 WezTerm 对应的数字
```

### 2. 快捷键重映射 (Ctrl + Alt + T)

- **Settings** -> **Keyboard** -> **View and Customise Shortcuts**。
- **Custom Shortcuts** -> **Add**：
  - **Name:** `WezTerm`
  - **Command:** `wezterm`
  - **Shortcut:** 按下 `Ctrl + Alt + T`。

### 补丁：Git 效率与云端同步 (Post-Install)
1. **身份与别名**：一键注入常用缩写（gs, ga, gc, gp, gl）。
2. **安全隧道**：生成 Ed25519 密钥并关联 GitHub，实现免密 Push。
3. **环境存档**：将 `.zshrc` 和 `.wezterm.lua` 存入 `~/MyConfig` 仓库。

------

## 🧠 408 核心知识点回顾 (考研必看)

| **阶段**       | **涉及 408 知识点**      | **极客理解**                                             |
| -------------- | ------------------------ | -------------------------------------------------------- |
| **Shell 增强** | 进程上下文 (Context)     | `.zshrc` 定义了进程启动时的环境变量环境。                |
| **UI 美化**    | 图形输出子系统           | 了解窗口管理器如何通过 CSS 控制渲染层。                  |
| **WezTerm**    | 显存与硬件加速           | 利用 GPU 处理复杂的字形变换（连体字）。                  |
| **默认设置**   | 符号链接 (Symbolic Link) | `update-alternatives` 本质是修改 `/etc` 下的软链接指向。 |

------

### 🏁 收尾工作：快照！

请立即在虚拟机菜单中：**快照 -> 拍摄快照 -> 命名为“2026极客完美环境”**。

**现在，开启你的连体字写码之旅吧！**