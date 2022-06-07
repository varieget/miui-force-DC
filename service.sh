#!/system/bin/sh
MODDIR=${0%/*}

DC_BACK_LIGHT=$(settings list system | grep dc_back_light)
set_dc_backlight() {
  if [[ $DC_BACK_LIGHT == *"dc_back_light=1"* ]]; then
    resetprop 'persist.vendor.dc_backlight.enable' 'true'
    input keyevent 26
  fi

  exit 0
}

{
  # wait for boot completed
  while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
  done

  set_dc_backlight
} &
