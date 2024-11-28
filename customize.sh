AUTOMOUNT=true

install_files() {
    
    local plugin_package="miui.systemui.plugin"
    local plugin_path
    local plugin_folder
    local plugin_name
    local milink_package="com.milink.service"
    local milink_path
    local milink_folder
    local milink_name
    
    pm uninstall-system-updates "$plugin_package"
    plugin_path=$(pm path "$plugin_package" | sed 's/package://')
    pm uninstall-system-updates "$milink_package"
    plugin_path=$(pm path "$milink_package" | sed 's/package://')
    
    plugin_folder=$(dirname "$plugin_path" | sed 's/system//')
    plugin_name=$(basename "$plugin_path" | sed 's/.apk//') 
    milink_folder=$(dirname "$milink_path" | sed 's/system//')
    milink_name=$(basename "$milink_path" | sed 's/.apk//')
    
    mv "$MODPATH/files/plugin/HyperOSPluginMod.apk" "$MODPATH/files/plugin/$plugin_name.apk"
    
    mkdir -p "$MODPATH/system$plugin_folder"
    cp -f "$MODPATH/files/plugin/$plugin_name.apk" "$MODPATH/system$plugin_folder"
    
    
    mv "$MODPATH/files/milink/MiLinkService.apk" "$MODPATH/files/milink/$milink_name"
    
    mkdir -p "$MODPATH/system$milink_folder"
    cp -f "$MODPATH/files/milink/$milink_name" "$MODPATH/system$milink_folder"

}

set_permissions() {
    set_perm_recursive "$MODPATH" 0 0 0755 0644
}

cleanup() {
    rm -rf "$MODPATH/files" 2>/dev/null
    rm -rf "/data/resource-cache/*"
    rm -rf "/data/system/package_cache/*"
    rm -rf "/cache/*"
    rm -rf "/data/dalvik-cache/*"
    touch "$MODPATH/pluginmod/remove"
}

run_install() {
    unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
    install_files
    ui_print ""
    ui_print "- Setting permissions"
    set_permissions
    ui_print ""
    ui_print "- Cleaning up"
    ui_print ""
    cleanup
}

run_install
