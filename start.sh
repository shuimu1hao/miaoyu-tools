#!/data/data/com.termux/files/usr/bin/bash
# 摸鱼工具箱一键启动：本地 http 服务 + 手机浏览器打开
cd "$(dirname "$0")"
PORT=8380
# 已在跑就直接打开
if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/" 2>/dev/null | grep -q 200; then
  echo "服务已在运行 http://localhost:$PORT/"
  termux-open-url "http://localhost:$PORT/"
  exit 0
fi
python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
sleep 1
termux-open-url "http://localhost:$PORT/"
echo "摸鱼工具箱已启动 http://localhost:$PORT/ （Ctrl+C 关闭）"
