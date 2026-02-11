{
  description = "Nixos config flake";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    #hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
      # use "nixos", or your hostname as the name of the configuration
      # it's a better practice than "default" shown in the video
      nixosConfigurations = {
        bakery = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/bakery/configuration.nix
          ];
        };
        kitchen = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/kitchen/configuration.nix
          ];
        };
      };
  };
}
