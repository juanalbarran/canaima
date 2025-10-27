#!/usr/bin/env bash
case "$(cat /tmp/kanshi-profile 2>/dev/null)" in
  dual-monitor) echo "💻 + 🖥️ Dual";;
  docked-clamshell) echo "🧳 Docked";;
  laptop-only) echo "💻 Laptop";;
  *) echo "❓";;
esac
