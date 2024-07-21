{
  description = "Nand2Tetris Tools as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nand2tetris-tools-zip = {
      url = "file+https://drive.google.com/uc?export=download&id=1xZzcMIUETv3u3sdpM_oTJSTetpVee3KZ";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-utils,
    nand2tetris-tools-zip,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in rec {
        packages = rec {
          nand2tetristools-unwrapped = pkgs.stdenv.mkDerivation {
            name = "nand2tetristools-unwrapped";

            unpackPhase = ''
              ${pkgs.unzip}/bin/unzip ${nand2tetris-tools-zip}
            '';

            installPhase = ''
              cd nand2tetris/tools
              rm -r *.bat

              mkdir -p $out/bin
              
              cp -r ./* $out/bin
              chmod +x $out/bin/*.sh
            '';
          };
          
          nand2tetristools = pkgs.symlinkJoin {
            name = "nand2tetristools";
            paths = [
              nand2tetristools-unwrapped
              pkgs.openjdk
            ];
            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/HardwareSimulator.sh --prefix PATH : $out/lib/openjdk/bin 
              wrapProgram $out/bin/CPUEmulator.sh --prefix PATH : $out/lib/openjdk/bin 
              wrapProgram $out/bin/Assembler.sh --prefix PATH : $out/lib/openjdk/bin 
              wrapProgram $out/bin/VMEmulator.sh --prefix PATH : $out/lib/openjdk/bin 
              wrapProgram $out/bin/JackCompiler.sh --prefix PATH : $out/lib/openjdk/bin 
            '';
          };

          default = nand2tetristools;
        };

        apps = {
          hardwaresimulator = flake-utils.lib.mkApp {
            drv = packages.default;
            exePath = "/bin/HardwareSimulator.sh";
          };

          cpusimulator = flake-utils.lib.mkApp {
            drv = packages.default;
            exePath = "/bin/CPUEmulator.sh";
          };

          assembler = flake-utils.lib.mkApp {
            drv = packages.default;
            exePath = "/bin/Assembler.sh";
          };

          vmemulator = flake-utils.lib.mkApp {
            drv = packages.default;
            exePath = "/bin/VMEmulator.sh";
          };

          jackcompiler = flake-utils.lib.mkApp {
            drv = packages.default;
            exePath = "/bin/JackCompiler.sh";
          };
        };
      }
    );
}
