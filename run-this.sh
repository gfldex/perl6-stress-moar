#! /bin/sh

trap '{ echo "moar-stress-main.p6 pid was: $MOAR_STRESS_MAIN_PID"; exit 255; }' INT

perl6 bin/moar-stress-main.p6 &
MOAR_STRESS_MAIN_PID=$!

wait $MOAR_STRESS_MAIN_PID

