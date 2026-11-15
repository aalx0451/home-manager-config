{
  description = "aalx0451 Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yukigram.url = "github:yukigram/yukigram/release";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      homeConfigurations."lina" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./dconf.nix
          ./dircolors.nix
          ./git.nix
          ./git-credential-keepassxc.nix
          ./gtk.nix
          ./home.nix
          ./kitty.nix
          ./pkgs.nix
          ./programs.nix
          ./services.nix
          ./waybar.nix
          ./wayland.nix
          ./zoxide.nix
          ./zsh.nix
        ];
      };
    };
}
