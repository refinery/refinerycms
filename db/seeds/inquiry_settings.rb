InquirySetting.create(:name => "Confirmation Body", :value => "Thank you for your inquiry %name%,\n\nThis email is a receipt to confirm we have received your inquiry and we'll be in touch shortly.\n\nThanks.", :destroyable => false)
InquirySetting.create(:name => "Notification Recipients", :value => "", :destroyable => false)
