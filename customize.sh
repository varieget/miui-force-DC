SKIPUNZIP=1

# extract <zip> <file> <target dir>
extract() {
  zip=$1
  file=$2
  dir=$3

  unzip -o "$zip" "$file" -d "$dir" >&2
  [ -f "$dir/$file" ] || abort "$file not exists"

  ui_print "- Extracting $file" >&1
}

install_from_magisk_app() {
  if $BOOTMODE; then
    ui_print "**********************************"
    ui_print "  强制 MIUI 设置出现“防闪烁模式”选项"
    ui_print ""
    ui_print "- 选择“防闪烁模式”后，能否正常启用"
    ui_print "  取决于硬件是否支持"
    ui_print ""
    ui_print "- 同时启用高刷，会导致屏幕在低亮度的"
    ui_print "  情况下表现变差"
    ui_print "**********************************"
  else
    ui_print "**********************************"
    ui_print "  Please install from Magisk app"
    abort "**********************************"
  fi
}

VERSION=$(grep_prop version "${TMPDIR}/module.prop")
ui_print "- MIUI 强制开启 DC 调光"
ui_print "- version ${VERSION}"

install_from_magisk_app

extract "$ZIPFILE" 'module.prop' "$MODPATH"
extract "$ZIPFILE" 'service.sh' "$MODPATH"

mkdir -p $MODPATH/system/product/etc/device_features
cp -rf /product/etc/device_features/* $MODPATH/system/product/etc/device_features

for FILE in $(ls $MODPATH/system/product/etc/device_features/*); do
  ui_print "- Modifying ${FILE}"
  sed -i 's/\"support_dc_backlight\">false<\/bool>/\"support_dc_backlight\">true<\/bool>/g' $FILE
  sed -i 's/\"support_secret_dc_backlight\">true<\/bool>/\"support_secret_dc_backlight\">false<\/bool>/g' $FILE
done

set_perm_recursive "$MODPATH" 0 0 0755 0644
