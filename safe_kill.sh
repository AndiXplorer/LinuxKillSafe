#!/bin/bash

PROTECTED_PROCESSES=("systemd" "gnome-shell" "Xorg" "init")

is_protected() {
    local proc_name="$1"
    for protected in "${PROTECTED_PROCESSES[@]}"; do
        if [[ "$proc_name" == "$protected" ]]; then
            return 0
        fi
    done
    return 1
}

show_processes() {
    echo "Running processes:"
    ps -eo pid,comm --sort=-%mem | head -15
}

if [[ -z "$1" ]]; then
    show_processes
    echo -e "\nUsage: safe_kill <PID|Process Name> [-f] [-d]"
    echo "  -f   Force kill (SIGKILL -9)"
    echo "  -d   Dry run (Show what would be killed)"
    exit 1
fi

FORCE_KILL=0
DRY_RUN=0
TARGET=""

for arg in "$@"; do
    case $arg in
        -f) FORCE_KILL=1 ;;
        -d) DRY_RUN=1 ;;
        *) TARGET="$arg" ;;
    esac
done

if [[ ! "$TARGET" =~ ^[0-9]+$ ]]; then
    PID=$(pgrep -o "$TARGET")
    if [[ -z "$PID" ]]; then
        echo "No running process found with name: $TARGET"
        exit 1
    fi
else
    PID="$TARGET"
fi

PROCESS_NAME=$(ps -p "$PID" -o comm=)

if is_protected "$PROCESS_NAME"; then
    echo "⚠️  Protected process '$PROCESS_NAME' (PID: $PID) cannot be killed!"
    exit 1
fi

echo "🔍 Found Process: $PROCESS_NAME (PID: $PID)"
echo "Are you sure you want to kill this process? (y/N)"
read -r choice

if [[ "$choice" != "y" ]]; then
    echo "❌ Kill aborted."
    exit 0
fi

if [[ $DRY_RUN -eq 1 ]]; then
    echo "🔍 Dry Run: Would have killed $PROCESS_NAME (PID: $PID)."
    exit 0
fi

if [[ $FORCE_KILL -eq 1 ]]; then
    echo "🔥 Forcing kill (SIGKILL) on $PROCESS_NAME (PID: $PID)..."
    kill -9 "$PID"
else
    echo "🔪 Killing $PROCESS_NAME (PID: $PID)..."
    kill "$PID"
fi

echo "✅ Process $PROCESS_NAME (PID: $PID) terminated."
