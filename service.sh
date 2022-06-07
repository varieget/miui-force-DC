#!/system/bin/sh
MODDIR=${0%/*}

set_dc_backlight() {
  DC_BACK_LIGHT=$(settings list system | grep dc_back_light)

  if [[ $DC_BACK_LIGHT == *"dc_back_light=1"* ]]; then
    resetprop 'persist.vendor.dc_backlight.enable' 'true'
    input keyevent 26
  fi

  exit 0
}

{
  # wait for bootanim stopped
  while [ "$(getprop init.svc.bootanim)" != "stopped" ]; do
    sleep 1
  done

  set_dc_backlight
} &
