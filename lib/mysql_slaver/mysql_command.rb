module MysqlSlaver
  module MysqlCommand
    def mysql_credentials(user, params)
      password    = params.fetch(:root_password, "")
      socket_file = params.fetch(:socket_file, nil)

      rtn = ""
      rtn << "-S #{socket_file}" if socket_file
      rtn << " -u #{user}"
      rtn << " -p #{password}" unless password.to_s == ""
      rtn
    end

    def mysql_command(cmd, params)
      creds = mysql_credentials('root', params)
      %[mysql #{creds} -e "#{cmd}"]
    end
  end
end
