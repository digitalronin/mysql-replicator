require 'spec/spec_helper'

module MysqlSlaver
  describe Executor do
    let(:ssh_port) { nil }
    let(:params)   { {:ssh_port => ssh_port} }

    subject(:executor) { described_class.new(params) }

    describe "#ssh_command" do
      it "formats command" do
        expect(executor.ssh_command("foo", "myhost")).to eq("ssh myhost 'foo'")
      end

      context "with non-standard ssh port" do
        let(:ssh_port) { 64389 }

        it "formats command" do
          expect(executor.ssh_command("foo", "myhost")).to eq("ssh -p 64389 myhost 'foo'")
        end
      end
    end
  end
end
