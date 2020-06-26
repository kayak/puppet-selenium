# Creates Selenium user
class selenium::common::user{
  include selenium::conf

  $defaults = {
    'shell'      => '/bin/bash',
  }

  if $::osfamily == 'Darwin' {
    group {
      $selenium::conf::user_name:
        ensure => present;
    }

    user {
      $selenium::conf::user_name:
        ensure      => present,
        shell       => $defaults['shell'],
        managehome  => false,
        require     => Group[$selenium::conf::user_name];
    }

    file {
      "/Users/${selenium::conf::user_name}":
        ensure  => directory,
        owner   => $selenium::conf::user_name,
        require => User[$selenium::conf::user_name];
    }
  }
  else {
    create_resources('r9util::system_user',
      { "${selenium::conf::user_name}" => $selenium::conf::user_options },
      $defaults)
  }
}
