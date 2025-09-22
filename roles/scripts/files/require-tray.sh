#!/bin/sh
while ! busctl --user list | grep -q "org.kde.StatusNotifierWatcher"; do
    sleep 0.5
done
exec "$@"

