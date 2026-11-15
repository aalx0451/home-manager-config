{ ... }:

{
  programs.git-credential-keepassxc = {
    groups = [ "Git" ];
    hosts = [ "https://github.com" ];
  };
}
