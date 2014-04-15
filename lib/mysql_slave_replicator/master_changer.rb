module MysqlSlaveReplicator
  class MasterChanger
    include Executor
    include Logger
    include MysqlCommand

    attr_accessor :master_host, :mysql_root_password, :file, :position, :replication_user, :replication_password

    def initialize(params)
      @master_host          = params.fetch(:master_host)
      @mysql_root_password  = params.fetch(:mysql_root_password, '')
      @file                 = params.fetch(:file)
      @position             = params.fetch(:position)
      @replication_user     = params.fetch(:replication_user)
      @replication_password = params.fetch(:replication_password)
    end

    def change!
      cmds = [
        'stop slave',
        change_master,
        'start slave'
      ]
      cmd = mysql_command(cmds.join('; '), mysql_root_password)
      execute cmd
    end

    private

    def change_master
      %[CHANGE MASTER TO MASTER_LOG_FILE='#{file}', MASTER_LOG_POS=#{position}, MASTER_HOST='#{master_host}', MASTER_USER='#{replication_user}', MASTER_PASSWORD='#{replication_password}']
    end
  end
end
