class fail2ban::server {

  class { 'mysql':
    root_password => 'R@@tP4ssw0rd',
  }
  mysql::db::create { 'f2b': }

}
class fail2ban::server::api {

  include fail2ban::server
  mysql::user::grant { 'f2b':
    host => 'localhost',
    user => 'f2b_api_user',
    password => 'p4ssw0rd',
    database => 'f2b',
  }

  if ( $::os[name] == 'CentOS' or $::os[name] == 'Rocky' or $::os[name] == 'Alma') {

    if ! defined (Package['httpd']) {
      package { 'httpd': ensure  => latest, }
    }
    if ! defined (Service['httpd']) {
      service { 'httpd': ensure  => running, }
    }

    if ! defined (Package['python3-pip']) {
      package { 'python3-pip': ensure  => latest, }
    }

    case $::os[release][major] {
    '7': {
      if ! defined (Package['httpd-devel']) {
        package { 'httpd-devel': ensure  => latest, }
      }
      if ! defined (Package['gcc']) {
        package { 'gcc': ensure  => latest, }
      }
      if ! defined (Package['python36']) {
        package { 'python36': ensure  => latest, }
      }
      if ! defined (Package['python36-virtualenv']) {
        package { 'python36-virtualenv': ensure  => latest, }
      }
      if ! defined (Package['python3-mod_wsgi']) {
        package { 'python3-mod_wsgi': ensure  => latest, name => 'mod_wsgi', provider => 'pip3' }
      }
      exec { 'copy_python3_wsgi':
        command => '/usr/bin/cp /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi_python3.so',
        provider=> 'shell',
        creates => '/etc/httpd/modules/mod_wsgi_python3.so',
      }

    }
    '8','9': {

      if ! defined (Package['python3-mod_wsgi']) {
        package { 'python3-mod_wsgi': ensure  => latest, }
      }

    }
    
    if !defined (Selboolean["httpd_can_network_connect_db"]) {
      selboolean { "httpd_can_network_connect_db":
        persistent => "true",
        value      => "on",
        require    => Package['httpd'],
      }
    }

    exec { '/opt/f2bapi':
      command   => 'python3 -m virtualenv /opt/f2bapi >/dev/null 2>&1 || python3 -m venv /opt/f2bapi >/dev/null 2>&1',
      provider  => 'shell',
      creates   => '/opt/f2bapi',
    }
    exec { 'VirtualEnv Build Flask':
      command   => 'source /opt/f2bapi/bin/activate && pip3 install flask >/dev/null 2>&1',
      provider  => 'shell',
      unless    => 'source /opt/f2bapi/bin/activate && pip3 list | grep flask',
    }
    exec { 'VirtualEnv Build Flask-Caching':
      command   => 'source /opt/f2bapi/bin/activate && pip3 install flask-caching >/dev/null 2>&1',
      provider  => 'shell',
      unless    => 'source /opt/f2bapi/bin/activate && pip3 list | grep flask-caching',
    }
    exec { 'VirtualEnv Build MySQL-Connector':
      command   => 'source /opt/f2bapi/bin/activate && pip3 install mysql-connector >/dev/null 2>&1',
      provider  => 'shell',
      unless    => 'source /opt/f2bapi/bin/activate && pip3 list | grep mysql-connector',
    }
    file { '/opt/f2bapi/api_cfg.py':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      content   => file('fail2ban/shared_server/api_cfg.py'),
      require   => [ Exec['/opt/f2bapi'], Package['python3-mod_wsgi'], ],
      before    => File['/opt/f2bapi/api.py'],
      notify    => Service['httpd'],
    }
    file { '/opt/f2bapi/api.py':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0755',
      content   => file('fail2ban/shared_server/api.py'),
      require   => [ Exec['/opt/f2bapi'], Package['python3-mod_wsgi'], ],
      before    => File['/opt/f2bapi/api.wsgi'],
      notify    => Service['httpd'],
    }
    file { '/opt/f2bapi/api.wsgi':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0755',
      content   => file('fail2ban/shared_server/api.wsgi'),
      require   => [ Exec['/opt/f2bapi'], Package['python3-mod_wsgi'], ],
      notify    => Service['httpd'],
    }

    file { '/etc/httpd/conf.modules.d/05-wsgi.conf':
      ensure    => present,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      content   => file('fail2ban/shared_server/httpd-module-wsgi-python3.conf'),
      require   => Package['python3-mod_wsgi'],
      notify    => Service['httpd'],
    }
    file { '/etc/httpd/conf.d/api.conf':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      content   => file('fail2ban/shared_server/httpd_api.conf'),
      require   => File['/opt/f2bapi/api.wsgi'],
      notify    => Service['httpd'],
    }

  }

}
