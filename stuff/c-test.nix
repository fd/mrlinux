{
  containers.demo = {
    privateNetwork = true;
    hostAddress = "10.250.0.1";
    localAddress = "10.250.0.2";

    config = { pkgs, ... }: {
      system.stateVersion = "23.11";
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nginx.enable = true;
      services.nginx.virtualHosts."default" = {
        root = ./c-test;
      };
    };
  };
}
