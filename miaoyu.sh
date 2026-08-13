#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# 🐟 摸鱼工具箱 控制脚本
# 用法:
#   bash miaoyu.sh start [端口]  启动（默认 8380）并打开浏览器
#   bash miaoyu.sh stop          关闭
#   bash miaoyu.sh status        查看运行状态
#   bash miaoyu.sh               显示帮助
# ============================================
export HOME=/data/data/com.termux/files/home

DIR="$HOME/hermes11/miaoyu-tools"
PIDFILE="$DIR/.server.pid"
LOG="$DIR/.server.log"
DEFAULT_PORT=8380

cd "$DIR" || { echo "❌ 目录不存在: $DIR"; exit 1; }

usage() {
  echo "🐟 摸鱼工具箱 控制脚本"
  echo "用法:"
  echo "  bash miaoyu.sh start [端口]  启动（默认 $DEFAULT_PORT）并打开浏览器"
  echo "  bash miaoyu.sh stop          关闭"
  echo "  bash miaoyu.sh status        查看运行状态"
}

is_running() {
  [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null
}

cmd_start() {
  PORT="${1:-$DEFAULT_PORT}"
  if is_running; then
    echo "✅ 摸鱼工具箱已经在运行 (PID $(cat "$PIDFILE"), 端口 $PORT)"
    termux-open-url "http://localhost:$PORT/" 2>/dev/null
    exit 0
  fi
  if ss -tln 2>/dev/null | grep -q ":$PORT "; then
    echo "⚠️  端口 $PORT 被占用，换端口试试: bash miaoyu.sh start 8381"
    exit 1
  fi
  nohup python3 -m http.server "$PORT" --bind 127.0.0.1 > "$LOG" 2>&1 &
  echo $! > "$PIDFILE"
  sleep 1
  if is_running; then
    echo "✅ 摸鱼工具箱已启动 (PID $(cat "$PIDFILE"), 端口 $PORT)"
    echo "   地址: http://localhost:$PORT/"
    echo "   关闭: bash miaoyu.sh stop"
    termux-open-url "http://localhost:$PORT/" 2>/dev/null
  else
    echo "❌ 启动失败，日志:"
    cat "$LOG"
    rm -f "$PIDFILE"
    exit 1
  fi
}

cmd_stop() {
  if is_running; then
    PID=$(cat "$PIDFILE")
    kill "$PID" 2>/dev/null
    sleep 1
    kill -0 "$PID" 2>/dev/null && kill -9 "$PID" 2>/dev/null
    rm -f "$PIDFILE"
    echo "✅ 已停止摸鱼工具箱 (PID $PID)"
  else
    # 兜底：按端口找进程
    PID=$(ss -tlnp 2>/dev/null | grep ":$DEFAULT_PORT " | grep -oE 'pid=[0-9]+' | head -1 | cut -d= -f2)
    if [ -n "$PID" ]; then
      kill "$PID" 2>/dev/null
      rm -f "$PIDFILE"
      echo "✅ 已停止摸鱼工具箱 (PID $PID, 端口 $DEFAULT_PORT)"
    else
      rm -f "$PIDFILE"
      echo "ℹ️  摸鱼工具箱本来就没在运行"
    fi
  fi
}

cmd_status() {
  if is_running; then
    PORT=$(ss -tln 2>/dev/null | grep -oE ':[0-9]+ ' | tr -d ': ' | grep -E '^[0-9]+$' | grep -v '^0$' | head -1)
    echo "🟢 运行中 (PID $(cat "$PIDFILE"))"
    echo "   地址: http://localhost:8380/"
    curl -s -o /dev/null -w "   状态: HTTP %{http_code}\n" http://localhost:8380/ 2>/dev/null
  else
    echo "⚪ 未运行"
  fi
}

case "${1:-help}" in
  start)   shift; cmd_start "$@" ;;
  stop)    cmd_stop ;;
  status)  cmd_status ;;
  help|-h|*) usage ;;
esac
