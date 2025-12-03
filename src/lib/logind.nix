{ ... }:
{
  services.logind.settings.Login =
    let
      defaultAction = "lock";
    in
    {
      killUserProcesses = true;
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
      IdleAction = "ignore";
      IdleActionSec = 3600;
    };
}
