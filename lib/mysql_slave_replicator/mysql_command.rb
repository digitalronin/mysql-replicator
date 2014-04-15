module MysqlSlaveReplicator
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

    def mysqldump(host, database, password)
      creds = mysql_credentials('root', password)
      %[mysqldump -h #{host} #{creds} --master-data --single-transaction --quick --skip-add-locks --skip-lock-tables --default-character-set=utf8 --compress #{database}]
    end
  end
end
