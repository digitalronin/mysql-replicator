require 'spec/spec_helper'

module MysqlSlaver
  describe Slaver do
    subject(:slaver) { described_class.new(params) }

    describe "#enslave!" do
      let(:status_fetcher) { double(StatusFetcher, :status  => ())   }
      let(:data_copier)    { double(DbCopier, :copy!        => true) }
      let(:master_changer) { double(MasterChanger, :change! => true) }

      let(:params) {
        {
          :status_fetcher => status_fetcher,
          :data_copier    => data_copier,
          :master_changer => master_changer
        }
      }

      it "fetches master status" do
        slaver.enslave!
        expect(status_fetcher).to have_received(:status)
      end

      it "copies data" do
        slaver.enslave!
        expect(data_copier).to have_received(:copy!)
      end

      it "changes master status" do
        slaver.enslave!
        expect(master_changer).to have_received(:change!)
      end

    end

    context "instantiating collaborators" do
      let(:params) {
        {
          :master_host          => 'my.db.host',
          :mysql_root_password  => 'supersekrit',
          :database             => 'myappdb',
          :replication_user     => 'repluser',
          :replication_password => 'replpassword'
        }
      }

      it "instantiates a status fetcher" do
        fetcher = slaver.status_fetcher
        expect(fetcher.master_host).to eq('my.db.host')
        expect(fetcher.mysql_root_password).to eq('supersekrit')
      end

      it "instantiates a data copier" do
        copier = slaver.data_copier
        expect(copier.master_host).to eq('my.db.host')
        expect(copier.mysql_root_password).to eq('supersekrit')
        expect(copier.database).to eq('myappdb')
      end

      it "instantiates a master changer" do
        changer = slaver.master_changer
        expect(changer.master_host).to eq('my.db.host')
        expect(changer.mysql_root_password).to eq('supersekrit')
        expect(changer.replication_user).to eq('repluser')
        expect(changer.replication_password).to eq('replpassword')
      end
    end
  end
end
