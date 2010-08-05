Given /^I have no images$/ do
  Image.delete_all
end

Given /^I have test image titled "([^"]*)"$/ do |file_name|
  Image.create(:image_mime_type => 'image/jpeg', :image_name => file_name, :image_size => 5000)
end

When /^I attach the image at "([^"]*)"$/ do |file_path|
  attach_file('image[uploaded_data]', File.join(Rails.root, file_path))
end

Then /^the image "([^"]*)" should have uploaded successfully$/ do |file_name|
  Image.find_by_image_name(file_name).nil?.should == false
end

Then /^I should have the correct default number of images$/ do
  image_number = RefinerySetting['image_thumbnails'].length
  Image.count.should == image_number + 1
end

Then /^the image should have size "([^"]*)"$/ do |size|
  Image.first.size.should == size.to_i
end

Then /^the image should have width "([^"]*)"$/ do |width|
  Image.first.width.should == width.to_i
end

Then /^the image should have height "([^"]*)"$/ do |height|
  Image.first.height.should == height.to_i
end

Then /^the image should have mime_type "([^"]*)"$/ do |mime_type|
  Image.first.mime_type.should == mime_type.to_s
end

Then /^the image should have all default thumbnail generations$/ do
  parent_id = Image.first.id
  Image.find_all_by_parent_id(parent_id).each do |image|
    RefinerySetting['image_thumbnails'].has_key?(image.thumbnail.to_sym).should == true
  end
end

Then /^I should have ([0-9]+) images?$/ do |number|
  Image.count.should == number.to_i
end
