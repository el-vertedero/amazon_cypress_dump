#!/system/bin/sh

idme_device_type_id=`/system/bin/cat /proc/idme/device_type_id`
echo "audio_sys_init: device_type_id: $idme_device_type_id" > /dev/kmsg
#Cypress
case "$idme_device_type_id" in
    "AQ24620N8QD5Q" )
        /system/bin/setprop sys.audio.bootanim "running"
        # Audio pts adjust for AV sync fine tuning in non tunnel mode in Cypress Proxy HAL
        /system/bin/setprop apts_tune.non_tunnel_pcm -20
        ;;
    *)
        echo "audio_sys_init: unknown device_type_id - $idme_device_type_id" > /dev/kmsg
        ;;
esac

