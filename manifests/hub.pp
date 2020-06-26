class selenium::hub(
  $java_args         = [], # JVM args
  $system_properties = {}, # Java system properties
  $env_vars          = {}, # Environment variables
  $config_hash       = {}, # Hub JSON configuration options.
  $java_class        = 'org.openqa.grid.selenium.GridLauncher',
  $config_source     = undef,
  $config_content    = undef,
  $bluepill_cfg_content = undef,
  $bluepill_cfg_source  = undef,
){
  include selenium::common

  $configfile = "${selenium::conf::confdir}/hubConfig.json"
  file { $configfile:
    ensure  => present,
    owner   => $selenium::conf::user_name,
    group   => $selenium::conf::user_group,
    mode    => '0644',
  }
  ->
  selenium::server { 'hub':
    selenium_args        => ['-role','hub','-hubConfig',$configfile],
    java_command         => $selenium::conf::java_command,
    java_classpath       => $selenium::conf::java_classpath,
    java_classname       => $selenium::conf::java_classname,
    java_class           => $java_class,
    java_args            => $java_args,
    system_properties    => $system_properties,
    env_vars             => $env_vars,
    bluepill_cfg_content => $bluepill_cfg_content,
    bluepill_cfg_source  => $bluepill_cfg_source,
    subscribe            => File[$configfile],
    require              => Class['Selenium::Common'],
  }

  if $config_source != undef {
    File[$configfile]{
      source => $config_source,
    }
  } elsif $config_content != undef {
    File[$configfile]{
      content => $config_content,
    }
  } else {
    File[$configfile]{
      content => inline_template("<% require 'json' %><%= JSON.pretty_generate(@config_hash) %>"),
    }
  }
}
