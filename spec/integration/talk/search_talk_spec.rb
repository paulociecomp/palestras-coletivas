require "spec_helper"

describe "Search talk", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }
  
  context "without seeking" do
    before do
      visit root_path
    end

    it "redirects to home page" do
      expect(current_path).to eql(root_path)
    end

    it "displays access my account" do
      expect(page).to have_content("Trabalhos")
    end
  end

  context "with empty search" do
    before do
      visit root_path
      click_link "Trabalhos"
      fill_in :talk_search, :with => ""
      click_button "Buscar"
    end

    it "redirects to talks page" do
      expect(current_path).to eql(talks_path)
    end

    it "displays access my account" do
      expect(page).to have_content("Trabalhos")
    end
  end

  context "when the search is successful" do
    before do
      visit root_path
      click_link "Trabalhos"
      fill_in :talk_search, :with => "compartilhe"
      click_button "Buscar"
    end

    it "redirects to talks page" do
      expect(current_path).to eql(talks_path)
    end

    it "shows talks found" do
      expect(page).to have_content("Compartilhe")
    end
  end

  context "when the search is not successful" do
    before do
      visit root_path
      click_link "Trabalhos"
      fill_in :talk_search, :with => "noob"
      click_button "Buscar"
    end

    it "redirects to talks page" do
      expect(current_path).to eql(talks_path)
    end

    it "not show talks" do
      expect(page).not_to have_content("Compartilhe")
    end
  end
end