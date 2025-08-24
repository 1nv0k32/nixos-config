{ ... }:
{
  services.logind =
    let
      defaultAction = "lock";
    in
    {
      lidSwitch = defaultAction;
      lidSwitchDocked = defaultAction;
      lidSwitchExternalPower = defaultAction;
      suspendKey = defaultAction;
      suspendKeyLongPress = defaultAction;
      rebootKey = defaultAction;
      rebootKeyLongPress = defaultAction;
      powerKey = defaultAction;
      powerKeyLongPress = defaultAction;
      hibernateKey = defaultAction;
      hibernateKeyLongPress = defaultAction;
      killUserProcesses = true;
      extraConfig = ''
        IdleAction=ignore
        IdleActionSec=3600
      '';
    };
}
