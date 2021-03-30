module BeanCatalog
  class << self

    def fetch_current_catalog(provider)
      source_catalog.get_list(provider: provider)
    end

    # Don't forget - this is a contrived example!
    def get_doubled_normalised_price(price_as_integer)

      # The key point here is that people often write the
      # "€#{price_as_integer * 2}.00" when developing initially.
      #
      # Then tag on "if price_as_integer > 0" and quickly move on.
      #
      # The foolishness of this is easy to see here - but in more
      # complex examples it can go unnoticed.
      #
      "€#{price_as_integer * 2}.00" if price_as_integer > 0
    end

    # Even to consider being explict about nil here is better
    # IMO than above...
    def get_doubled_normalised_price_again(price_as_integer)
      if price_as_integer > 0
        "€#{price_as_integer * 2}.00"
      else
        nil
      end
    end

    # Now, let's fix it!
    def get_doubled_normalised_price_yet_again(price_as_integer)
      # Yes, there are many ways to fix this better - it's just an example :-)
      if price_as_integer >= 0
        "€#{price_as_integer * 2}.00"
      else
        "-€#{price_as_integer.abs * 2}.00"
      end
    end

    def what_is_my_economic_status(savings_as_integer)
      case savings_as_integer
      when 0 then "Not great!"
      when 1 then "You can afford something on the Eurosaver menu!"
      when 2 then "Things are looking good. Nearly new Tesla territory!"
      when (3..) # Bonus Tip: Infinite ranges
        # See https://developer.squareup.com/blog/rubys-new-infinite-range-syntax-0/
        # and https://www.rubyguides.com/2019/07/ruby-infinity/
        # for more on infinite ranges and alternatives to them
        need_to_lookup_my_webservice_for_rich_people(savings_as_integer)
        # ^ I added this requirement because I anticipated you saying that I should
        # just use a hash lookup instead of a case statement ;-) And, ya, I still could
        # do that if I used lambdas, but life is too short!
      else
        raise ArgumentError, "Expected positive integer but got #{savings_as_integer}"
      end
    end

    private

    def source_catalog
      LegacyBeanCatalogService
    end

    def need_to_lookup_my_webservice_for_rich_people(savings_as_integer)
      "Yup - you are #{"€" * savings_as_integer} rich :-)"
    end
  end
end
