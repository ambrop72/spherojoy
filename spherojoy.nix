{ stdenv, writeText, writeScriptBin, coreutils, python27, bash, badvpn }:
let
    spherojoySource = stdenv.lib.cleanSource ./.;
    
    mainNcdScript = writeText "spherojoy.ncd" ''
        include "${spherojoySource}/spheroncd.ncdi"
        
        process main {
            If (@true) {
                var("/dev/input/by-id/usb-Logitech_Logitech_Extreme_3D-event-joystick") joy_dev;
                value(["X": "0",    "Y": "0",    "RZ": "0",   "THROTTLE": "255"]) joy_axis_min;
                value(["X": "1023", "Y": "1023", "RZ": "255", "THROTTLE": "0"  ]) joy_axis_max;
                var("60") rz_degrees;
                var("/dev/rfcomm0") sphero_dev;
                var("5") max_sendq_len;
                var("20") max_roll_interval;
                var(@false) print_joy_events;
            } config;
            
            var("${coreutils}/bin/stty") stty;
            var("${python27}/bin/python") python;
            
            call(@_spheroncd, {^config, stty, python});
        }
    '';

in
writeScriptBin "spherojoy" ''
    #!${bash}/bin/bash
    exec ${badvpn}/bin/badvpn-ncd --loglevel notice ${mainNcdScript} "$@"
''
