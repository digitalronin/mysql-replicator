module MysqlSlaver
  class Executor
    attr_reader :ssh_port

    include Logger

    def initialize(params = {})
      @ssh_port = params[:ssh_port]
    end

    def ssh_command(cmd, host)
      if ssh_port
        "ssh -p #{ssh_port} #{host} '#{cmd}'"
      else
        "ssh #{host} '#{cmd}'"
      end
    end

    def execute(cmd)
      string = cmd.is_a?(Array) ? cmd.join('; ') : cmd
      log "CMD: #{string}"
      `#{string}`
    end
  end
end
