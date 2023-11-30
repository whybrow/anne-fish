{
  description = "Fish shell configured for Anne";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sway.url = "github:whybrow/anne-sway";
    starship.url = "github:marcuswhybrow/starship";
  };

  outputs = inputs: let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    configText = import ./config.nix { inherit pkgs inputs; };
    config = pkgs.writeTextDir "share/fish/vendor_conf.d/config.fish" configText;
    functions = {};
    mkFunctionPkg = name: def: (pkgs.writeTextDir "share/fish/vendor_functions.d/${name}.fish" ''
      function ${name}
        ${def}
      end
    '');
    functionPkgs = pkgs.lib.mapAttrsToList mkFunctionPkg functions;
  in {
    packages.x86_64-linux.fish = pkgs.symlinkJoin {
      name = "fish";
      paths = [ pkgs.fish config ] ++ functionPkgs;
    };
    packages.x86_64-linux.default = inputs.self.packages.x86_64-linux.fish;
  };
}
