# encoding: utf-8
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
      page.should_receive(:puts_destroy_help)
      page.destroy.should == false
    end

    def turn_off_marketable_urls
      Pages.stub(:marketable_urls).and_return(false)
    end

    def turn_on_marketable_urls
      Pages.stub(:marketable_urls).and_return(true)
    end

    def turn_off_slug_scoping
      Pages.stub(:scope_slug_by_parent).and_return(false)
    end

    def turn_on_slug_scoping
      Pages.stub(:scope_slug_by_parent).and_return(true)
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

    context 'canonicals' do
      before do
        Refinery::I18n.stub(:default_frontend_locale).and_return(:en)
        Refinery::I18n.stub(:frontend_locales).and_return([I18n.default_frontend_locale, :ru])
        Refinery::I18n.stub(:current_frontend_locale).and_return(I18n.default_frontend_locale)

        page.save
      end
      let(:page_title)  { 'team' }
      let(:child_title) { 'about' }
      let(:ru_page_title) { 'Новости' }

      describe '#canonical' do
        let!(:default_canonical) {
          Globalize.with_locale(Refinery::I18n.default_frontend_locale) {
            page.canonical
          }
        }

        specify 'page returns itself' do
          page.canonical.should == page.url
        end

        specify 'default canonical matches page#canonical' do
          default_canonical.should == page.canonical
        end

        specify 'translated page returns master page' do
          Globalize.with_locale(:ru) do
            page.title = ru_page_title
            page.save

            page.canonical.should == default_canonical
          end
        end
      end

      describe '#canonical_slug' do
        let!(:default_canonical_slug) {
          Globalize.with_locale(Refinery::I18n.default_frontend_locale) {
            page.canonical_slug
          }
        }
        specify 'page returns its own slug' do
          page.canonical_slug.should == page.slug
        end

        specify 'default canonical_slug matches page#canonical' do
          default_canonical_slug.should == page.canonical_slug
        end

        specify "translated page returns master page's slug'" do
          Globalize.with_locale(:ru) do
            page.title = ru_page_title
            page.save

            page.canonical_slug.should == default_canonical_slug
          end
        end
      end
    end

    context 'custom slugs' do
      let(:custom_page_slug) { 'custom-page-slug' }
      let(:custom_child_slug) { 'custom-child-slug' }
      let(:custom_route) { '/products/my-product' }
      let(:page_with_custom_slug) {
        subject.class.new(:title => page_title, :custom_slug => custom_page_slug)
      }
      let(:child_with_custom_slug) {
        page.children.new(:title => child_title, :custom_slug => custom_child_slug)
      }
      let(:page_with_custom_route) {
        subject.class.new(:title => page_title, :custom_slug => custom_route)
      }

      after(:each) do
        Refinery::I18n.stub(:current_frontend_locale).and_return(I18n.default_frontend_locale)
        Refinery::I18n.stub(:current_locale).and_return(I18n.default_locale)
      end

      it 'returns its path with custom slug' do
        page_with_custom_slug.save
        page_with_custom_slug.url[:id].should be_nil
        page_with_custom_slug.url[:path].should == [custom_page_slug]
      end

      it 'allows a custom route when slug scoping is off' do
        turn_off_slug_scoping
        page_with_custom_route.save
        page_with_custom_route.url[:id].should be_nil
        page_with_custom_route.url[:path].should == [custom_route]
        turn_on_slug_scoping
      end

      it 'allows slashes in custom routes but slugs everything in between' do
        turn_off_slug_scoping
        page_needing_a_slugging = subject.class.new(:title => page_title, :custom_slug => 'products/category/sub category/my product is cool!')
        page_needing_a_slugging.save
        page_needing_a_slugging.url[:id].should be_nil
        page_needing_a_slugging.url[:path].should == ['products/category/sub-category/my-product-is-cool']
        turn_on_slug_scoping
      end

      it 'returns its path underneath its parent with custom urls' do
        child_with_custom_slug.save
        page.save

        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [page.url[:path].first, custom_child_slug]
      end

      it 'does not return a path underneath its parent when scoping is off' do
        turn_off_slug_scoping
        child_with_custom_slug.save
        page.save

        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [custom_child_slug]
        turn_on_slug_scoping
      end

      it "doesn't allow slashes in slug" do
        page_with_slashes_in_slug = subject.class.new(:title => page_title, :custom_slug => '/products/category')
        page_with_slashes_in_slug.save
        page_with_slashes_in_slug.url[:path].should == ['productscategory']
      end

      it "allow slashes in slug when slug scoping is off" do
        turn_off_slug_scoping
        page_with_slashes_in_slug = subject.class.new(:title => page_title, :custom_slug => 'products/category/subcategory')
        page_with_slashes_in_slug.save
        page_with_slashes_in_slug.url[:path].should == ['products/category/subcategory']
        turn_on_slug_scoping
      end

      it "strips leading and trailing slashes in slug when slug scoping is off" do
        turn_off_slug_scoping
        page_with_slashes_in_slug = subject.class.new(:title => page_title, :custom_slug => '/products/category/subcategory/')
        page_with_slashes_in_slug.save
        page_with_slashes_in_slug.url[:path].should == ['products/category/subcategory']
        turn_on_slug_scoping
      end

      it 'returns its path with custom slug when using different locale' do
        Refinery::I18n.stub(:current_frontend_locale).and_return(:ru)
        Refinery::I18n.stub(:current_locale).and_return(:ru)
        page_with_custom_slug.custom_slug = "#{custom_page_slug}-ru"
        page_with_custom_slug.save
        page_with_custom_slug.reload

        page_with_custom_slug.url[:id].should be_nil
        page_with_custom_slug.url[:path].should == ["#{custom_page_slug}-ru"]
      end

      it 'returns path underneath its parent with custom urls when using different locale' do
        Refinery::I18n.stub(:current_frontend_locale).and_return(:ru)
        Refinery::I18n.stub(:current_locale).and_return(:ru)
        child_with_custom_slug.custom_slug = "#{custom_child_slug}-ru"
        child_with_custom_slug.save
        child_with_custom_slug.reload

        child_with_custom_slug.url[:id].should be_nil
        child_with_custom_slug.url[:path].should == [page.url[:path].first, "#{custom_child_slug}-ru"]
      end

      context "given a page with a custom_slug exists" do
        before do
          FactoryGirl.create(:page, :custom_slug => custom_page_slug)
        end

        it "fails validation when a new record uses that custom_slug" do
          new_page = Page.new :custom_slug => custom_page_slug
          new_page.valid?

          new_page.errors[:custom_slug].should_not be_empty
        end
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

      it 'requires a unique title' do
        page.save
        page.parts.create(:title => 'body')
        duplicate_title_part = page.parts.create(:title => 'body')

        duplicate_title_part.errors[:title].should be_present
      end

      it 'only requires a unique title on the same page' do
        part_one = Page.create(:title => 'first page').parts.create(:title => 'body')
        part_two = Page.create(:title => 'second page').parts.create(:title => 'body')

        part_two.errors[:title].should be_empty
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

      it 'reposition correctly' do
        page.save

        page.parts.first.update_attributes :position => 6
        page.parts.last.update_attributes :position => 4

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
        it 'meta_description' do
          page.respond_to?(:meta_description)
        end

        it 'browser_title' do
          page.respond_to?(:browser_title)
        end
      end

      context 'allows us to assign to' do
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
        Page.new(
          :id => 5,
          :parent_id => 8,
          :menu_match => "^/foo$"

        # Page does not allow setting lft and rgt, so stub them.
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

    describe "#in_menu?" do
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

    describe "#not_in_menu?" do
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

    describe '.find_by_path' do
      let(:page_title)  { 'team' }
      let(:child_title) { 'about' }
      let(:created_root_about) { subject.class.create!(:title => child_title, :deletable => true) }

      before do
        # Ensure pages are created.
        created_child
        created_root_about
      end

      it "should return (root) about page when looking for '/about'" do
        Page.find_by_path('/about').should == created_root_about
      end

      it "should return child about page when looking for '/team/about'" do
        Page.find_by_path('/team/about').should == created_child
      end
    end

    describe ".find_by_path_or_id" do
      let!(:market) { FactoryGirl.create(:page, :title => "market") }
      let(:path) { "market" }
      let(:id) { market.id }

      context "when path param is present" do
        context "when path is friendly_id" do
          it "finds page using path" do
            Page.find_by_path_or_id(path, "").should eq(market)
          end
        end

        context "when path is not friendly_id" do
          it "finds page using id" do
            Page.find_by_path_or_id(id, "").should eq(market)
          end
        end
      end

      context "when id param is present" do
        it "finds page using id" do
          Page.find_by_path_or_id("", id).should eq(market)
        end
      end
    end

    describe "#deletable?" do
      let(:deletable_page) do
        page.deletable  = true
        page.link_url   = ""
        page.menu_match = ""
        page.stub(:puts_destroy_help).and_return('')
        page
      end

      context "when deletable is true and link_url, and menu_match is blank" do
        it "returns true" do
          deletable_page.deletable?.should be_true
        end
      end

      context "when deletable is false and link_url, and menu_match is blank" do
        it "returns false" do
          deletable_page.deletable = false
          deletable_page.deletable?.should be_false
        end
      end

      context "when deletable is false and link_url or menu_match isn't blank" do
        it "returns false" do
          deletable_page.deletable  = false
          deletable_page.link_url   = "text"
          deletable_page.deletable?.should be_false

          deletable_page.menu_match = "text"
          deletable_page.deletable?.should be_false
        end
      end
    end

    describe "#destroy" do
      before do
        page.deletable  = false
        page.link_url   = "link_url"
        page.menu_match = "menu_match"
        page.save!
      end

      it "shows message" do
        page.should_receive(:puts_destroy_help)

        page.destroy
      end
    end

    describe ".for_site" do
      let(:site1) { create(:site) }
      let(:site2) { create(:site) }
      let(:common_page) { create(:page, :title => 'common') }
      let(:site1_page)  { create(:page, :title => 'site 1', :site => site1) }
      let(:site2_page)  { create(:page, :title => 'site 2', :site => site2) }

      before do
        common_page
        site1_page
        site2_page
      end

      it "returns common pages when no site specified" do
        Page.for_site.should eq [common_page]
      end

      it "includes pages for site specified" do
        Page.for_site(site1.id).should include site1_page
      end

      it "does not include pages for other sites" do
        Page.for_site(site1.id).should_not include site2_page
      end
    end
  end
end
