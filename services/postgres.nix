{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    # Keep the major version pinned; PostgreSQL major upgrades require migration.
    package = pkgs.postgresql_18;
    dataDir = "/var/lib/postgresql/${pkgs.postgresql_18.psqlSchema}";
    initdbArgs = [
      "--locale=C"
      "--encoding=UTF-8"
    ];
  };
}
