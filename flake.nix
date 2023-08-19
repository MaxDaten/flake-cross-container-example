{
  description = "A very basic flake cross compiling hello container";

  outputs = {
    self,
    nixpkgs,
  }: let
    lib = nixpkgs.lib;

    darwin = ["x86_64-darwin" "aarch64-darwin"];
    linux = ["x86_64-linux" "aarch64-linux"];

    allSystems = darwin ++ linux;
    forEachSystem = systems: f: lib.genAttrs systems (system: f system);
    forAllSystems = forEachSystem allSystems;

    helloContainer = {pkgs, ...}:
      pkgs.dockerTools.buildLayeredImage {
        name = "hello";
        tag = "latest";
        contents = [
          pkgs.coreutils
          pkgs.hello
        ];

        # test if extra commands can be executed
        extraCommands = ''
          echo "hello" > hello.txt
          chmod 777 hello.txt
        '';
      };
  in {
    packages = forAllSystems (
      system: let
        linuxContainer =
          forEachSystem linux
          (
            targetSystem:
              helloContainer {
                pkgs = import nixpkgs {
                  localSystem = system;
                  crossSystem = targetSystem;
                };
              }
          );
      in
        lib.mapAttrs' (system: drv: lib.nameValuePair "${drv.imageName}-${system}" drv) linuxContainer
    );
  };
}
