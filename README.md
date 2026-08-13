# miaoyu-tools — 喵语工具集（摸鱼工具箱）

网页版摸鱼小工具集合（纯前端，无需服务端）：番茄钟、2048 小游戏、摸鱼语录。

## 环境声明（Environment）

本项目在 **MIUI 系统 + 小米 10 手机 + Termux（Android）** 环境下开发与验证。
如果你在本地部署失败，可能与本地系统环境（系统版本、Android 权限、Termux 配置等）有关，而非项目本身的问题。
此时可以让你的 AI Agent 查阅 **Android 官方文档**、**Termux 官方文档** 以及 **你所用系统的官方文档** 来排查解决。

## 运行

```bash
bash miaoyu.sh start [端口]   # 启动（默认 8380）并自动打开浏览器
bash miaoyu.sh stop           # 关闭
bash miaoyu.sh status         # 查看运行状态
bash miaoyu.sh                # 显示帮助
```

或直接打开 `index.html`（所有功能纯前端，无需服务端也能用）。

## 功能

- 🍅 番茄钟：专注倒计时，摸鱼也要讲效率
- 🎮 2048：经典数字合并小游戏
- 💬 语录：随机摸鱼语录，累了就歇会儿

## 目录结构

```
miaoyu-tools/
├── index.html    # 前端页面（全部工具）
├── miaoyu.sh     # 启动 / 停止 / 状态控制脚本
└── LICENSE       # MIT 协议
```

## 协议

MIT License（见 LICENSE）

## 开发环境

- 设备：小米手机（MIUI / Android 13）
- 环境：Termux（Android 终端）+ termux-x11 + XFCE 图形桌面
- 语言：Go / Python 为主，纯 CLI 开发
- 注意：本项目在 Android / Termux 上开发与测试，其他平台运行可能需要调整

## 生成声明

本项目全部代码与文档由 AI 生成（Hermes Agent + DeepSeek 模型），不含一丝人类手写代码。仅供学习交流。
