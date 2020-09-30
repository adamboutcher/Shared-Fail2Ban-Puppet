class fail2ban::params {

}
class fail2ban::params::shared {

  # 'api' or 'sql'
  $f2b_type       = hiera('f2b_type', 'api')
  # api details
  $f2b_apiurl     = hiera('f2b_apiurl', 'https://f2b.example.com/api/v1')

  if $f2b_apitoken {
    $f2b_apitoken = hiera('f2b_apitoken', $f2b_apitoken)
  } else {
    notify { 'SF2BAT':
      name        => 'Fail2Ban API Token',
      message     => 'Using Default Shared Fail2BanAPI Token',
    }
    $f2b_apitoken = hiera('f2b_apitoken', 'Default-API-TOKEN-goes-in-fail2ban/params.pp')
  }

  # sql details
  $f2b_sqlhost    = hiera('f2b_sqlhost', 'blah')
  $f2b_sqluser    = hiera('f2b_sqluser', 'blah')
  $f2b_sqlpass    = hiera('f2b_sqlpass', 'blah')
  $f2b_sqldb      = hiera('f2b_sqldb', 'blah')

}
