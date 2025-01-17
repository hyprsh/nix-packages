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
    owner = "D34DC3N73R";
    repo = "snapraid-btrfs";
    rev = "8cdbf54100c2b630ee9fcea11b14f58a894b4bf3";
    sha256 = "IQgL55SMwViOnl3R8rQ9oGsanpFOy4esENKTwl8qsgo=";
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
