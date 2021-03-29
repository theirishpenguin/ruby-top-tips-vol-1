module LegacyBeanCatalogService
  class << self

    def get_list(options)
      provider = options[:provider]

      {
        data: [
          {
            roaster: '3fe',
            origin: 'Caturra',
            taste: 'Lime notes'
          },
          {
            roaster: 'cloudpicker',
            origin: 'Brazil',
            taste: 'Chocolate brownie'
          }
        ]
      }[provider]
    end

  end
end
