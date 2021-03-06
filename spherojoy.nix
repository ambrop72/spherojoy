{ stdenv, writeScriptBin, coreutils, python27, bash, badvpn, systemd }:
let
    spherojoySource = stdenv.lib.cleanSource ./.;
    
    fixedSource = stdenv.mkDerivation {
        name = "spherojoy-fixed-source";
        
        src = spherojoySource;
        
        installPhase = ''
            substituteInPlace main.ncd \
                --replace /STTY/ "${coreutils}/bin/stty" \
                --replace /PYTHON27/ "${python27}/bin/python" \
                --replace /SOURCE_DIR/ "$out"
            mkdir -p "$out"
            cp -r ./* "$out"/
        '';
    };

in
writeScriptBin "spherojoy" ''
    #!${bash}/bin/bash
    # Need udevadm in path.
    export PATH=${systemd}/bin:$PATH
    exec ${badvpn}/bin/badvpn-ncd --loglevel notice "${fixedSource}/main.ncd" "$@"
''
