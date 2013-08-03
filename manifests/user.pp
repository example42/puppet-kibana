# Class: kibana::user
#
# This class creates kibana user
#
class kibana::user {
  @user { $kibana::user :
    ensure     => $kibana::manage_file,
    comment    => "${kibana::user} user",
    password   => '!',
    managehome => false,
    uid        => $kibana::user_uid,
    gid        => $kibana::user_gid,
    groups     => $kibana::groups,
    shell      => '/bin/bash',
  }

  User <| title == $kibana::user |>

}

