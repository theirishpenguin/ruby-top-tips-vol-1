require 'spec_helper'

require_relative '../../lib/bean_catalog'
require_relative '../../lib/legacy_bean_catalog_service'

RSpec.describe BeanCatalog, type: :model do
  # Top Tip 1: Use hash_including() to ensure we call the service with the right "shape"
  #
  # This page on setting constraints on expectations in rspec is really valuable
  # https://relishapp.com/rspec/rspec-mocks/docs/setting-constraints/matching-arguments
  #
  # This test should pass...
  it "should call remote service to fetch data (passing example)" do
    # Expect
    expect(LegacyBeanCatalogService)
     .to receive(:get_list)
     .with(hash_including(provider: '3fe'))

    # Verify
    BeanCatalog.fetch_current_catalog('3fe')
  end

  # This is similar to the last example but should fail...
  it "should call remote service to fetch data (failing example)" do
    # Expect
    expect(LegacyBeanCatalogService)
     .to receive(:get_list)
     .with(hash_including(colour: 'blue'))

    # Verify
    BeanCatalog.fetch_current_catalog('3fe')
    #
    # ^^^ This should fail with...
    #
    # LegacyBeanCatalogService received :get_list with unexpected arguments
    #  expected: (hash_including(:colour=>"blue"))
    #  got: ({:provider=>"3fe"})
    #
    #  Diff:
    #  @@ -1 +1 @@
    #  -["hash_including(:colour=>\"blue\")"]
    #  +[{:provider=>"3fe"}]
  end

  # Top Tip 2: Use a receive() with a block to debug the arguments.
  #
  # The arguments this example is a simple hash, but imagine if it was a large
  # complex deeply nested hash. Being able to capture exactly what is going on
  # in the call and debug it is much better than "guessing" levels of nesting,
  # whether we are dealing with symbols or strings as keys, etc
  #
  it "should call remote service to fetch data (debuggable example)" do
    # Expect
    expect(LegacyBeanCatalogService)
     .to receive(:get_list)
     .with(hash_including(colour: 'blue'))

    # Uncomment this to see what went wrong
    expect(LegacyBeanCatalogService)
      .to receive(:get_list) do |*args|
        require 'byebug' ; debugger
        # You can even check simple asserts in here, such as...
        expect(args[0][:provider]).to eql("3fe")
      end

    # Verify
    BeanCatalog.fetch_current_catalog('3fe')
  end

end
