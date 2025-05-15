#Requires AutoHotkey v2.0

#Include "%A_ScriptDir%\PluginList.ahk"  ; プラグインをインクルード

; RButton::MouseClick "left"


GetGPS() {
    pwshCmd := "
    (
        Add-Type -TypeDefinition @'
        using System;
        using System.Device.Location;
        public class GPS
        {
            public static string GetLocation()
            {
                var watcher = new GeoCoordinateWatcher();
                watcher.TryStart(false, TimeSpan.FromMilliseconds(1000));
                var coord = watcher.Position.Location;
                return coord.IsUnknown ? 'Unknown' : coord.Latitude + ',' + coord.Longitude;
            }
        }
        '@ -Language CSharp
    
        [GPS]::GetLocation()
    )"

    gpsData := RunWaitOne("powershell", "-Command " pwshCmd)
    return gpsData
}

RunWaitOne(program, params) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(program " " params)
    return exec.StdOut.ReadAll()
}

MsgBox(GetGPS())
