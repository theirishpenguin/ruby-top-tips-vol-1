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
  # Tip found at https://github.com/rspec/rspec-mocks/issues/707#issuecomment-45551846
  #
  it "should call remote service to fetch data (debuggable example)" do
    # Expect
    expect(LegacyBeanCatalogService)
     .to receive(:get_list)
     .with(hash_including(colour: 'blue'))

    # Uncomment this to see what went wrong
    # expect(LegacyBeanCatalogService)
    #   .to receive(:get_list) do |*args|
    #     require 'byebug' ; debugger
    #     # You can even check simple asserts in here, such as...
    #     expect(args[0][:provider]).to eql("3fe")
    #   end

    # Verify
    BeanCatalog.fetch_current_catalog('3fe')
  end

  context "with a conventional test string" do
    # Okay, this next bit has nothing to do with beans :-)
    # It's just a gentle introduction to a regex example before
    # Top Tip 3 below!

    let(:test_string) do
      "This is a great meetup. And it's cool that its online, eh?" \
        "One of my favourite domains is http://www.rubyireland.com"
    end

    let(:regexp_as_string) { '.*\s(\w*)\smeetup.*(http.*)' }
    let(:regexp) { Regexp.new(regexp_as_string) }

    it "should capture how good the meeting was and the url" do
      the_match = regexp.match(test_string)
      expect(the_match[1]).to eql("great")
      expect(the_match[2]).to eql("http://www.rubyireland.com")
    end
  end

  # Top Tip 3: Escape complex phrases in regular expressions.
  #
  # With thanks to https://www.geeksforgeeks.org/ruby-regexp-escape-function/
  #
  context "with a tricky test string" do
    # Okay, how the hell would you normally use phrases that need a
    # lot of escaping in a regex? Regexp.escape() to the rescue!

    let(:test_string) do
      '.*\s(\w*)\smeetup.*(http.*)gotcha mister'
    end

    let(:regexp_as_string) do
      # Here's the good bit! Getting the literal respresenation of the
      # highly punctuated start of the target...
      #
      "#{Regexp.escape('.*\s(\w*)\smeetup.*(http.*)')}gotcha\s(.*)"

      # Note: If you wanted to do the escaped part yourself it would be...
      #
      # "\\.\\*\\\\s\\(\\\\w\\*\\)\\\\smeetup\\.\\*\\(http\\.\\*\\)"
      #
      # There may be a simpler single quoted string version - still
      # more work than using Regexp.escape()
    end

    let(:regexp) { Regexp.new(regexp_as_string) }

    it "should capture the saluation at the end of the string" do
      the_match = regexp.match(test_string)
      expect(the_match[1]).to eql("mister")
    end
  end
end
