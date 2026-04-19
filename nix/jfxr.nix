{ src, mkYarnPackage }:
mkYarnPackage {
  name = "jfxr";
  src = "${src}/lib";
  buildPhase = ''
    cp "${src}/.eslintrc.js" .
    yarn --offline build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist $out/dist
  '';
}
