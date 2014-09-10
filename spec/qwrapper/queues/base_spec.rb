describe Qwrapper::Queues::Base do

  subject {Qwrapper::Queues::Base.new({})}

  describe "logging" do

    it ".logger" do
      expect( subject.logger ).not_to eql(nil)
    end

    it ".logger=" do
      expect{ subject.logger = :some_logger }.not_to raise_error
    end

  end

end