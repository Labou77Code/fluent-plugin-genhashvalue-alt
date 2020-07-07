# coding: utf-8
require 'helper'

class GenHashValueFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::GenHashValueFilter).configure(conf)
  end

  def test_configure
    #### set configurations
    d = create_driver %[
      keys id, time
    ]
    #### check configurations
    assert_equal 'sha256', d.instance.hash_type
    assert_equal false, d.instance.base64_enc
    assert_equal '_', d.instance.separator
    assert_equal '_hash', d.instance.set_key
    assert_equal ['id', 'time'], d.instance.keys

    d = create_driver %[
      keys id2
      hash_type md5
      base64_enc true
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ]
    #### check configurations
    assert_equal 'md5', d.instance.hash_type
    assert_equal true, d.instance.base64_enc
    assert_equal ',', d.instance.separator
    assert_equal '_id', d.instance.set_key
    assert_equal ['id2'], d.instance.keys
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" => "94666f1c6ecde15a182a8a165bd9c2a0"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "lGZvHG7N4VoYKooWW9nCoA=="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "VT.Jo=nV~PT7k<Cg=K`T"}
       )
  def test_md5(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type md5 # md5 or sha1 or sha256 or sha512
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2011-01-02 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test', shutdown: false) do
      d.feed(time, {"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"})
      d.feed(time, {"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" => "04b34892838c50d7e05b2d7ac471485e02323282"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "BLNIkoOMUNfgWy16xHFIXgIyMoI="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "t1mz#vxE?]UntYN+)Xb1PjgMM"}
       )
  def test_sha1(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha1 # md5 or sha1 or sha256 or sha512
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2011-01-02 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" => "faf53c1c9cc89e896b812f90ac77ad04447faece9eff6cbf62975c618c5ffb1f"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "+vU8HJzInolrgS+QrHetBER/rs6e/2y/YpdcYYxf+x8="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "q(gFR&W^=@/E3Y~^urp\"|~B\"B\"B\"B\"B\"B\"B\"B\"B\"\"\""}
       )
  def test_sha256(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha256 # md5 or sha1 or sha256 or sha512
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2016-10-23 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" =>"a9188951cec474bf5a0704f3fefc00f9e903d0190c7daed5cca1a190346d508da640a939b25b2455d0acdd2ad6c49c218ac31e3fb6a70c7ae2838e4cfab955fc"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "qRiJUc7EdL9aBwTz/vwA+ekD0BkMfa7VzKGhkDRtUI2mQKk5slskVdCs3SrWxJwhisMeP7anDHrig45M+rlV/A=="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "J+go,3[a^sfK`hA\"/C1~)CZ3Mvj%X}J@M1Nbz4cmm4q[ks,Mj2u}NeKsQ_WOL<RWkWNu|*G^u6h_x]f"}
       )
  def test_sha512(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha512 # md5 or sha1 or sha256 or sha512
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2016-10-23 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" =>"c283c0806dc63da6f66eda61a044537c"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "woPAgG3GPab2btphoERTfA=="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
			"expected" => "1KU!R=v=s`F&[U3?S2_K"}
       )

  class UseEntireRecordAsSeedTest < self

    def sample_record
      {'age' => 26, 'request_id' => '42', 'parent_id' => 'parent', 'routing_id' => 'routing'}
    end

    data("md5" => ["md5", "MuMU0gHOP1cWvvg/J4aEFg=="],
          "sha1" => ["sha1", "GZ6Iup9Ywyk5spCWtPQbtZnfK0U="],
          "sha256" => ["sha256", "O4YN0RiXCUAYeaR97UUULRLxgra/R2dvTV47viir5l4="],
          "sha512" => ["sha512", "FtbwO1xsLUq0KcO0mj0l80rbwFH5rGE3vL+Vgh90+4R/9j+/Ni/ipwhiOoUcetDxj1r5Vf/92B54La+QTu3eMA=="],)
    def test_record
      hash_type, expected = data
      d = create_driver(%[
        use_entire_record true
        hash_type #{hash_type}
        inc_tag_as_key false
        inc_time_as_key false
        base64_enc true
      ])
      time = event_time("2017-10-15 15:00:23.34567890 UTC")
      d.run(default_tag: 'test.fluentd') do
        d.feed(time, sample_record.merge("custom_key" => "This is also encoded value."))
      end
      assert_equal(expected,
                    d.filtered.map {|e| e.last}.first[d.instance.set_key])
    end

    data("md5" => ["md5", "GJfpWe8ofiGzn97bc9Gh0Q=="],
          "sha1" => ["sha1", "AVaK67Tz0bEJ8xNEzjOQ6r9fAu4="],
          "sha256" => ["sha256", "WIXWAuf/Z94Uw95mudloo2bgjhSsSduQIwkKTQsNFgU="],
          "sha512" => ["sha512", "yjMGGxy8uc7gCrPgm8W6MzJGLFk0GtUwJ6w/91laf6WNywuvG/7T6kNHLagAV8rSW8xzxmtEfyValBO5scuoKw=="],)
    def test_record_with_tag
      hash_type, expected = data
      d = create_driver(%[
        use_entire_record true
        hash_type #{hash_type}
        inc_tag_as_key true
        inc_time_as_key false
        base64_enc true
      ])
      time = event_time("2017-10-15 15:00:23.34567890 UTC")
      d.run(default_tag: 'test.fluentd') do
        d.feed(time, sample_record.merge("custom_key" => "This is also encoded value."))
      end
      assert_equal(expected,
                    d.filtered.map {|e| e.last}.first[d.instance.set_key])
    end

    data("md5" => ["md5", "5nQSaJ4F1p9rDFign13Lfg=="],
          "sha1" => ["sha1", "hyo9+0ZFBpizKl2NShs3C8yQcGw="],
          "sha256" => ["sha256", "romVsZSIksbqYsOSnUzolZQw76ankcy0DgvDZ3CayTo="],
          "sha512" => ["sha512", "RPU7K2Pt0iVyvV7p5usqcUIIOmfTajD1aa7pkR9qZ89UARH/lpm6ESY9iwuYJj92lxOUuF5OxlEwvV7uXJ07iA=="],)
    def test_record_with_time
      hash_type, expected = data
      d = create_driver(%[
        use_entire_record true
        hash_type #{hash_type}
        inc_tag_as_key false
        inc_time_as_key true
        base64_enc true
      ])
      time = event_time("2017-10-15 15:00:23.34567890 UTC")
      d.run(default_tag: 'test.fluentd') do
        d.feed(time, sample_record.merge("custom_key" => "This is also encoded value."))
      end
      assert_equal(expected,
                    d.filtered.map {|e| e.last}.first[d.instance.set_key])
    end

    data("md5" => ["md5", "zGQF35KlMUibJAcgkgQDtw=="],
          "sha1" => ["sha1", "1x9RZO1xEuWps090qq4DUIsU9x8="],
          "sha256" => ["sha256", "eulMz0eF56lBEf31aIs0OG2TGCH/aoPfZbRqfEOkAwk="],
          "sha512" => ["sha512", "mIiYATtpdUFEFCIZg1FdKssIs7oWY0gJjhSSbet0ddUmqB+CiQAcAMTmrXO6AVSH0vsMvao/8vtC8AsIPfF1fA=="],)
    def test_record_with_tag_and_time
      hash_type, expected = data
      d = create_driver(%[
        use_entire_record true
        hash_type #{hash_type}
        inc_tag_as_key true
        inc_time_as_key true
        base64_enc true
      ])
      time = event_time("2017-10-15 15:00:23.34567890 UTC")
      d.run(default_tag: 'test.fluentd') do
        d.feed(time, sample_record.merge("custom_key" => "This is also encoded value."))
      end
      assert_equal(expected,
                    d.filtered.map {|e| e.last}.first[d.instance.set_key])
    end
  end
end

