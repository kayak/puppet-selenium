define user{
  notice("Stub user ${title} declared")
}
class selenium::conf {
  $install_dir = '/tmp/testinstalldir'
  $user_name   = 'fakeuser'
  $user_group  = 'fakegroup'
  $rundir      = '/usr/local/selenium/run'
  $logdir      = '/usr/local/selenium/log'
  file { $install_dir:
    ensure => directory
  }
}
class selenium::common::jar {
  $path = '/tmp/my.jar'
}
class selenium::common {
  include selenium::conf
  include selenium::common::jar
  notice('selenium::common has been declared')
  user { $selenium::conf::user_name: }
}
class bluepill{
  notice('bluepill has been declared')
}
define bluepill::app(
  $content,
  $service_name,
  $logfile,
){
  notice("CONTENT: ${content}")
  notice("SERVICE NAME: ${service_name}")
  notice("LOGFILE: ${logfile}")
}
class myjava{
  notice('myjava has been declared')
}

selenium::server { 'fakeserver':
  env_vars       => { 'foo' => 'bar' },
  java_args      => ['a','b','c'],
  java_command   => '/fakejava',
  java_classname => 'myjava',
  selenium_args  => ['derpity derp','2ndarg'],
}
