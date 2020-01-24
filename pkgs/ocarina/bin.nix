{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC
, lib ? (import <nixpkgs> {}).lib
, fetchurl ? (import <nixpkgs> {}).fetchurl
}:

let
  platform = if stdenvNoCC.hostPlatform.isLinux then "linux" else "darwin";

in stdenvNoCC.mkDerivation rec {
  name = "ocarina-bin-${version}";

  version = "2017.1";

  src = fetchurl {
    url = "https://github.com/OpenAADL/ocarina/releases/download/v2017.1/" +
          "ocarina-2017.1-suite-${platform}-x86_64-20170204.tgz";
    sha256 = "0kznps0qjfjsbaqr6ap797y85dljpj632kanyjxk114irbysqglz";
  };

  installPhase = ''
    mkdir $out
    for d in bin include lib share; do
      cp -r $d $out
    done
  '';

  meta = with lib; {
    description = "AADL model processor: mappings to code (C, Ada); Petri Nets; " +
      "scheduling tools (MAST, Cheddar); WCET; REAL http://www.openaadl.org";
    homepage = "https://openaadl.com";
    license = licenses.gpl3;
    maintainers = [ maintainers.protoben ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
