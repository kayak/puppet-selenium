class selenium::node(
  $hub_host             = $selenium::hub_host,
  $hub_port             = '4444',

  $java_args            = [],
  $system_properties    = {},
  $env_vars             = {},

  $install_chromedriver = false,
  $chromedriver_version = '2.1',

  $config_hash          = {},
  $config_source        = undef,
  $config_content       = undef,

  $bluepill_cfg_content = undef,
  $bluepill_cfg_source  = undef,
){
  include selenium::common
  include selenium::node::display

  $hub = "http://${hub_host}:${hub_port}/grid/register"
  $config_file = "${conf::confdir}/nodeConfig.json"

  file { $config_file:
    ensure  => present,
    owner   => $conf::user_name,
    group   => $conf::user_group,
    mode    => '0644',
  }

  if $config_source != undef {
    File[$config_file] {
      source  => $config_source,
    }
  } elsif $config_content != undef {
    File[$config_file] {
      content => $config_content,
    }
  } else {
    $cfg_defaults = { 'configuration' => { 'hub' => $hub } }
    $final_hash = deep_merge($cfg_defaults,$config_hash)

    File[$config_file] {
      content => predictable_pretty_json($final_hash,true),
    }
  }

  selenium::server { 'node':
    selenium_args        => ['-role','node','-nodeConfig',$config_file],
    java_command         => $conf::java_command,
    java_classname       => $conf::java_classname,
    java_args            => $java_args,
    system_properties    => $system_properties,
    env_vars             => merge({ 'DISPLAY' => ':0' }, $env_vars ),
    bluepill_cfg_content => $bluepill_cfg_content,
    bluepill_cfg_source  => $bluepill_cfg_source,
    subscribe            => File[$config_file],
    require              => Class['Selenium::Common']
  }

  if $install_chromedriver {
    include selenium::node::chromedriver
  }

  Class['Selenium::Node::Display'] -> Selenium::Server['node']
}
