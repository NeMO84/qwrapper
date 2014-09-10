describe Qwrapper do

  subject {Qwrapper}

  it ".version" do
    expect( subject.version ).to eql(Qwrapper::VERSION)
  end

  describe "queue" do

    it ".queue" do
      expect( subject.queue ).to eql(nil)
    end

  end

end