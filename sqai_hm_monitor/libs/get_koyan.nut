// ネタ用

class get_nyan_cmd {
  // にゃーん
  function exec(str) {
    local str = "にゃーん\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}

class get_koyan_cmd {
  // こゃーん
  function exec(str) {
    local str = "こゃーん\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}

class get_ebi_cmd {
  // えび
  function exec(str) {
    local str = "えびです。\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}

class get_tere_cmd {
  // テレー
  function exec(str) {
    local str = "ﾃﾚｰ ﾃﾚﾚﾃｰﾚｰ♪\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}

class get_usagi_cmd {
  // うさぎ
  function exec(str) {
    local str = "「ご注文はうさぎですか？BLOOM」\nBlu-ray & DVD 第5巻は4月28日発売！\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}

class get_hankyu_cmd {
  // はんきゅう
  function exec(str) {
    local str = "車内ではマナーを守り快適な車内環境づくりにご協力をお願いします。\n Thank you for making the ride a pleasant one by showing consideration to others.\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}

class get_uni_cmd {
  // うに
  function exec(str) {
    local str = "うにって言われたからお風呂はいってくるわ\n"
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}