require 'spec_helper'

module Refinery
  describe Page do

    let(:page) {
      subject.class.create!(:title => 'RSpec is great for testing too', :deletable => true)
    }
    let(:child) { page.children.create(:title => 'The child page') }

    def page_cannot_be_destroyed
      page.destroy.should == false
    end

    def turn_off_marketable_urls
      Refinery::Pages.config.stub(:marketable_urls).and_return(false)
    end

    def turn_on_marketable_urls
      Refinery::Pages.config.stub(:marketable_urls).and_return(true)
    end

    context 'cannot be deleted under certain rules' do
      it 'if link_url is present' do
        page.link_url = '/plugin-name'
        page_cannot_be_destroyed
      end

      it 'if refinery team deems it so' do
        page.deletable = false
        page_cannot_be_destroyed
      end

      it 'if menu_match is present' do
        page.menu_match = '^/RSpec is great for testing too.*$'
        page_cannot_be_destroyed
      end

      it 'unless you really want it to! >:]' do
        page.deletable = false
        page_cannot_be_destroyed
        page.destroy!.should be
      end
    end

    context 'page urls' do
      it 'return a full path' do
        page.path.should == 'RSpec is great for testing too'
      end

      it 'and all of its parent page titles, reversed' do
        child.path.should == 'RSpec is great for testing too - The child page'
      end

      it 'or normally ;-)' do
        child.path(:reversed => false).should == 'The child page - RSpec is great for testing too'
      end

      it 'returns its url' do
        page.link_url = '/contact'
        page.url.should == '/contact'
      end

      it 'returns its path with marketable urls' do
        page.url[:id].should be_nil
        page.url[:path].should == ['rspec-is-great-for-testing-too']
      end

      it 'returns its path underneath its parent with marketable urls' do
        child.url[:id].should be_nil
        child.url[:path].should == [page.url[:path].first, 'the-child-page']
      end

      it 'no path parameter without marketable urls' do
        turn_off_marketable_urls
        page.url[:path].should be_nil
        page.url[:id].should == 'rspec-is-great-for-testing-too'
        turn_on_marketable_urls
      end

      it "doesn't mention its parent without marketable urls" do
        turn_off_marketable_urls
        child.url[:id].should == 'the-child-page'
        child.url[:path].should be_nil
        turn_on_marketable_urls
      end

      it 'returns its path with slug set by menu_title' do
        page.menu_title = 'Rspec is great'
        page.save
        page.reload

        page.url[:id].should be_nil
        page.url[:path].should == ['rspec-is-great']
      end
    end

    context 'custom slugs' do
      let(:page_with_custom_slug) {
        subject.class.create!(:title => 'RSpec is great for testing too', :custom_slug => 'custom-page-slug')
      }
      let(:child_with_custom_slug) { page.children.create(:title => 'The child page', :custom_slug => 'custom-child-slug') }

      after(:each) do
        ::Refinery::I18n.config.current_frontend_locale = Refinery::I18n.config.default_frontend_locale
        ::Refinery::I18n.config.current_locale = Refinery::I18n.config.default_locale
      end

      it 'returns its path with custom slug' do
        page_with_custom_slug.url[:id].should be_nil
        page_with_custom_slug.url[:path].should == ['custom-page-slug']
      end

      it 'returns its path underneath its parent with custom urls' do
        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [page.url[:path].first, 'custom-child-slug']
      end

      it 'returns its path with custom slug when using different locale' do
        ::Refinery::I18n.config.current_frontend_locale = :ru
        ::Refinery::I18n.config.current_locale = :ru
        page_with_custom_slug.custom_slug = 'custom-page-slug-ru'
        page_with_custom_slug.save
        page_with_custom_slug.reload

        page_with_custom_slug.url[:id].should be_nil
        page_with_custom_slug.url[:path].should == ['custom-page-slug-ru']
      end

      it 'returns path underneath its parent with custom urls when using different locale' do
        ::Refinery::I18n.config.current_frontend_locale = :ru
        ::Refinery::I18n.config.current_locale = :ru
        child_with_custom_slug.custom_slug = 'custom-child-slug-ru'
        child_with_custom_slug.save
        child_with_custom_slug.reload

        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [page.url[:path].first, 'custom-child-slug-ru']
      end

    end

    context 'home page' do
      it 'responds as the home page' do
        page.link_url = '/'
        page.home?.should == true
      end

      it 'responds as a normal page when not set to home page' do
        page.home?.should == false
      end
    end

    context 'content sections (page parts)' do
      before do
        page.parts.create(:title => 'body', :content => "I'm the first page part for this page.", :position => 0)
        page.parts.create(:title => 'side body', :content => 'Closely followed by the second page part.', :position => 1)
        page.parts.reload
      end

      it 'return the content when using content_for' do
        page.content_for(:body).should == "<p>I'm the first page part for this page.</p>"
        page.content_for('BoDY').should == "<p>I'm the first page part for this page.</p>"
      end

      it 'return all page part content' do
        page.all_page_part_content.should == "<p>I'm the first page part for this page.</p> <p>Closely followed by the second page part.</p>"
      end

      it 'reposition correctly' do
        page.parts.first.update_attribute(:position, 6)
        page.parts.last.update_attribute(:position, 4)

        page.parts.first.position.should == 6
        page.parts.last.position.should == 4

        page.reposition_parts!

        page.parts.first.position.should == 0
        page.parts.last.position.should == 1
      end
    end

    context 'draft pages' do
      it 'not live when set to draft' do
        page.draft = true
        page.live?.should_not be
      end

      it 'live when not set to draft' do
        page.draft = false
        page.live?.should be
      end
    end

    context "should add url suffix" do
      let(:reserved_word) { subject.class.friendly_id_config.reserved_words.last }
      let(:page_with_reserved_title) {
        subject.class.create!(:title => reserved_word, :deletable => true)
      }
      let(:child_with_reserved_title_parent) {
        page_with_reserved_title.children.create(:title => 'reserved title child page')
      }

      before { turn_on_marketable_urls }

      it 'when title is set to a reserved word' do
        page_with_reserved_title.url[:path].should == ["#{reserved_word}-page"]
      end

      it "when parent page title is set to a reserved word" do
        child_with_reserved_title_parent.url[:path].should == ["#{reserved_word}-page", 'reserved-title-child-page']
      end
    end

    context 'meta data' do
      context 'responds to' do
        it 'meta_keywords' do
          page.respond_to?(:meta_keywords)
        end

        it 'meta_description' do
          page.respond_to?(:meta_description)
        end

        it 'browser_title' do
          page.respond_to?(:browser_title)
        end
      end

      context 'allows us to assign to' do
        it 'meta_keywords' do
          page.meta_keywords = 'Some, great, keywords'
          page.meta_keywords.should == 'Some, great, keywords'
        end

        it 'meta_description' do
          page.meta_description = 'This is my description of the page for search results.'
          page.meta_description.should == 'This is my description of the page for search results.'
        end

        it 'browser_title' do
          page.browser_title = 'An awesome browser title for SEO'
          page.browser_title.should == 'An awesome browser title for SEO'
        end
      end

      context 'allows us to update' do
        it 'meta_keywords' do
          page.meta_keywords = 'Some, great, keywords'
          page.save

          page.reload
          page.meta_keywords.should == 'Some, great, keywords'
        end

        it 'meta_description' do
          page.meta_description = 'This is my description of the page for search results.'
          page.save

          page.reload
          page.meta_description.should == 'This is my description of the page for search results.'
        end

        it 'browser_title' do
          page.browser_title = 'An awesome browser title for SEO'
          page.save

          page.reload
          page.browser_title.should == 'An awesome browser title for SEO'
        end
      end

    end

    describe "#to_refinery_menu_item" do
      let(:page) do
        Refinery::Page.new(
          :id => 5,
          :parent_id => 8,
          :url => "/foo",
          :menu_match => "^/foo$"

        # Refinery::Page does not allow setting lft and rgt, so stub them.
        ).tap do |p|
          p[:lft] = 6
          p[:rgt] = 7
        end
      end

      subject { page.to_refinery_menu_item }

      shared_examples_for("Refinery menu item hash") do
        [ [:id, 5],
          [:lft, 6],
          [:rgt, 7],
          [:parent_id, 8],
          [:menu_match, "^/foo$"]
        ].each do |attr, value|
          it "returns the correct :#{attr}" do
            subject[attr].should eq(value)
          end
        end

        it "returns the correct :url" do
          subject[:url].should be_a(Hash) # guard against nil
          subject[:url].should eq(page.url)
        end
      end

      context "with #page_menu_title" do
        before do
          page[:page_menu_title] = "Page Menu Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the page_menu_title for :title" do
          subject[:title].should eq("Page Menu Title")
        end
      end

      context "with #page_title" do
        before do
          page[:page_title] = "Page Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the page_title for :title" do
          subject[:title].should eq("Page Title")
        end
      end

      context "with #menu_title" do
        before do
          page[:menu_title] = "Menu Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the menu_title for :title" do
          subject[:title].should eq("Menu Title")
        end
      end

      context "with #title" do
        before do
          page[:title] = "Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the title for :title" do
          subject[:title].should eq("Title")
        end
      end
    end

    describe ".valid_templates" do
      before do
        File.open(File.join(Refinery::Pages.root, "spec", "ugisozols.html"), "w+") do
        end
      end

      after { File.delete(File.join(Refinery::Pages.root, "spec", "ugisozols.html")) }

      context "when pattern match valid templates" do
        it "returns an array of valid templates" do
          Refinery::Page.valid_templates('spec', '*html*').should include("ugisozols")
        end
      end

      context "when pattern doesn't match valid templates" do
        it "returns empty array" do
          Refinery::Page.valid_templates('huh', '*html*').should == []
        end
      end
    end

    describe ".in_menu?" do
      context "when live? and show_in_menu? returns true" do
        it "returns true" do
          page.stub(:live?).and_return(true)
          page.stub(:show_in_menu?).and_return(true)
          page.in_menu?.should be_true
        end
      end

      context "when live? or show_in_menu? doesn't return true" do
        it "returns false" do
          page.stub(:live?).and_return(true)
          page.stub(:show_in_menu?).and_return(false)
          page.in_menu?.should be_false

          page.stub(:live?).and_return(false)
          page.stub(:show_in_menu?).and_return(true)
          page.in_menu?.should be_false
        end
      end
    end

    describe ".not_in_menu?" do
      context "when in_menu? returns true" do
        it "returns false" do
          page.stub(:in_menu?).and_return(true)
          page.not_in_menu?.should be_false
        end
      end

      context "when in_menu? returns false" do
        it "returns true" do
          page.stub(:in_menu?).and_return(false)
          page.not_in_menu?.should be_true
        end
      end
    end
  end
end
