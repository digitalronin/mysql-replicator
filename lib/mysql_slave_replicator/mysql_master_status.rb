module MysqlSlaveReplicator
  class MysqlMasterStatus
    attr_accessor :master_host, :mysql_root_password

    def initialize(params)
      @master_host          = params.fetch(:master_host)
      @mysql_root_password  = params.fetch(:mysql_root_password, '')
    end

    def status
      data = remote_command(mysql_command("show master status\G"))
    end

    private

    def remote_command(cmd)
      `ssh #{master_host} '#{cmd}'`
    end

    def mysql_command(cmd)
      rtn = "mysql -u root "
      rtn << "-p #{mysql_root_password} " unless mysql_root_password.to_s == ""
      rtn << cmd
    end
  end
end
