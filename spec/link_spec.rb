require 'spec_helper'

describe Link do

  before(:each) do
    User.create(  :id =>                    1,
                  :email =>                 "test@test.com",
                  :password =>              'test',
                  :password_confirmation => 'test')
  end

  context "Demonstration of how datamapper works"

    it "should be created and then retrieved from the db" do
      expect(Link.count).to eq(0)
      Link.create(:title => "Makers Academy",
                  :url => "http://www.makersacademy.com/",
                  :user_id => 1)
      expect(Link.count).to eq(1)
      link = Link.first
      expect(link.url).to eq("http://www.makersacademy.com/")
      expect(link.title).to eq("Makers Academy")
      link.destroy
      expect(Link.count).to eq(0)
    end

end
