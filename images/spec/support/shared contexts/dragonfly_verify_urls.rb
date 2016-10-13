shared_context 'Dragonfly.verify_urls', value: :true_or_false do
  let(:configure_dragonfly)
    { allow(Refinery::Images).to receive(:dragonfly_verify_urls).and_return(true_or_false)
      ::Refinery::Images::Dragonfly.configure!
    }
end
