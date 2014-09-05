# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:child_title) { 'The child page' }

    # For when we do not need the page persisted.
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}

    # For when we need the page persisted.
    let(:created_page) { subject.class.create!(:title => page_title, :deletable => true) }
    let(:created_child) { created_page.children.create!(:title => child_title) }

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
        page_with_custom_route.url[:path].should == [custom_route_slug]
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
  end
end
