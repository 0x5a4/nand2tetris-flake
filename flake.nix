{
  description = "Nand2Tetris Tools as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in rec {
        packages = rec {
          nand2tetristools-unwrapped = pkgs.stdenv.mkDerivation {
            name = "nand2tetristools";
            src = builtins.fetchTarball {
              url = "https://drive.google.com/uc?export=download&id=1xZzcMIUETv3u3sdpM_oTJSTetpVee3KZ";
              sha256 = "sha256:0n31p1kn4by3wmf1wqf40q7wnywxr8b1nxi49y9d08nniiricc3s";
            };

            outputs = ["out" "doc"];

            installPhase = ''
              cd tools
              rm -r *.bat

              mkdir -p $out/bin
              mv bin/help $doc
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
        };

        defaultPackage = packages.nand2tetristools;

        apps = {
          hardwaresimulator = flake-utils.lib.mkApp {
            drv = defaultPackage;
            exePath = "/bin/HardwareSimulator.sh";
          };

          cpusimulator = flake-utils.lib.mkApp {
            drv = defaultPackage;
            exePath = "/bin/CPUEmulator.sh";
          };

          assembler = flake-utils.lib.mkApp {
            drv = defaultPackage;
            exePath = "/bin/Assembler.sh";
          };

          vmemulator = flake-utils.lib.mkApp {
            drv = defaultPackage;
            exePath = "/bin/VMEmulator.sh";
          };

          jackcompiler = flake-utils.lib.mkApp {
            drv = defaultPackage;
            exePath = "/bin/JackCompiler.sh";
          };
        };
      }
    );
}
