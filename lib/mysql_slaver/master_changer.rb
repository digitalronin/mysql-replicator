module MysqlSlaver
  class MasterChanger
    include Executor
    include Logger
    include MysqlCommand

    attr_accessor :master_host, :mysql_root_password, :replication_user, :replication_password

    def initialize(params)
      @master_host          = params.fetch(:master_host)
      @mysql_root_password  = params.fetch(:mysql_root_password, '')
      @replication_user     = params.fetch(:replication_user)
      @replication_password = params.fetch(:replication_password)
    end

    def change!(status)
      cmds = [
        'stop slave',
        change_master(status),
        'start slave'
      ]
      cmd = mysql_command(cmds.join('; '), mysql_root_password)
      execute cmd
    end

    private

    def change_master(status)
      %[CHANGE MASTER TO MASTER_LOG_FILE='#{status[:file]}', MASTER_LOG_POS=#{status[:position]}, MASTER_HOST='#{master_host}', MASTER_USER='#{replication_user}', MASTER_PASSWORD='#{replication_password}']
    end
  end
end
