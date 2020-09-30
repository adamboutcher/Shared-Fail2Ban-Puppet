class fail2ban {

  if ! defined (Package['fail2ban']) {
    package { 'fail2ban':
      ensure  => latest,
    }
  }

  if ! defined (Service['fail2ban']) {
    service { 'fail2ban':
      ensure  => running,
      require => File['/etc/fail2ban/jail.conf'],
    }
  }
}

class fail2ban::standard {

  include fail2ban
  require fail2ban::params

  file { '/etc/fail2ban/jail.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => file('fail2ban/jail.conf'),
    require   => Package['fail2ban'],
    notify    => Service['fail2ban'],
  }

}
