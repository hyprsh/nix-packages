{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  python311,
  snapraid,
  snapraid-btrfs,
  snapper,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "snapraid-btrfs-runner";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fmoledina";
    repo = "snapraid-btrfs-runner";
    rev = "afb83c67c61fdf3769aab95dba6385184066e119";
    sha256 = "M8LXxsc7jEn5GsiXAKykmFUgsij2aOIenw1Dx+/5Rww=";
  };

  nativeBuildInputs = [makeWrapper];
  buildInputs = [python311 snapraid snapraid-btrfs snapper];

  config = writeText "snapraid-btrfs-runner.conf" ''
    [snapraid-btrfs]
    executable = ${snapraid-btrfs}/bin/snapraid-btrfs
    cleanup = true

    [snapper]
    executable = ${snapper}/bin/snapper

    [snapraid]
    executable = ${snapraid}/bin/snapraid
    config = /etc/snapraid.conf
    deletethreshold = 40

    [logging]
    maxsize = 5000

    [email]
    sendon = success,error
    short = true
    maxsize = 500

    [scrub]
    enabled = false
    plan = 12
    older-than = 10
  '';

  installPhase = ''
    install -Dm755 ${src}/snapraid-btrfs-runner.py $out/bin/${pname}
    sed -i '1s|^|#!/usr/bin/env python3\n|' $out/bin/${pname}
    wrapProgram $out/bin/${pname} \
      --set PATH ${lib.makeBinPath [python311 snapraid snapraid-btrfs snapper]} \
      --add-flags "-c ${config}"
    install -Dm644 ${config} $out/etc/${pname}.conf
  '';

  meta = with lib; {
    description = "Runner script for SnapRAID and btrfs integration";
    homepage = "https://github.com/fmoledina/snapraid-btrfs-runner";
    license = licenses.mit;
    maintainers = [maintainers.nd];
    platforms = platforms.all;
  };
}
