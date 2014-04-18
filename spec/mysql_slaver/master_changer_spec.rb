require 'spec/spec_helper'

module MysqlSlaver
  describe MasterChanger do
    let(:executor) { double(Executor, :execute => true) }

    let(:status) { {:file => 'mysql-bin.001555', :position => 18426246} }
    let(:params) {
      {
        :master_host          => 'my.db.host',
        :port                 => 3306,
        :mysql_root_password  => 'supersekrit',
        :replication_user     => 'repluser',
        :replication_password => 'replpassword',
        :executor             => executor
      }
    }
    subject(:changer) { described_class.new(params) }

    describe "#change!" do
      it "executes multi-part mysql command" do
        change_cmd = %[mysql -u root -p supersekrit  -e "stop slave; CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.001555', MASTER_LOG_POS=18426246, MASTER_HOST='my.db.host', MASTER_PORT=3306, MASTER_USER='repluser', MASTER_PASSWORD='replpassword'; start slave"]
        changer.change!(status)
        expect(executor).to have_received(:execute).with(change_cmd)
      end
    end

    context "with a non-standard mysql port" do
      let(:params) { super().merge(:port => 3307) }

      it "executes multi-part mysql command" do
        change_cmd = %[mysql -u root -p supersekrit  -e "stop slave; CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.001555', MASTER_LOG_POS=18426246, MASTER_HOST='my.db.host', MASTER_PORT=3307, MASTER_USER='repluser', MASTER_PASSWORD='replpassword'; start slave"]
        changer.change!(status)
        expect(executor).to have_received(:execute).with(change_cmd)
      end
    end
  end
end
