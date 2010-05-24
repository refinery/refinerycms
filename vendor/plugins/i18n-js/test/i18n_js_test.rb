require 'test_helper'

class I18nJSTest < ActiveSupport::TestCase
  setup do
    # Remove temporary directory if already present
    FileUtils.rm_r(Rails.root) if File.exist?(Rails.root)

    # Create temporary directory to test the files generation
    %w( config public/javascripts ).each do |path|
      FileUtils.mkdir_p Rails.root.join(path)
    end

    # Overwrite defaut locales path to use fixtures
    I18n.load_path = [File.dirname(__FILE__) + "/resources/locales.yml"]
  end

  teardown do
    # Remove temporary directory
    FileUtils.rm_r(Rails.root)
  end

  test "copy configuration file" do
    assert_equal false, File.file?(SimplesIdeias::I18n::CONFIG_FILE)
    SimplesIdeias::I18n.setup!
    assert File.file?(SimplesIdeias::I18n::CONFIG_FILE)
  end

  test "don't overwrite existing configuration file" do
    File.open(SimplesIdeias::I18n::CONFIG_FILE, "w+") {|f| f << "ORIGINAL"}
    SimplesIdeias::I18n.setup!

    assert_equal "ORIGINAL", File.read(SimplesIdeias::I18n::CONFIG_FILE)
  end

  test "copy JavaScript library" do
    path = Rails.root.join("public/javascripts/i18n.js")

    assert_equal false, File.file?(path)
    SimplesIdeias::I18n.setup!
    assert File.file?(path)
  end

  test "load configuration file" do
    SimplesIdeias::I18n.setup!

    assert SimplesIdeias::I18n.config?
    assert_kind_of HashWithIndifferentAccess, SimplesIdeias::I18n.config
    assert SimplesIdeias::I18n.config.any?
  end

  test "export messages to default path when configuration file doesn't exist" do
    SimplesIdeias::I18n.export!
    assert File.file?(Rails.root.join("public/javascripts/translations.js"))
  end

  test "export messages using the default configuration file" do
    set_config "default.yml"
    SimplesIdeias::I18n.expects(:save).with(translations, "public/javascripts/translations.js")
    SimplesIdeias::I18n.export!
  end

  test "export messages using custom output path" do
    set_config "custom_path.yml"
    SimplesIdeias::I18n.expects(:save).with(translations, "public/javascripts/translations/all.js")
    SimplesIdeias::I18n.export!
  end

  test "set default scope to * when not specified" do
    set_config "no_scope.yml"
    SimplesIdeias::I18n.expects(:save).with(translations, "public/javascripts/no_scope.js")
    SimplesIdeias::I18n.export!
  end

  test "export to multiple files" do
    set_config "multiple_files.yml"
    SimplesIdeias::I18n.export!

    assert File.file?(Rails.root.join("public/javascripts/all.js"))
    assert File.file?(Rails.root.join("public/javascripts/tudo.js"))
  end

  test "filtered translations using scope *.date.formats" do
    result = SimplesIdeias::I18n.filter(translations, "*.date.formats")
    assert_equal [:formats], result[:en][:date].keys
    assert_equal [:formats], result[:fr][:date].keys
  end

  test "filtered translations using scope [*.date.formats, *.number.currency.format]" do
    result = SimplesIdeias::I18n.scoped_translations(["*.date.formats", "*.number.currency.format"])
    assert_equal %w[ date number ], result[:en].keys.collect(&:to_s).sort
    assert_equal %w[ date number ], result[:fr].keys.collect(&:to_s).sort
  end

  test "filtered translations using multi-star scope" do
    result = SimplesIdeias::I18n.scoped_translations("*.*.formats")

    assert_equal %w[ date time ], result[:en].keys.collect(&:to_s).sort
    assert_equal %w[ date time ], result[:fr].keys.collect(&:to_s).sort

    assert_equal [:formats], result[:en][:date].keys
    assert_equal [:formats], result[:en][:time].keys

    assert_equal [:formats], result[:fr][:date].keys
    assert_equal [:formats], result[:fr][:time].keys
  end

  test "filtered translations using alternated stars" do
    result = SimplesIdeias::I18n.scoped_translations("*.admin.*.title")

    assert_equal %w[ edit show ], result[:en][:admin].keys.collect(&:to_s).sort
    assert_equal %w[ edit show ], result[:fr][:admin].keys.collect(&:to_s).sort

    assert_equal "Show", result[:en][:admin][:show][:title]
    assert_equal "Visualiser", result[:fr][:admin][:show][:title]

    assert_equal "Edit", result[:en][:admin][:edit][:title]
    assert_equal "Editer", result[:fr][:admin][:edit][:title]
  end

  test "deep merge" do
    target = {:a => {:b => 1}}
    result = SimplesIdeias::I18n.deep_merge(target, {:a => {:c => 2}})

    assert_equal result[:a], {:b => 1, :c => 2}
  end

  test "deep banged merge" do
    target = {:a => {:b => 1}}
    SimplesIdeias::I18n.deep_merge!(target, {:a => {:c => 2}})

    assert_equal target[:a], {:b => 1, :c => 2}
  end

  test "sorted hash" do
    assert_equal [:c, :a, :b], {:b => 1, :a => 2, :c => 3}.keys
    assert_equal [:a, :b, :c], SimplesIdeias::I18n.sorted_hash(:b => 1, :a => 2, :c => 3).keys
  end

  test "sorted multi-levels hash" do
    hash = {
      :foo => {:b => 1, :a => 2, :c => 3}
    }

    assert_equal [:c, :a, :b], hash[:foo].keys
    assert_equal [:a, :b, :c], SimplesIdeias::I18n.sorted_hash(hash[:foo]).keys
  end

  test "update javascript library" do
    FakeWeb.register_uri(:get, "http://github.com/fnando/i18n-js/raw/master/lib/i18n.js", :body => "UPDATED")

    SimplesIdeias::I18n.setup!
    SimplesIdeias::I18n.update!
    assert_equal "UPDATED", File.read(SimplesIdeias::I18n::JAVASCRIPT_FILE)
  end

  private
    # Set the configuration as the current one
    def set_config(path)
      config = HashWithIndifferentAccess.new(YAML.load_file(File.dirname(__FILE__) + "/resources/#{path}"))
      SimplesIdeias::I18n.expects(:config?).returns(true)
      SimplesIdeias::I18n.expects(:config).returns(config)
    end

    # Shortcut to SimplesIdeias::I18n.translations
    def translations
      SimplesIdeias::I18n.translations
    end
end
