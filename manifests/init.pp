# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include vaultbot
class vaultbot (
  $version,
  $vault_addr,
  $app_role_role_id,
  $app_role_secret_id,
  $pki_mount,
  $pki_role_name,
  $pki_common_name,
  $pki_cert_path,
  $pki_cachain_path,
  $pki_privkey_path,
  $pki_pembundle_path,
  $renew_hook,
){
  file { '/opt/vaultbot':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0555',
  }

  file { '/etc/logrotate.d/vaultbot':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => 'puppet:///modules/vaultbot/logrotate-vaultbot',
  }

  file { '/etc/cron.hourly/vaultbot-renewal.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
    content => template('vaultbot/vaultbot-renewal.sh.erb'),
  }

  $base_url = "https://gitlab.com/msvechla/vaultbot/-/jobs/artifacts/v${version}/download?job=build"
  $filename = "vaultbot-v${version}.zip"

  exec { "Download ${filename}":
    command => "curl -sL ${base_url} -o /opt/vaultbot/${filename}",
    creates => "/opt/vaultbot/${filename}",
    notify  => Exec["Unpack ${filename}"],
    require => File['/opt/vaultbot'],
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
    source => 'puppet:///modules/vaultbot/vaultbot.sh',
  }
}
