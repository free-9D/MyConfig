# Neovim (LazyVim) C++ 开发环境踩坑总结

## 1. 核心问题现象

在虚拟机（Ubuntu）中使用 LazyVim 时，出现以下症状：

- **Mason 报错**：无法下载 `mason-registry` 或 `clangd` 压缩包（GitHub 连接失败）。
- **死循环下载**：每次打开 `.cpp` 文件，Mason 都会强行尝试下载 `clangd`，导致编辑器卡顿并弹出报错窗口。
- **功能失效**：代码没有红线报错（LSP 诊断），没有语法提示。
- **命令缺失**：输入 `:LspInfo` 或 `:LspStart` 提示命令不存在。

------

## 2. 坑点排查与原因分析

### 坑点 A：网络环境与 Mason 的冲突

- **原因**：Mason 默认从 GitHub 下载插件的二进制包。在网络受限环境下，这一步必失败。
- **误区**：以为 Mason 是唯一的安装途径。
- **解法**：转而使用系统包管理器（`apt`）安装“大脑”：`sudo apt install clangd`。

### 坑点 B：LazyVim 的“热心肠”自动化 (Extra)

- **原因**：开启 `lang.clangd` 扩展后，LazyVim 会自动把 `clangd` 加入 Mason 的 `ensure_installed` 名单。
- **残留**：即使在 `:LazyExtras` 界面取消了勾选，如果 Mason 的缓存或 `lspconfig` 的配置还在，它依然会因为检测到“需求”而触发下载。

### 坑点 C：LSP 命令“失踪”

- **原因**：LazyVim 使用 **延迟加载**。只有打开对应的文件（如 `.cpp`），`nvim-lspconfig` 才会启动。如果 `clangd` 启动失败（崩溃），相关的命令（如 `:LspInfo`）可能无法成功注册。

### 坑点 D：错误的启动参数导致崩溃

- **原因**：在 `lspconfig` 的 `cmd` 参数中错误地加入了 `--std=c++14`。
- **本质**：`clangd` 的 **命令行参数**（控制服务器行为）与 **编译参数**（控制语言标准）是两码事。`clangd` 不认识命令行里的 `--std` 参数，导致启动即崩溃。

------

## 3. 最终解决方案 (Manual Override)

### 第一步：系统层安装驱动

避开 Mason 的下载任务，直接利用 Linux 系统镜像源安装：

Bash

```shell
sudo apt update && sudo apt install clangd
```

### 第二步：编写“硬拦截”配置文件

在 `~/.config/nvim/lua/plugins/cpp.lua` 中写入以下逻辑，强行拔掉 Mason 的电源并指向系统自带的 `clangd`：

Lua

```lua
return {
  -- 1. 修正仓库名，并拦截自动安装
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- 显式检查并过滤掉 clangd，防止它进入 ensure_installed 队列
      if opts.ensure_installed then
        local new_list = {}
        for _, v in ipairs(opts.ensure_installed) do
          if v ~= "clangd" then
            table.insert(new_list, v)
          end
        end
        opts.ensure_installed = new_list
      end
    end,
  },

  -- 2. 直接配置 LSP，不再依赖 Mason 的管理
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 这里的配置会覆盖所有默认行为
        clangd = {
          -- 确保这里调用的是你 sudo apt install 的系统命令
          cmd = { "clangd", "--background-index" },
          -- 告诉 LazyVim：这个服务器我已经手动搞定了，你别管了
          mason = false,
        },
      },
    },
  },
}
```

### 第三步：配置项目语言标准

在你的项目文件夹（代码所在目录）创建 `.clangd` 文件，告诉“大脑”使用 C++14：

YAML

```lua
# .clangd
CompileFlags:
  Add: [-std=c++14]
```

------

## 4. 经验教训总结

1. **LSP $\neq$ Mason**：LSP 是协议，Mason 只是一个方便的下载器。Mason 坏了，手动装好二进制文件一样能跑。
2. **配置冲突优先查看日志**：命令 `:messages` 或日志文件 `~/.local/state/nvim/lsp.log` 能告诉你 `clangd` 退出码的真实原因。
3. **理解 Lazy 加载逻辑**：没有命令时，先开一个对应的代码文件触发插件。
4. **参数分离**：LSP 的 `cmd` 里写服务器参数，项目配置（`.clangd`）里写代码编译参数。

------

**现在的你，已经拥有了一个稳定、不依赖 GitHub 网络、且完美适配 C++14 的高效开发环境！加油！**