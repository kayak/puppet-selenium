class selenium::node::display::headed::vnc{

  include selenium::conf

  $disable_screen_lock = $headed::disable_screen_lock
  $use_password        = $headed::use_vnc_password
  $password            = $headed::vnc_password
  $view_only           = $headed::vnc_view_only
  $port                = $headed::vnc_port
  $home                = $selenium::conf::user_homedir
  $logdir              = $selenium::conf::logdir
  $onlogin_script      = "${home}/onlogin"

  package { 'gnome-user-share':
    ensure => installed,
  }

  file { $onlogin_script:
    ensure  => file,
    mode    => '0755',
    content => template('selenium/onlogin.erb')
  }

  file { ["${home}/.config",
          "${home}/.config/autostart"]:
    ensure  => directory,
    mode    => '0700',
  }

  file { "${home}/.config/autostart/onlogin.desktop":
    ensure  => file,
    mode    => '0644',
    content => template('selenium/onlogin.desktop.erb'),
  }

  File [$onlogin_script,
        "${home}/.config",
        "${home}/.config/autostart",
        "${home}/.config/autostart/onlogin.desktop"]{
    owner => $selenium::conf::user_name,
    group => $selenium::conf::user_group
  }
}
