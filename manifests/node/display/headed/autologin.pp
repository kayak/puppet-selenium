class selenium::node::display::headed::autologin {

  include selenium::conf

  exec { 'add-selenium-user-to-nopasswdlogin-group':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    unless  => "groups ${selenium::conf::user_name} | grep nopasswdlogin",
    command => "adduser ${selenium::conf::user_name} nopasswdlogin",
    require => User[$selenium::conf::user_name]
  }

  package { 'lightdm':
    ensure => installed,
  }

  ini_setting { 'guest':
    setting => 'autologin-guest',
    value   => false,
  }

  ini_setting { 'user':
    setting => 'autologin-user',
    value   => $selenium::conf::user_name,
  }

  ini_setting { 'user-timeout':
    setting => 'autologin-user-timeout',
    value   => 0,
  }

  ini_setting { 'session':
    setting => 'autologin-session',
    value   => 'lightdm-autologin',
  }

  Ini_Setting['guest','user','user-timeout','session'] {
    ensure  => present,
    path    => '/etc/lightdm/lightdm.conf',
    section => 'SeatDefaults',
    require => Package['lightdm'],
  }

}
