module MysqlSlaver
  class Executor
    include Logger

    def ssh_command(cmd, host)
      "ssh #{host} '#{cmd}'"
    end

    def execute(cmd)
      string = cmd.is_a?(Array) ? cmd.join('; ') : cmd
      log "CMD: #{string}"
      `#{string}`
    end
  end
end
