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
        before do
          @errors = StringIO.new
          @old_err = $stderr
          $stderr = @errors
        end

        after(:each) { $stderr = @old_err }

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
          expect(section.wrapped_html(true)).to xml_eq('<section id="mynode"><div class="inner">foobar</div></section>')
        end

        # Regression tests for https://github.com/refinery/refinerycms-inquiries/issues/168
        describe "#whitelist_elements" do
          context "when an element is not in a whitelist" do
            it "will not return those elements" do
              allow(Refinery::Pages).to receive(:whitelist_elements) {%w()}
              section = SectionPresenter.new
              section.override_html = %Q{<dummy></dummy>}
              expect(section.wrapped_html(true)).to xml_eq(
                %Q{<section><div class="inner"></div></section>}
              )
            end
          end

          context "when an extra element is included in the whitelist" do
            it "will contain the whitelisted element" do
              allow(Refinery::Pages).to receive(:whitelist_elements) {%w(dummy)}
              section = SectionPresenter.new
              section.override_html = %Q{<dummy></dummy>}
              expect(section.wrapped_html(true)).to xml_eq(
                %Q{<section><div class="inner"><dummy></dummy></div></section>}
              )
            end
          end
        end

        describe "#whitelist_attributes" do
          context "when an attribute is not in a whitelist" do
            it "will not return those attributes" do
              allow(Refinery::Pages).to receive(:whitelist_attributes) {%w()}
              section = SectionPresenter.new
              section.override_html = %Q{<a attribute="value"></a>}
              expect(section.wrapped_html(true)).to xml_eq(
                %Q{<section><div class="inner"><a></a></div></section>}
              )
            end
          end

          context "when extra attributes are included in the whitelist" do
            it "will contain the whitelisted attributes" do
              allow(Refinery::Pages).to receive(:whitelist_attributes) {%w(attribute)}
              section = SectionPresenter.new
              section.override_html = %Q{<a attribute="value"></a>}
              expect(section.wrapped_html(true)).to xml_eq(
                %Q{<section><div class="inner"><a attribute="value"></a></div></section>}
              )
            end
          end

          context 'data attributes' do
            it 'all data attributes passed thru' do
              section = SectionPresenter.new
              section.override_html = %Q{<a data-foo-bar="value"></a>}
              expect(section.wrapped_html(true)).to xml_eq(
                  %Q{<section><div class="inner"><a data-foo-bar="value"></a></div></section>}
              )
            end
          end
        end

        describe "#sanitize_content" do
          let(:warning) do
            %Q{\n-- SANITIZED CONTENT WARNING --\nRefinery::Pages::SectionPresenter#wrap_content_in_tag\nHTML attributes and/or elements content has been sanitized\n\e[31m-<dummy></dummy>\e[0m\n\\ No newline at end of file\n\n}
          end

          it "shows a sanitized content warning" do
            expect(Rails.logger).to receive(:warn).with(warning)
            section = SectionPresenter.new
            section.override_html = %Q{<dummy></dummy>}
            section.wrapped_html(true)
          end

          it "accepts a custom logger" do
            logger = spy(:logger, warn: true)
            SectionPresenter.new(logger: logger).tap do |presenter|
              presenter.override_html = %Q{<dummy></dummy>}
              presenter.wrapped_html(true)
            end
            expect(logger).to have_received(:warn).with(warning)
          end
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
            expect(section.wrapped_html(true)).to xml_eq('<section><div class="inner">foobar</div></section>')
          end

          it "uses wrapped override html if present" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.override_html = 'hello world'
            expect(section.has_content?(true)).to be_truthy
            expect(section.wrapped_html(true)).to xml_eq('<section><div class="inner">hello world</div></section>')
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
            expect(section.wrapped_html(false)).to xml_eq('<section><div class="inner">hello world</div></section>')
          end
        end
      end
    end
  end
end
