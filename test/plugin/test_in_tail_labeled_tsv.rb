require 'fluent/test'
require 'fluent/plugin/in_tail'
require 'fluent/plugin/in_tail_labeled_tsv'

class TailLabeledTSVInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    FileUtils.rm_rf(TMP_DIR)
    FileUtils.mkdir_p(TMP_DIR)
  end

  TMP_DIR = File.dirname(__FILE__) + "/../tmp"

  CONFIG = %[
    path #{TMP_DIR}/tail.txt
    tag t1
    rotate_wait 2s
    pos_file #{TMP_DIR}/tail.pos
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::TailLabeledTSVInput).configure(conf)
  end

  def test_emit
    File.open("#{TMP_DIR}/tail.txt", "w") {|f|
      f.puts "test1_a	test1_b"
      f.puts "test2"
    }

    d = create_driver

    d.run do
      sleep 1

      File.open("#{TMP_DIR}/tail.txt", "a") {|f|
        f.puts "test3_a:foo	test3_b:bar"
        f.puts "test4_a:foo	test4_b:bar"
      }
      sleep 1
    end

    emits = d.emits
    assert_equal(true, emits.length > 0)
    assert_equal({"test3_a"=>"foo", "test3_b"=>"bar"}, emits[0][2])
    assert_equal({"test4_a"=>"foo", "test4_b"=>"bar"}, emits[1][2])
  end


end
