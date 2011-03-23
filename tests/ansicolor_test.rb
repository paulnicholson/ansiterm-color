#!/usr/bin/env ruby

require 'test/unit'
require 'ansiterm/color'

class String
  include ANSITerm::Color
end

class Color
  extend ANSITerm::Color
end

class ANSIColorTest < Test::Unit::TestCase
  include ANSITerm::Color

  def setup
    @string = "red"
    @string_red = "\e[31mred\e[0m"
    @string_red_on_green = "\e[42m\e[31mred\e[0m\e[0m"
  end

  attr_reader :string, :string_red, :string_red_on_green

  def test_red
    assert_equal string_red, string.red
    assert_equal string_red, Color.red(string)
    assert_equal string_red, Color.red { string }
    assert_equal string_red, ANSITerm::Color.red { string }
    assert_equal string_red, red { string }
  end

  def test_red_on_green
    assert_equal string_red_on_green, string.red.on_green
    assert_equal string_red_on_green, Color.on_green(Color.red(string))
    assert_equal string_red_on_green, Color.on_green { Color.red { string } }
    assert_equal string_red_on_green,
      ANSITerm::Color.on_green { ANSITerm::Color.red { string } }
    assert_equal string_red_on_green, on_green { red { string } }
  end


  def test_uncolored
    assert_equal string, string_red.uncolored
    assert_equal string, Color.uncolored(string_red)
    assert_equal string, Color.uncolored { string_red }
    assert_equal string, ANSITerm::Color.uncolored { string_red }
    assert_equal string, uncolored { string }
  end

  def test_attributes
    foo = 'foo'
    for (a, _) in ANSITerm::Color.attributes
      assert_not_equal foo, foo_colored = foo.__send__(a)
      assert_equal foo, foo_colored.uncolored
      assert_not_equal foo, foo_colored = Color.__send__(a, foo)
      assert_equal foo, Color.uncolored(foo_colored)
      assert_not_equal foo, foo_colored = Color.__send__(a) { foo }
      assert_equal foo, Color.uncolored { foo_colored }
      assert_not_equal foo, foo_colored = ANSITerm::Color.__send__(a) { foo }
      assert_equal foo, ANSITerm::Color.uncolored { foo_colored }
      assert_not_equal foo, foo_colored = __send__(a) { foo }
      assert_equal foo, uncolored { foo }
    end
  end
end
