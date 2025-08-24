{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        batisteo.vscode-django
        davidanson.vscode-markdownlint
        editorconfig.editorconfig
        golang.go
        hashicorp.terraform
        jnoortheen.nix-ide
        mads-hartmann.bash-ide-vscode
        mhutchie.git-graph
        mkhl.direnv
        oderwat.indent-rainbow
        pkief.material-icon-theme
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        usernamehw.errorlens
        visualstudioexptteam.vscodeintellicode
        vscodevim.vim
        waderyan.gitblame
      ];
    })
  ];
}
