module BeanCatalog
  class << self

    def fetch_current_catalog(provider)
      source_catalog.get_list(provider: provider)
    end

    private

    def source_catalog
      LegacyBeanCatalogService
    end
  end
end
