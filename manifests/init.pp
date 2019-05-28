# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include vaultbot
class vaultbot (
  $version,
){
  file { '/opt/vaultbot':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0555',
  }

  $base_url = "https://gitlab.com/msvechla/vaultbot/-/jobs/artifacts/v${version}/download?job=build"
  $filename = "vaultbot-${version}.zip"

  exec { "Download ${filename}":
    command  => "curl -sL ${base_url} -o /opt/vaultbot/${filename}",
    creates  => "/opt/vaultbot/${filename}",
    notify   => Exec["Unpack ${filename}"],
    requires => File['/opt/vaultbot'],
  }

  exec { "Unpack ${filename}":
    command     => "unzip ${filename}",
    refreshonly => true,
    cwd         => '/opt/vaultbot',
  }

  file { '/etc/profile.d/vaultbot.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => 'modules/vaultbot/vaultbot.sh',
  }
}
