require 'spec_helper'


describe SitemapController do
  login_refinery_user

  before (:each) do
    @request.env['HTTP_ACCEPT'] = 'application/xml'
  end

  it "should show a valid xml answer with i18n enabled" do
    ::Refinery.should_receive(:i18n_enabled?).and_return(true)

    get :index

    response.should be_success
  end

  it "should show a valid xml answer with i18n disabled" do
    ::Refinery.should_receive(:i18n_enabled?).and_return(false)

    get :index

    response.should be_success
  end

end
