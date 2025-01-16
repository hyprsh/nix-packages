{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  coreutils,
  gnugrep,
  gawk,
  gnused,
  snapraid,
  snapper,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "snapraid-btrfs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "automorphism88";
    repo = "snapraid-btrfs";
    rev = "6492a45ad55c389c0301075dcc8bc8784ef3e274";
    sha256 = "1xd2wqvp0dnsys6wc8ambisgmp0l3bw04pk49nivr3vvbj70myb0";
  };

  nativeBuildInputs = [makeWrapper];
  buildInputs = [coreutils gnugrep gawk gnused snapraid snapper];

  installPhase = ''
    install -Dm755 ${src}/snapraid-btrfs $out/bin/${pname}
    patchShebangs $out/bin/${pname}
    wrapProgram $out/bin/${pname} \
      --set PATH ${lib.makeBinPath [coreutils gnugrep gawk gnused snapraid snapper]}
  '';

  meta = with lib; {
    description = "Wrapper script for integrating SnapRAID and Btrfs";
    homepage = "https://github.com/automorphism88/snapraid-btrfs";
    license = licenses.mit;
    maintainers = [maintainers.nd];
    platforms = platforms.all;
  };
}
