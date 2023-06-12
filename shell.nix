import ./nix/shell.nix {
  name = "git-issues";
  devTools = { pkgs }: with pkgs; [
    gnumake
  ];
}
