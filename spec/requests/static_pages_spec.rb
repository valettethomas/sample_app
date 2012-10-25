require 'spec_helper'

include ApplicationHelper

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1',    text: 'Sample App') }
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    it { should have_selector('h1',    text: 'Help') }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_selector('h1',    text: 'About') }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('h1',    text: 'Contact') }
  end

  describe "links" do
    it {
      visit root_path
      click_link "About"
      page.should have_selector 'title', text: 'About'
      click_link "Help"
      page.should have_selector 'title', text: 'Help'
      click_link "Contact"
      page.should have_selector 'title', text: 'Contact'
      click_link "Home"
      click_link "Sign up now!"
      page.should have_selector 'title', text: 'Sign up'
      click_link "sample app"
      page.should have_selector 'title', text: 'Sign up'
    }
  end
end