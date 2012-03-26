require 'spec_helper'

module Refinery
  describe Page do

    let(:page_title) { 'RSpec is great for testing too' }
    let(:child_title) { 'The child page' }

    # For when we do not need the page persisted.
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}
    let(:child) { page.children.new(:title => child_title) }

    # For when we need the page persisted.
    let(:created_page) { subject.class.create!(:title => page_title, :deletable => true) }
    let(:created_child) { created_page.children.create!(:title => child_title) }

    def page_cannot_be_destroyed
      page.destroy.should == false
    end

    def turn_off_marketable_urls
      Refinery::Pages.stub(:marketable_urls).and_return(false)
    end

    def turn_on_marketable_urls
      Refinery::Pages.stub(:marketable_urls).and_return(true)
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
        page.menu_match = "^/#{page_title}*$"
        page_cannot_be_destroyed
      end

      it 'unless you really want it to! >:]' do
        page.deletable = false
        page_cannot_be_destroyed
        page.destroy!.should be
      end
    end

    context 'page urls' do
      let(:page_path) { 'rspec-is-great-for-testing-too' }
      let(:child_path) { 'the-child-page' }
      it 'return a full path' do
        page.path.should == page_title
      end

      it 'and all of its parent page titles, reversed' do
        created_child.path.should == [page_title, child_title].join(' - ')
      end

      it 'or normally ;-)' do
        created_child.path(:reversed => false).should == [child_title, page_title].join(' - ')
      end

      it 'returns its url' do
        page.link_url = '/contact'
        page.url.should == '/contact'
      end

      it 'returns its path with marketable urls' do
        created_page.url[:id].should be_nil
        created_page.url[:path].should == [page_path]
      end

      it 'returns its path underneath its parent with marketable urls' do
        created_child.url[:id].should be_nil
        created_child.url[:path].should == [created_page.url[:path].first, child_path]
      end

      it 'no path parameter without marketable urls' do
        turn_off_marketable_urls
        created_page.url[:path].should be_nil
        created_page.url[:id].should == page_path
        turn_on_marketable_urls
      end

      it "doesn't mention its parent without marketable urls" do
        turn_off_marketable_urls
        created_child.url[:id].should == child_path
        created_child.url[:path].should be_nil
        turn_on_marketable_urls
      end

      it 'returns its path with slug set by menu_title' do
        page.menu_title = 'RSpec is great'
        page.save
        page.reload

        page.url[:id].should be_nil
        page.url[:path].should == ['rspec-is-great']
      end
    end

    context 'custom slugs' do
      let(:custom_page_slug) { 'custom-page-slug' }
      let(:custom_child_slug) { 'custom-child-slug' }
      let(:page_with_custom_slug) {
        subject.class.new(:title => page_title, :custom_slug => custom_page_slug)
      }
      let(:child_with_custom_slug) {
        page.children.new(:title => child_title, :custom_slug => custom_child_slug)
      }

      after(:each) do
        ::Refinery::I18n.stub(:current_frontend_locale).and_return(Refinery::I18n.default_frontend_locale)
        ::Refinery::I18n.current_locale = Refinery::I18n.default_locale
      end

      it 'returns its path with custom slug' do
        page_with_custom_slug.save
        page_with_custom_slug.url[:id].should be_nil
        page_with_custom_slug.url[:path].should == [custom_page_slug]
      end

      it 'returns its path underneath its parent with custom urls' do
        child_with_custom_slug.save
        page.save

        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [page.url[:path].first, custom_child_slug]
      end

      it 'returns its path with custom slug when using different locale' do
        ::Refinery::I18n.stub(:current_frontend_locale).and_return(:ru)
        ::Refinery::I18n.current_locale = :ru
        page_with_custom_slug.custom_slug = "#{custom_page_slug}-ru"
        page_with_custom_slug.save
        page_with_custom_slug.reload

        page_with_custom_slug.url[:id].should be_nil
        page_with_custom_slug.url[:path].should == ["#{custom_page_slug}-ru"]
      end

      it 'returns path underneath its parent with custom urls when using different locale' do
        ::Refinery::I18n.stub(:current_frontend_locale).and_return(:ru)
        ::Refinery::I18n.current_locale = :ru
        child_with_custom_slug.custom_slug = "#{custom_child_slug}-ru"
        child_with_custom_slug.save
        child_with_custom_slug.reload

        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [page.url[:path].first, "#{custom_child_slug}-ru"]
      end

      context "given a page with a custom_slug exists" do
        before do
          Factory(:page, :custom_slug => custom_page_slug)
        end

        it "fails validation when a new record uses that custom_slug" do
          new_page = Refinery::Page.new :custom_slug => custom_page_slug
          new_page.valid?

          new_page.errors[:custom_slug].should_not be_empty
        end
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
        page.parts.new(:title => 'body', :content => "I'm the first page part for this page.", :position => 0)
        page.parts.new(:title => 'side body', :content => 'Closely followed by the second page part.', :position => 1)
      end

      it 'return the content when using content_for' do
        page.content_for(:body).should == "<p>I'm the first page part for this page.</p>"
        page.content_for('BoDY').should == "<p>I'm the first page part for this page.</p>"
      end


      context 'when using content_for?' do

        it 'return true when page part has content' do
          page.content_for?(:body).should be_true
        end

        it 'return false when page part does not exist' do
          page.parts = []
          page.content_for?(:body).should be_false
        end

        it 'return false when page part does not have any content' do
          page.parts.first.content = ''
          page.content_for?(:body).should be_false
        end

      end
      
      it 'return all page part content' do
        page.all_page_part_content.should == "<p>I'm the first page part for this page.</p> <p>Closely followed by the second page part.</p>"
      end

      it 'reposition correctly' do
        page.save

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
