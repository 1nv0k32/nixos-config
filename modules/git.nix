{ ... }:
{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      color.ui = "auto";
      push.autoSetupRemote = true;
      push.default = "current";
      pull.rebase = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      alias.acommit = "commit --amend --no-edit --all";
      alias.fpush = "push --force-with-lease";
      rerere.enabled = true;
      format.signoff = true;
    };
  };
}
