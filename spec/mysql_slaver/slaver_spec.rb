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
        expect(changer.port).to eq(3306)
      end

      context "with non-standard mysql port" do
        let(:params) { super().merge(:port => 3307) }

        it "instantiates a master changer" do
          changer = slaver.master_changer
          expect(changer.port).to eq(3307)
        end
      end

      context "with non-standard ssh port" do
        let(:params) { super().merge(:ssh_port => 64389) }

        it "instantiates a status fetcher" do
          fetcher = slaver.status_fetcher
          expect(fetcher.executor.ssh_port).to eq(64389)
        end

        it "instantiates a data copier" do
          copier = slaver.data_copier
          expect(copier.executor.ssh_port).to eq(64389)
        end
      end

      context "with mysql socket" do
        let(:params) { super().merge(:socket_file => "/tmp/mysql.sock") }

        it "instantiates a status fetcher" do
          fetcher = slaver.status_fetcher
          expect(fetcher.socket_file).to eq("/tmp/mysql.sock")
        end

        it "instantiates a master changer" do
          changer = slaver.master_changer
          expect(changer.socket_file).to eq("/tmp/mysql.sock")
        end

        it "instantiates a data copier" do
          copier = slaver.data_copier
          expect(copier.socket_file).to eq("/tmp/mysql.sock")
        end
      end
    end
  end
end
