# Creates Selenium user
class selenium::common::user{
  include selenium::conf

  $defaults = {
    'shell'      => '/bin/bash',
  }

  if $::osfamily == 'Darwin' {
    group {
      $conf::user_name:
        ensure => present;
    }

    user {
      $conf::user_name:
        ensure      => present,
        shell       => $defaults['shell'],
        managehome  => false,
        require     => Group[$conf::user_name];
    }

    file {
      "/Users/${conf::user_name}":
        ensure  => directory,
        owner   => $conf::user_name,
        require => User[$conf::user_name];
    }
  }
  else {
    create_resources('r9util::system_user',
      { "${conf::user_name}" => $conf::user_options },
      $defaults)
  }
}
