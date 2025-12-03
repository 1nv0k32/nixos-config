{ ... }:
{
  services.logind.settings =
    let
      defaultAction = "lock";
    in
    {
      killUserProcesses = true;
      Login = {
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
    };
}
