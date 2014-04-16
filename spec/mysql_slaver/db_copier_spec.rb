require 'spec/spec_helper'

module MysqlSlaver
  describe DbCopier do
    let(:executor) { double(Executor, :execute => true, :ssh_command => "dummy-ssh-command") }

    let(:params) {
      {
        :master_host         => 'my.db.host',
        :mysql_root_password => 'supersekrit',
        :database            => 'myappdb',
        :executor            => executor
      }
    }
    subject(:copier) { described_class.new(params) }

    describe "#run" do
      it "stops slave" do
        copier.run
        stop = %[mysql -u root -p supersekrit  -e "stop slave"]
        expect(executor).to have_received(:execute).with(stop)
      end

      it "loads data" do
        dump_and_load = "dummy-ssh-command | mysql -u root -p supersekrit  myappdb"
        expect(executor).to receive(:execute).once.ordered.with(dump_and_load)
        copier.run
      end

      context "dumping" do
        it "issues mysqldump over ssh" do
          dump = "mysqldump -h my.db.host -u root -p supersekrit  --master-data --single-transaction --quick --skip-add-locks --skip-lock-tables --default-character-set=utf8 --compress myappdb"
          expect(executor).to receive(:ssh_command).with(dump, 'my.db.host')
          copier.run
        end
      end
    end
  end
end
