{ pkgs, inputs, ... }: let 
  sway = "${inputs.sway.packages.x86_64-linux.sway}/bin/sway";
  starship = "${inputs.starship.packages.x86_64-linux.starship}/bin/starship";
in ''
  if status is-login
    if [ (hostname) = "anne-laptop" ]
      ${sway}
    end
  end

  if status is-interactive
    ${starship} init fish | source
  end
''
