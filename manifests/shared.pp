class fail2ban::shared {

  include fail2ban
  require fail2ban::params
  require fail2ban::params::shared

  file { '/etc/fail2ban/jail.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => file('fail2ban/shared/jail.conf'),
    require   => Package['fail2ban'],
    notify    => Service['fail2ban'],
  }

  file {'/etc/fail2ban/action.d/shared-f2b':
    ensure    => 'directory',
    owner     => 'root',
    group     => 'root',
    mode      => '0755',
    require   =>  Package['fail2ban'],
  }
  file { '/etc/fail2ban/action.d/shared-f2b/shared_cfg.py':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => template('fail2ban/shared-cfg.py.erb'),
    require   => File['/etc/fail2ban/action.d/shared-f2b'],
    notify    => Service['fail2ban'],
  }
  file { '/etc/fail2ban/action.d/shared-f2b/get.py':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0655',
    content   => file('fail2ban/shared/get.py'),
    require   => File['/etc/fail2ban/action.d/shared-f2b'],
    notify    => Service['fail2ban'],
  }
  file { '/etc/fail2ban/action.d/shared-f2b/input.py':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0655',
    content   => file('fail2ban/shared/input.py'),
    require   => File['/etc/fail2ban/action.d/shared-f2b'],
    notify    => Service['fail2ban'],
  }
  file { '/etc/fail2ban/action.d/shared-f2b-input.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => file('fail2ban/shared/shared-f2b-input.conf'),
    require   => File['/etc/fail2ban/action.d/shared-f2b'],
    notify    => Service['fail2ban'],
  }
  file { '/etc/fail2ban/action.d/shared-f2b/filter.log':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0744',
  }

  file { '/etc/fail2ban/filter.d/shared-f2b-filter.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => file('fail2ban/shared/shared-f2b-filter.conf'),
    require   => Package['fail2ban'],
    notify    => Service['fail2ban'],
  }

  if $::osfamily == 'RedHat' {
    exec { 'f2b_shared_selinux':
      command => '/usr/sbin/setsebool -P nis_enabled 1',
      provider=> 'shell',
      onlyif  => '/usr/sbin/getsebool nis_enabled | /usr/bin/grep off',
    }
  }

}
