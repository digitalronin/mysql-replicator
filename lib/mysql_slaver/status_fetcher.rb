module MysqlSlaver
  class StatusFetcher
    include Logger
    include MysqlCommand

    attr_accessor :master_host, :mysql_root_password, :executor

    def initialize(params)
      @master_host          = params.fetch(:master_host)
      @mysql_root_password  = params.fetch(:mysql_root_password, '')
      @executor             = params.fetch(:executor) { Executor.new }
    end

    def status
      cmd = mysql_command("show master status\\G", mysql_root_password)
      data = executor.execute executor.ssh_command(cmd, master_host)
      rtn = parse data
      log "MASTER STATUS - file: #{rtn[:file]}, position: #{rtn[:position]}"
      rtn
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

  end
end
