shared_examples_for 'Delete' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  def deleting_an_image
    first("#records li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
  end

  def delete_an_image
    first("#records li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
  end

  let(:image_count) { [Refinery::Image.count, Refinery::Images.pages_per_admin_index].min }

  it 'has a delete image link for each image' do
    expect(page).to have_selector('#records.images li a.delete', count: image_count)
  end


  %i(grid list).each do |view|
    init_index_view(view) do
      it "removes an image and reports the result" do
        expect(page).to have_selector(view_selector)
        expect(page).to have_selector('#records li a.delete', count: image_count)

        title = first('#records li').find(title_selector).text
        expect { deleting_an_image }.to change(Refinery::Image, :count).by(-1)
        expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: "'#{title}'"))
      end
    end
  end
end
