require 'spec_helper'

module Spotlight
  describe "_user_util_links" do
    let(:current_exhibit) { FactoryGirl.create(:exhibit) }
    before do
      view.stub(:current_user).and_return(current_user)
      view.stub(:current_exhibit).and_return(current_exhibit)
      view.stub(show_contact_form?: true)
    end

    describe "when user is not logged in" do
      let(:current_user) { nil }
      it "renders the links" do
        render
        expect(rendered).to have_link 'Sign in'
        expect(rendered).to have_link 'Feedback'
      end
    end

    describe "when show_contact_form is false" do
      let(:current_user) { nil }
      before do
        view.stub(show_contact_form?: false)
      end
  
      it "should not render the feedback link" do
        render
        expect(rendered).to_not have_link 'Feedback'
      end
    end

    describe "when user is logged in" do
      let(:current_user) { ::User.new }
      it "renders the links" do
        render
        expect(rendered).to have_link 'Feedback'
        expect(rendered).to_not have_link 'Dashboard'
        expect(rendered).to have_link 'Sign out'
      end
    end

    describe "when user is a curator" do
      let(:current_user) { ::User.new }
      before do
        view.stub(:can?).with(:update, current_exhibit).and_return(false)
        view.stub(:can?).with(:create, Spotlight::Exhibit).and_return(false)
        view.stub(:can?).with(:curate, current_exhibit).and_return(true)
      end
      it "renders the links" do
        render
        expect(rendered).to have_link 'Feedback'
        expect(rendered).to have_link 'Dashboard'
        expect(rendered).to have_link 'Sign out'
      end
    end
    describe "when user is an admin" do
      let(:current_user) { ::User.new }
      before do
        view.stub(:can?).with(:update, current_exhibit).and_return(true)
        view.stub(:can?).with(:create, Spotlight::Exhibit).and_return(false)
        view.stub(:can?).with(:curate, current_exhibit).and_return(true)
      end
      it "renders the links" do
        render
        expect(rendered).to have_link 'Feedback'
        expect(rendered).to have_link 'Dashboard'
        expect(rendered).to have_link 'Sign out'
      end
    end

    describe "when user is a site-wide admin" do
      let(:current_user) { ::User.new }
      before do
        view.stub(:can?).with(:update, current_exhibit).and_return(true)
        view.stub(:can?).with(:create, Spotlight::Exhibit).and_return(true)
        view.stub(:can?).with(:curate, current_exhibit).and_return(true)
      end
      it "renders the links" do
        render
        expect(rendered).to have_link 'Feedback'
        expect(rendered).to have_link 'Dashboard'
        expect(rendered).to have_link 'Create Exhibit'
        expect(rendered).to have_link 'Sign out'
      end
    end
  end
end
