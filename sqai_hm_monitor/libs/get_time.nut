
class get_time_cmd {
  // 今の時間を返す
  function exec(str) {
    local time = world.get_time()
    local f = file(path_output,"w")
    f.writestr("ただいまの時刻" + time.year + "年" + time.month + "月になるところです。")
    f.close() 
  }
}
