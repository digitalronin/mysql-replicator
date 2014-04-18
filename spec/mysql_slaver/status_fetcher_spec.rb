require 'spec/spec_helper'

module MysqlSlaver
  describe StatusFetcher do
    let(:executor) { double(Executor, :execute => "", :ssh_command => "dummy-ssh-command") }

    let(:params) {
      {
        :master_host          => 'my.db.host',
        :mysql_root_password  => 'supersekrit',
        :executor             => executor
      }
    }
    subject(:fetcher) { described_class.new(params) }

    before do
      fetcher.stub(:log)
    end

    describe "#status" do
      let(:output) { <<EOF
*************************** 1. row ***************************
            File: mysql-bin.003219
        Position: 37065270
    Binlog_Do_DB:
Binlog_Ignore_DB:
EOF
      }

      before do
        executor.stub(:execute => output)
      end
        
      it "executes show master command over ssh" do
        show_master = %[mysql  -u root -p supersekrit -e "show master status\\G"]
        fetcher.status
        expect(executor).to have_received(:ssh_command).with(show_master, 'my.db.host')
      end

      it "parses show master output" do
        expect(fetcher.status).to eq({:file => 'mysql-bin.003219', :position => '37065270'})
      end
    end

    context "using a socket filename" do
      let(:params) { super().merge(:socket_file => "/var/run/mysqld/mysqld.master.sock") }

      it "executes show master command over ssh" do
        show_master = %[mysql -S /var/run/mysqld/mysqld.master.sock -u root -p supersekrit -e "show master status\\G"]
        fetcher.status
        expect(executor).to have_received(:ssh_command).with(show_master, 'my.db.host')
      end
    end
  end
end
