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

    def turn_on_custom_slugs
      allow(Pages).to receive(:use_custom_slugs).and_return(true)
    end

    def turn_off_custom_slugs
      allow(Pages).to receive(:use_custom_slugs).and_return(false)
    end

    context 'page urls' do
      let(:page_path) { 'rspec-is-great-for-testing-too' }
      let(:child_path) { 'the-child-page' }
      it 'return a full path' do
        expect(page.path).to eq(page_title)
      end

      it 'and all of its parent page titles, ancestors first' do
        expect(created_child.path).to eq([page_title, child_title].join(' - '))
      end

      it 'or normally ;-)' do
        expect(created_child.path(ancestors_first: false)).to eq([child_title, page_title].join(' - '))
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

        specify "translated page returns its pages's canonical"  do
          allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(:ru)

          Globalize.with_locale(:ru) do
            page.title = ru_page_title
            page.save

            expect(page.canonical).to_not eq(default_canonical)
            expect(page.canonical).to eq(page.url)
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

        specify "translated page returns its page's canonical slug'" do
          allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(:ru)

          Globalize.with_locale(:ru) do
            page.title = ru_page_title
            page.save

            expect(page.canonical_slug).to_not eq(default_canonical_slug)
            expect(page.canonical_slug).to eq(page.canonical_slug)
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
      before do
        turn_on_custom_slugs
      end

      after(:each) do
        turn_off_custom_slugs
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

      it 'correctly assigns slug when custom_slug updates.' do
        page_without_custom_slug = subject.class.create(:title => page_title)
        page_without_custom_slug.custom_slug = custom_page_slug
        expect {
          page_without_custom_slug.save
        }.to change(page_without_custom_slug, :slug).to(custom_page_slug)
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
      let(:reserved_word) { subject.class.friendly_id_config.reserved_words.sample }
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
  end
end
