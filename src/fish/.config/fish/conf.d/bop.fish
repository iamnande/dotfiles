function bop
    # xm6, where are you? oh xm6, i hope i find you..
    set paired_homies (bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)

    # we got juice?
    bluetoothctl show | grep -q "Powered: no"
    set cruizin_the_juice $status

    if test $cruizin_the_juice -eq 0
        echo "turning ON the blue juice..."
        bluetoothctl power on >/dev/null

        # wait until the juice is flowing, for like 30 seconds
        set latency_sec 30
        set interval_sec 0.2
        set current_latency 0
        set max_iterations (math $latency_sec / $interval_sec)

        while not bluetoothctl show | grep -q "Powered: yes"
            and test $current_latency -lt $max_iterations
            sleep $interval_sec
            set current_latency (math $current_latency + 1)
        end

        # we got juice, go get the homie
        for homie in $paired_homies
            echo "connecting to our good homie, $homie"
            bluetoothctl connect $homie >/dev/null
        end
    else
        for homie in $paired_homies
            echo "disconnecting from our good homie, $homie"
            bluetoothctl disconnect $homie >/dev/null
        end
        echo "turning OFF the blue juice..."
        bluetoothctl power off >/dev/null
    end
end
