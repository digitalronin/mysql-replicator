module MysqlSlaver
  module MysqlCommand
    def mysql_credentials(user, password)
      rtn = "-u #{user} "
      rtn << "-p #{password} " unless password.to_s == ""
      rtn
    end

    def mysql_command(cmd, password)
      creds = mysql_credentials('root', password)
      %[mysql #{creds} -e "#{cmd}"]
    end
  end
end
