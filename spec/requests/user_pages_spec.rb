# -*- coding: utf-8 -*-
require 'spec_helper'

describe "ユーザーページ" do

  subject { page }

  describe "プロファイルページ" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "サインアップページ" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    describe "正しくない情報で登録すれば" do
      it "ユーザーアカウントは作成されない" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

    end

    describe "正しい情報で登録すれば" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "ユーザーアカウントが作成される" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end

  end

end
