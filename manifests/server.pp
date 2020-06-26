define selenium::server(
  $env_vars          = {},     # Environment variables to set. (shellquoted)
  $system_properties = {},     # Hash of system properties to set for the jvm
  $java_args         = [],     # Array of arguments to pass to jvm
  $java_command      = 'java', # Java command to run
  $java_class        = 'org.openqa.grid.selenium.GridLauncher',
  $java_classname    = 'java', # Name of a Java class to require
  $java_classpath    = [],
  $selenium_args     = [],     # Array of arguments to pass to selenium jar
  $bluepill_cfg_content = undef,
  $bluepill_cfg_source  = undef,
){

  include selenium::common

  $appname = "selenium-${title}"
  $cmd     = template('selenium/start_command.erb')
  $logfile = "${selenium::conf::logdir}/${title}.log"
  $pidfile = "${selenium::conf::rundir}/${title}.pid"

  if $::osfamily == 'RedHat' {
    include bluepill

    bluepill::simple_app { $appname:
      start_command     => $cmd,
      user              => $selenium::conf::user_name,
      group             => $selenium::conf::user_group,
      pidfile           => $pidfile,
      service_name      => $appname,
      logfile           => $logfile,
      rotate_logs       => true,
      logrotate_options => {
        'compress'      => true,
        'copytruncate'  => true,
        'dateext'       => true,
        'dateformat'    => '-%Y%m%d-%s',
        'delaycompress' => false,
        'ifempty'       => false,
        'missingok'     => true,
        'rotate'        => 8,
        'rotate_every'  => 'hour',
        'size'          => '50M',
      },
      config_content    => $bluepill_cfg_content,
      config_source     => $bluepill_cfg_source,
      require           => [User[$selenium::conf::user_name], File[$selenium::conf::install_dir]],
      subscribe         => Class['selenium::common::jar'],
    }
  }
  elsif $::osfamily == 'Darwin' {
    file { '/Library/LaunchDaemons/com.kayak.selenium.plist':
      ensure => file,
      content => template('selenium/com.kayak.selenium.plist.erb');
    }

    service { 'com.kayak.selenium':
      ensure    => running,
      subscribe => File['/Library/LaunchDaemons/com.kayak.selenium.plist'];
    }
  }

  if $java_classname == 'UNDEFINED' {
    warning('Java classname set to UNDEFINED, not including or requiring Java')
  }else{
    include $java_classname
    if $::osfamily == 'RedHat' {
      Class[$java_classname] -> Bluepill::App["selenium-${title}"]
    }
  }
}
