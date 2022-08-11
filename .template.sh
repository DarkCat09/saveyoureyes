while true; do
    sleep $SYE_TIME
    ps -e | grep -E "$SYE_EXCL" >/dev/null
    if [[ $SYE_EXCL == "" || $? == 1 ]]; then
        nohup bash -c "$SYE_CMD" >/dev/null
    fi
done
