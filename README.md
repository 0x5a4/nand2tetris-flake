# nand2tetris-flake

_visit [https://www.nand2tetris.org]()!_

Annoyed that the nand2tetris tools dont work with nix out of the box?  
Here have this flake (and a cookie 🍪)

# Use as a flake
 
[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/0x5a4/nand2tetris-flake/badge)](https://flakehub.com/flake/0x5a4/nand2tetris-flake)
 
Add `nand2tetris` to your `flake.nix`:
 
```nix
{
  inputs.nand2tetris.url = "github:0x5a4/nand2tetris-flake";
 
  outputs = { self, nand2tetris }: {
    # Use in your outputs
  };
}
```

## Outputs
- `packages.nand2tetristools` - nand2tetris tools wrapped to work with nix
- `apps.hardwaresimulator` - executable name is `/bin/HardwareSimulator.sh`
- `apps.cpusimulator` - executable name is `/bin/CPUEmulator.sh`
- `apps.assembler` - executable name is `/bin/Assembler.sh`
- `apps.vmemulator` - executable name is `/bin/VMEmulator.sh`
- `apps.jackcompiler` - executable name is `/bin/JackCompiler.sh`
