# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page, :type => :model do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:child_title) { 'The child page' }

    # For when we do not need the page persisted.
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}
    let(:child) { page.children.new(:title => child_title) }

    # For when we need the page persisted.
    let(:created_page) { subject.class.create!(:title => page_title, :deletable => true) }
    let(:created_child) { created_page.children.create!(:title => child_title) }

    def page_cannot_be_destroyed
      expect(page).to receive(:puts_destroy_help)
      expect(page.destroy).to eq(false)
    end

    def turn_off_marketable_urls
      allow(Pages).to receive(:marketable_urls).and_return(false)
    end

    def turn_on_marketable_urls
      allow(Pages).to receive(:marketable_urls).and_return(true)
    end

    def turn_off_slug_scoping
      allow(Pages).to receive(:scope_slug_by_parent).and_return(false)
    end

    def turn_on_slug_scoping
      allow(Pages).to receive(:scope_slug_by_parent).and_return(true)
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
        expect(page.destroy!).to be
      end

      it "even if you really want it to AND it's saved! >:]" do
        page.update_attribute(:deletable, false)
        page_cannot_be_destroyed
        expect(page.destroy!).to be
      end
    end

    context 'page urls' do
      let(:page_path) { 'rspec-is-great-for-testing-too' }
      let(:child_path) { 'the-child-page' }
      it 'return a full path' do
        expect(page.path).to eq(page_title)
      end

      it 'and all of its parent page titles, reversed' do
        expect(created_child.path).to eq([page_title, child_title].join(' - '))
      end

      it 'or normally ;-)' do
        expect(created_child.path(:reversed => false)).to eq([child_title, page_title].join(' - '))
      end

      it 'returns its url' do
        page.link_url = '/contact'
        expect(page.url).to eq('/contact')
      end

      it 'returns its path with marketable urls' do
        expect(created_page.url[:id]).to be_nil
        expect(created_page.url[:path]).to eq([page_path])
      end

      it 'returns its path underneath its parent with marketable urls' do
        expect(created_child.url[:id]).to be_nil
        expect(created_child.url[:path]).to eq([created_page.url[:path].first, child_path])
      end

      it 'no path parameter without marketable urls' do
        turn_off_marketable_urls
        expect(created_page.url[:path]).to be_nil
        expect(created_page.url[:id]).to eq(page_path)
        turn_on_marketable_urls
      end

      it "doesn't mention its parent without marketable urls" do
        turn_off_marketable_urls
        expect(created_child.url[:id]).to eq(child_path)
        expect(created_child.url[:path]).to be_nil
        turn_on_marketable_urls
      end

      it 'returns its path with slug set by menu_title' do
        page.menu_title = 'RSpec is great'
        page.save
        page.reload

        expect(page.url[:id]).to be_nil
        expect(page.url[:path]).to eq(['rspec-is-great'])
      end
    end

    context 'canonicals' do
      before do
        allow(Refinery::I18n).to receive(:default_frontend_locale).and_return(:en)
        allow(Refinery::I18n).to receive(:frontend_locales).and_return([I18n.default_frontend_locale, :ru])
        allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(I18n.default_frontend_locale)

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
          expect(page.canonical).to eq(page.url)
        end

        specify 'default canonical matches page#canonical' do
          expect(default_canonical).to eq(page.canonical)
        end

        specify 'translated page returns master page' do
          Globalize.with_locale(:ru) do
            page.title = ru_page_title
            page.save

            expect(page.canonical).to eq(default_canonical)
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
          expect(page.canonical_slug).to eq(page.slug)
        end

        specify 'default canonical_slug matches page#canonical' do
          expect(default_canonical_slug).to eq(page.canonical_slug)
        end

        specify "translated page returns master page's slug'" do
          Globalize.with_locale(:ru) do
            page.title = ru_page_title
            page.save

            expect(page.canonical_slug).to eq(default_canonical_slug)
          end
        end
      end
    end

    context 'custom slugs' do
      let(:custom_page_slug) { 'custom-page-slug' }
      let(:custom_child_slug) { 'custom-child-slug' }
      let(:custom_route) { '/products/my-product' }
      let(:custom_route_slug) { 'products/my-product' }
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
        allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(I18n.default_frontend_locale)
        allow(Refinery::I18n).to receive(:current_locale).and_return(I18n.default_locale)
      end

      it 'returns its path with custom slug' do
        page_with_custom_slug.save
        expect(page_with_custom_slug.url[:id]).to be_nil
        expect(page_with_custom_slug.url[:path]).to eq([custom_page_slug])
      end

      it 'allows a custom route when slug scoping is off' do
        turn_off_slug_scoping
        page_with_custom_route.save
        expect(page_with_custom_route.url[:id]).to be_nil
        expect(page_with_custom_route.url[:path]).to eq([custom_route_slug])
        turn_on_slug_scoping
      end

      it 'allows slashes in custom routes but slugs everything in between' do
        turn_off_slug_scoping
        page_needing_a_slugging = subject.class.new(:title => page_title, :custom_slug => 'products/category/sub category/my product is cool!')
        page_needing_a_slugging.save
        expect(page_needing_a_slugging.url[:id]).to be_nil
        expect(page_needing_a_slugging.url[:path]).to eq(['products/category/sub-category/my-product-is-cool'])
        turn_on_slug_scoping
      end

      it 'returns its path underneath its parent with custom urls' do
        child_with_custom_slug.save
        page.save

        expect(child_with_custom_slug.url[:id]).to be_nil
        expect(child_with_custom_slug.url[:path]).to eq([page.url[:path].first, custom_child_slug])
      end

      it 'does not return a path underneath its parent when scoping is off' do
        turn_off_slug_scoping
        child_with_custom_slug.save
        page.save

        expect(child_with_custom_slug.url[:id]).to be_nil
        expect(child_with_custom_slug.url[:path]).to eq([custom_child_slug])
        turn_on_slug_scoping
      end

      it "doesn't allow slashes in slug" do
        page_with_slashes_in_slug = subject.class.new(:title => page_title, :custom_slug => '/products/category')
        page_with_slashes_in_slug.save
        expect(page_with_slashes_in_slug.url[:path]).to eq(['productscategory'])
      end

      it "allow slashes in slug when slug scoping is off" do
        turn_off_slug_scoping
        page_with_slashes_in_slug = subject.class.new(:title => page_title, :custom_slug => 'products/category/subcategory')
        page_with_slashes_in_slug.save
        expect(page_with_slashes_in_slug.url[:path]).to eq(['products/category/subcategory'])
        turn_on_slug_scoping
      end

      it "strips leading and trailing slashes in slug when slug scoping is off" do
        turn_off_slug_scoping
        page_with_slashes_in_slug = subject.class.new(:title => page_title, :custom_slug => '/products/category/subcategory/')
        page_with_slashes_in_slug.save
        expect(page_with_slashes_in_slug.url[:path]).to eq(['products/category/subcategory'])
        turn_on_slug_scoping
      end

      it 'returns its path with custom slug when using different locale' do
        allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(:ru)
        allow(Refinery::I18n).to receive(:current_locale).and_return(:ru)
        page_with_custom_slug.custom_slug = "#{custom_page_slug}-ru"
        page_with_custom_slug.save
        page_with_custom_slug.reload

        expect(page_with_custom_slug.url[:id]).to be_nil
        expect(page_with_custom_slug.url[:path]).to eq(["#{custom_page_slug}-ru"])
      end

      it 'returns path underneath its parent with custom urls when using different locale' do
        allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(:ru)
        allow(Refinery::I18n).to receive(:current_locale).and_return(:ru)
        child_with_custom_slug.custom_slug = "#{custom_child_slug}-ru"
        child_with_custom_slug.save
        child_with_custom_slug.reload

        expect(child_with_custom_slug.url[:id]).to be_nil
        expect(child_with_custom_slug.url[:path]).to eq([page.url[:path].first, "#{custom_child_slug}-ru"])
      end

      context "given a page with a custom_slug exists" do
        before do
          FactoryGirl.create(:page, :custom_slug => custom_page_slug)
        end

        it "fails validation when a new record uses that custom_slug" do
          new_page = Page.new :custom_slug => custom_page_slug
          new_page.valid?

          expect(new_page.errors[:custom_slug]).not_to be_empty
        end
      end
    end

    describe "#should_generate_new_friendly_id?" do
      context "when title changes" do
        it "regenerates slug upon save" do
          page = Page.create!(:title => "Test Title")

          page.title = "Test Title 2"
          page.save!

          expect(page.slug).to eq("test-title-2")
        end
      end
    end

    context 'content sections (page parts)' do
      before do
        page.parts.new(:title => 'body', :content => "I'm the first page part for this page.", :position => 0)
        page.parts.new(:title => 'side body', :content => 'Closely followed by the second page part.', :position => 1)
      end

      it 'return the content when using content_for' do
        expect(page.content_for(:body)).to eq("<p>I'm the first page part for this page.</p>")
        expect(page.content_for('BoDY')).to eq("<p>I'm the first page part for this page.</p>")
      end

      it 'requires a unique title' do
        page.save
        page.parts.create(:title => 'body')
        duplicate_title_part = page.parts.create(:title => 'body')

        expect(duplicate_title_part.errors[:title]).to be_present
      end

      it 'only requires a unique title on the same page' do
        part_one = Page.create(:title => 'first page').parts.create(:title => 'body')
        part_two = Page.create(:title => 'second page').parts.create(:title => 'body')

        expect(part_two.errors[:title]).to be_empty
      end

      context 'when using content_for?' do

        it 'return true when page part has content' do
          expect(page.content_for?(:body)).to be_truthy
        end

        it 'return false when page part does not exist' do
          page.parts = []
          expect(page.content_for?(:body)).to be_falsey
        end

        it 'return false when page part does not have any content' do
          page.parts.first.content = ''
          expect(page.content_for?(:body)).to be_falsey
        end

      end

      it 'reposition correctly' do
        page.save

        page.parts.first.update_columns position: 6
        page.parts.last.update_columns position: 4

        expect(page.parts.first.position).to eq(6)
        expect(page.parts.last.position).to eq(4)

        page.reposition_parts!

        expect(page.parts.first.position).to eq(0)
        expect(page.parts.last.position).to eq(1)
      end
    end

    context 'draft pages' do
      it 'not live when set to draft' do
        page.draft = true
        expect(page.live?).not_to be
      end

      it 'live when not set to draft' do
        page.draft = false
        expect(page.live?).to be
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
        expect(page_with_reserved_title.url[:path]).to eq(["#{reserved_word}-page"])
      end

      it "when parent page title is set to a reserved word" do
        expect(child_with_reserved_title_parent.url[:path]).to eq(["#{reserved_word}-page", 'reserved-title-child-page'])
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
          expect(page.meta_description).to eq('This is my description of the page for search results.')
        end

        it 'browser_title' do
          page.browser_title = 'An awesome browser title for SEO'
          expect(page.browser_title).to eq('An awesome browser title for SEO')
        end
      end

      context 'allows us to update' do
        it 'meta_description' do
          page.meta_description = 'This is my description of the page for search results.'
          page.save

          page.reload
          expect(page.meta_description).to eq('This is my description of the page for search results.')
        end

        it 'browser_title' do
          page.browser_title = 'An awesome browser title for SEO'
          page.save

          page.reload
          expect(page.browser_title).to eq('An awesome browser title for SEO')
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
            expect(subject[attr]).to eq(value)
          end
        end

        it "returns the correct :url" do
          expect(subject[:url]).to be_a(Hash) # guard against nil
          expect(subject[:url]).to eq(page.url)
        end
      end

      context "with #menu_title" do
        before do
          page[:menu_title] = "Menu Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the menu_title for :title" do
          expect(subject[:title]).to eq("Menu Title")
        end
      end

      context "with #title" do
        before do
          page[:title] = "Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the title for :title" do
          expect(subject[:title]).to eq("Title")
        end
      end
    end

    describe "#in_menu?" do
      context "when live? and show_in_menu? returns true" do
        it "returns true" do
          allow(page).to receive(:live?).and_return(true)
          allow(page).to receive(:show_in_menu?).and_return(true)
          expect(page.in_menu?).to be_truthy
        end
      end

      context "when live? or show_in_menu? doesn't return true" do
        it "returns false" do
          allow(page).to receive(:live?).and_return(true)
          allow(page).to receive(:show_in_menu?).and_return(false)
          expect(page.in_menu?).to be_falsey

          allow(page).to receive(:live?).and_return(false)
          allow(page).to receive(:show_in_menu?).and_return(true)
          expect(page.in_menu?).to be_falsey
        end
      end
    end

    describe "#not_in_menu?" do
      context "when in_menu? returns true" do
        it "returns false" do
          allow(page).to receive(:in_menu?).and_return(true)
          expect(page.not_in_menu?).to be_falsey
        end
      end

      context "when in_menu? returns false" do
        it "returns true" do
          allow(page).to receive(:in_menu?).and_return(false)
          expect(page.not_in_menu?).to be_truthy
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
        expect(Page.find_by_path('/about')).to eq(created_root_about)
      end

      it "should return child about page when looking for '/team/about'" do
        expect(Page.find_by_path('/team/about')).to eq(created_child)
      end
    end

    describe ".find_by_path_or_id" do
      let!(:market) { FactoryGirl.create(:page, :title => "market") }
      let(:path) { "market" }
      let(:id) { market.id }

      context "when path param is present" do
        context "when path is friendly_id" do
          it "finds page using path" do
            expect(Page.find_by_path_or_id(path, "")).to eq(market)
          end
        end

        context "when path is not friendly_id" do
          it "finds page using id" do
            expect(Page.find_by_path_or_id(id, "")).to eq(market)
          end
        end
      end

      context "when id param is present" do
        it "finds page using id" do
          expect(Page.find_by_path_or_id("", id)).to eq(market)
        end
      end
    end

    describe ".find_by_path_or_id!" do
      it "delegates to find_by_path_or_id" do
        lambda do
          expect(Page).to receive(:find_by_path_or_id).with("path", "id")
          Page.find_by_path_or_id!("path", "id")
        end
      end

      it "throws exception when page isn't found" do
        expect { Page.find_by_path_or_id!("not", "here") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "#deletable?" do
      let(:deletable_page) do
        page.deletable  = true
        page.link_url   = ""
        page.menu_match = ""
        allow(page).to receive(:puts_destroy_help).and_return('')
        page
      end

      context "when deletable is true and link_url, and menu_match is blank" do
        it "returns true" do
          expect(deletable_page.deletable?).to be_truthy
        end
      end

      context "when deletable is false and link_url, and menu_match is blank" do
        it "returns false" do
          deletable_page.deletable = false
          expect(deletable_page.deletable?).to be_falsey
        end
      end

      context "when deletable is false and link_url or menu_match isn't blank" do
        it "returns false" do
          deletable_page.deletable  = false
          deletable_page.link_url   = "text"
          expect(deletable_page.deletable?).to be_falsey

          deletable_page.menu_match = "text"
          expect(deletable_page.deletable?).to be_falsey
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
        expect(page).to receive(:puts_destroy_help)

        page.destroy
      end
    end
  end
end
