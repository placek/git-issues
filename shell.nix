import ./nix/shell.nix {
  name = "git-shell";
  devTools = { pkgs }: with pkgs; [
    gnumake
  ];
}
