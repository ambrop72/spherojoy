with import <nixpkgs> {};
let
    badvpnSource = fetchgit {
        url = https://github.com/ambrop72/badvpn;
        rev = "1be45b445dad198e7ca0314ec2cd6259318d33f3";
        sha256 = "07j21lmnx75kpxy0k66vh9ny7fmaip943kqlqrf54bj1ggwib923";
    };
    badvpnFunc = import (builtins.toPath ((toString badvpnSource) + "/badvpn.nix"));
    badvpn = pkgs.callPackage badvpnFunc {};
in
rec {
    spherojoy = pkgs.callPackage ./spherojoy.nix { inherit badvpn; };
}
