module MysqlSlaveReplicator
  class DbCopier
    include Executor
    include MysqlCommand

    attr_accessor :master_host, :mysql_root_password, :database

    def initialize(params)
      @master_host         = params.fetch(:master_host)
      @mysql_root_password = params.fetch(:mysql_root_password, '')
      @database            = params.fetch(:database)
    end

    def run
      execute mysql_command("stop slave", mysql_root_password)
      cmd = mysqldump(master_host, database, mysql_root_password)
      dump_cmd = ssh_command(cmd, master_host)
      load_cmd = ['mysql', mysql_credentials('root', mysql_root_password), database].join(' ')
      command = [dump_cmd, load_cmd].join(' | ')
      execute command
    end
  end
end
