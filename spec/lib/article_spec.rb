require 'article'

describe "Article" do

  let(:id) { "article-name" }
  let(:publish) { Date.new(2011, 10, 15) }
  let(:summary) { "The Summary" }
  let(:attributes) { { "title" => "Article Name", "publish" => publish, "summary" => summary } }

  subject { Article.new(id, attributes) }

  it { should be_found }

  it "has an id" do
    subject.id.should == id
  end

  describe "#title" do

    it "is read from the attributes" do
      subject.title.should == "Article Name"
    end

  end

  describe "#summary" do

    it "is read from the attributes" do
      subject.summary.should == summary
    end

  end

  describe "#url" do

    it "is made from the id" do
      subject.url.should == "/article-name"
    end

  end

  describe "#contents" do

    it "delegates to Contents class" do
      contents = mock
      contents.should_receive(:read).with(id)
      subject.contents(contents)
    end

  end

  describe "#old?" do

    let(:oldness) { double }

    before { subject.stub(:deprecated?).and_return(false) }

    it "delegates to oldness class" do
      oldness.should_receive(:old?).with(publish)
      subject.old?(oldness)
    end

    it "is not old when deprecated" do
      subject.should_receive(:deprecated?).and_return(true)
      oldness.should_not_receive(:old?)
      subject.old?(oldness)
    end

  end

  describe "#deprecated?" do

    it "might not be deprecated" do
      subject.should_not be_deprecated
    end

    it "might be deprecated" do
      subject = Article.new(id, "deprecated" => true)
      subject.should be_deprecated
    end

  end

end