{ ... }:
{
  programs.git = {
    enable = true;
    prompt.enable = true;
    config = {
      init.defaultBranch = "main";
      color.ui = "auto";
      fetch.prune = true;
      fetch.pruneTags = true;
      pull.rebase = true;
      commit.gpgsign = true;
      push.autoSetupRemote = true;
      push.default = "current";
      rerere.enabled = true;
      format.signoff = true;
      alias.fpush = "push --force-with-lease";
      alias.acommit = "commit --amend --no-edit --all";
    };
  };
}
