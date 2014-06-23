require "spec_helper"

module Refinery
  module Pages
    describe SectionPresenter do
      it "can build a css class for when it is not present based on id" do
        section = SectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode')
        expect(section.not_present_css_class).to eq('no_mynode')
      end

      it "allows access to constructor arguments" do
        section = SectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode', :hidden => true)
        expect(section.fallback_html).to eq('foobar')
        expect(section.id).to eq('mynode')
        expect(section).to be_hidden
      end

      it "should be visible if not hidden" do
        section = SectionPresenter.new(:hidden => false)
        expect(section).to be_visible
      end

      it "should be not visible if hidden" do
        section = SectionPresenter.new(:hidden => true)
        expect(section).not_to be_visible
      end

      describe "when building html for a section" do
        it "wont show a hidden section" do
          section = SectionPresenter.new(:fallback_html => 'foobar', :hidden => true)
          expect(section.has_content?(true)).to be_falsey
          expect(section.wrapped_html(true)).to be_nil
        end

        it "can be hidden with the hide method" do
          section = SectionPresenter.new(:fallback_html => 'foobar')
          section.hide
          expect(section.has_content?(true)).to be_falsey
          expect(section.wrapped_html(true)).to be_nil
        end

        it "will use the specified id" do
          section = SectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode')
          expect(section.has_content?(true)).to be_truthy
          expect(section.wrapped_html(true)).to eq('<section id="mynode"><div class="inner">foobar</div></section>')
        end

        describe "if allowed to use fallback html" do
          it "wont show a section with no fallback or override" do
            section = SectionPresenter.new
            expect(section.has_content?(true)).to be_falsey
            expect(section.wrapped_html(true)).to be_nil
          end

          it "uses wrapped fallback html" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            expect(section.has_content?(true)).to be_truthy
            expect(section.wrapped_html(true)).to eq('<section><div class="inner">foobar</div></section>')
          end

          it "uses wrapped override html if present" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.override_html = 'hello world'
            expect(section.has_content?(true)).to be_truthy
            expect(section.wrapped_html(true)).to eq('<section><div class="inner">hello world</div></section>')
          end
        end

        describe "if not allowed to use fallback html" do
          it "wont show a section with no override" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            expect(section.has_content?(false)).to be_falsey
            expect(section.wrapped_html(false)).to be_nil
          end

          it "uses wrapped override html if present" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.override_html = 'hello world'
            expect(section.has_content?(false)).to be_truthy
            expect(section.wrapped_html(false)).to eq('<section><div class="inner">hello world</div></section>')
          end
        end
      end
    end
  end
end
