require 'spec/spec_helper'

module MysqlSlaver
  describe Executor do
    subject(:executor) { described_class.new }

    describe "#ssh_command" do
      it "formats command" do
        expect(executor.ssh_command("foo", "myhost")).to eq("ssh -p 64389 myhost 'foo'")
      end
    end
  end
end
