module MysqlSlaveReplicator
  class DbCopier
    include Executor
    include Logger
    include MysqlCommand

    attr_accessor :master_host, :mysql_root_password, :database

    def initialize(params)
      @master_host         = params.fetch(:master_host)
      @mysql_root_password = params.fetch(:mysql_root_password, '')
      @database            = params.fetch(:database)
    end

    def run
      cmd = mysqldump(master_host, database, mysql_root_password)
      dump_cmd = ssh_command(cmd, master_host)
      log dump_cmd
      load_cmd = ['mysql', mysql_credentials('root', mysql_root_password), database].join(' ')
      log load_cmd
      execute [dump_cmd, load_cmd].join(' | ')
    end

    private

    def parse(text)
      file = nil
      position = nil
      text.split("\n").each do |line|
        case line
        when /File: (mysql-bin\.\d+)/
          file = $1
        when /Position: (\d+)/
          position = $1
        end
      end
      {:file => file, :position => position}
    end

    def mysql_command(cmd)
      rtn = "mysql -u root "
      rtn << "-p #{mysql_root_password} " unless mysql_root_password.to_s == ""
      rtn << %[-e "#{cmd}"]
    end
  end
end
