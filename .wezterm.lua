local wezterm = require 'wezterm'
local config = {}

-- 字体与大小
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 13.0

-- 透明度与模糊 (这是新版正确的写法)
config.window_background_opacity = 0.85
-- 在 Linux 下，模糊通常需要合成管理器支持，这行可以确保背景模糊开启
config.macos_window_background_blur = 20 -- 虽然名字带 macos，但在某些 Linux 环境下也起作用

-- 窗口修饰：去掉顶栏，保持极简
config.window_decorations = "RESIZE"

-- 配色方案
config.color_scheme = 'Catppuccin Mocha'

-- 连体字支持
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

return config
