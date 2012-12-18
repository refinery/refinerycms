require "spec_helper"

module Refinery
  module Pages
    describe SectionPresenter do
      it "can build a css class for when it is not present based on id" do
        section = SectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode')
        section.not_present_css_class.should == 'no_mynode'
      end

      it "allows access to constructor arguments" do
        section = SectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode', :hidden => true)
        section.fallback_html.should == 'foobar'
        section.id.should == 'mynode'
        section.should be_hidden
      end

      it "should be visible if not hidden" do
        section = SectionPresenter.new(:hidden => false)
        section.should be_visible
      end

      it "should be not visible if hidden" do
        section = SectionPresenter.new(:hidden => true)
        section.should_not be_visible
      end

      describe "when building html for a section" do
        it "wont show a hidden section" do
          section = SectionPresenter.new(:fallback_html => 'foobar', :hidden => true)
          section.has_content?(true).should be_false
          section.wrapped_html(true).should be_nil
        end

        it "can be hidden with the hide method" do
          section = SectionPresenter.new(:fallback_html => 'foobar')
          section.hide
          section.has_content?(true).should be_false
          section.wrapped_html(true).should be_nil
        end

        it "will use the specified id" do
          section = SectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode')
          section.has_content?(true).should be_true
          section.wrapped_html(true).should == '<section id="mynode"><div class="inner">foobar</div></section>'
        end

        describe "if allowed to use fallback html" do
          it "wont show a section with no fallback or override" do
            section = SectionPresenter.new
            section.has_content?(true).should be_false
            section.wrapped_html(true).should be_nil
          end

          it "uses wrapped fallback html" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.has_content?(true).should be_true
            section.wrapped_html(true).should == '<section><div class="inner">foobar</div></section>'
          end

          it "uses wrapped override html if present" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.override_html = 'hello world'
            section.has_content?(true).should be_true
            section.wrapped_html(true).should == '<section><div class="inner">hello world</div></section>'
          end
        end

        describe "if not allowed to use fallback html" do
          it "wont show a section with no override" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.has_content?(false).should be_false
            section.wrapped_html(false).should be_nil
          end

          it "uses wrapped override html if present" do
            section = SectionPresenter.new(:fallback_html => 'foobar')
            section.override_html = 'hello world'
            section.has_content?(false).should be_true
            section.wrapped_html(false).should == '<section><div class="inner">hello world</div></section>'
          end
        end
      end
    end
  end
end
