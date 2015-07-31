require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/engine/engine_generator'

module Refinery
  describe EngineGenerator do
    include GeneratorSpec::TestCase

    it "exits when reserved word is used for extension name" do
      clash_keywords = YAML.load_file(File.expand_path("../../../../../../lib/generators/refinery/clash_keywords.yml", __FILE__))
      clash_keywords.each do |word|
        expect {
          expect(STDERR).to receive(:puts).with("\nPlease choose a different name. The generated code would fail for class '#{word}' as it conflicts with a reserved keyword.\n\n")
          run_generator [word, "title:string"]
        }.to raise_error(SystemExit)
      end
    end

    it "exits when plural word is used for extension name" do
      expect {
        expect(STDERR).to receive(:puts).with("\nPlease specify the singular name 'apple' instead of 'apples'.\n\n")
        run_generator %w{ apples title:string }
      }.to raise_error(SystemExit)
    end

    it "exits when uncountable word is used for extension name" do
      expect {
        expect(STDERR).to receive(:puts).with("\nThe extension name you specified will not work as the singular name is equal to the plural name.\n\n")
        run_generator %w{ money title:string }
      }.to raise_error(SystemExit)
    end

    it "exits when no attribute provided" do
      expect {
        expect(STDERR).to receive(:puts).with("\nYou must specify a name and at least one field.\nFor help, run: rails generate refinery:engine\n\n")
        run_generator %w{ car }
      }.to raise_error(SystemExit)
    end

    it "exits when '--extension' option is used but there is no extension by provided name" do
      expect {
        expect(STDERR).to receive(:puts).with("\nYou can't use '--extension nonexistent' because an extension with the name 'nonexistent' doesn't exist.\n\n")
        run_generator %w{ car title:string --extension nonexistent }
      }.to raise_error(SystemExit)
    end
  end
end
