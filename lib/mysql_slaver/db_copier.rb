module MysqlSlaver
  class DbCopier
    include MysqlCommand

    attr_accessor :master_host, :mysql_root_password, :database, :executor, :port, :socket_file

    def initialize(params)
      @master_host         = params.fetch(:master_host)
      @mysql_root_password = params.fetch(:mysql_root_password, '')
      @database            = params.fetch(:database)
      @port                = params.fetch(:port, nil)
      @socket_file         = params.fetch(:socket_file, nil)
      @executor            = params.fetch(:executor) { Executor.new }
    end

    def copy!
      executor.execute mysql_command("stop slave", mysql_params)
      cmd = mysqldump
      dump_cmd = executor.ssh_command(cmd, master_host)
      load_cmd = ['mysql', mysql_credentials('root', mysql_params), database].join(' ')
      command = [dump_cmd, load_cmd].join(' | ')
      executor.execute command
    end

    private

    def mysql_params
      {
        :root_password => mysql_root_password,
        :socket_file   => socket_file
      }
    end

    def mysqldump
      creds = mysql_credentials('root', mysql_params)
      rtn =  %[mysqldump]
      rtn << %[ -P #{port}] if port
      rtn << %[ #{creds} -h #{master_host} --master-data --single-transaction --quick --skip-add-locks --skip-lock-tables --default-character-set=utf8 --compress #{database}]
      rtn
    end
  end
end
