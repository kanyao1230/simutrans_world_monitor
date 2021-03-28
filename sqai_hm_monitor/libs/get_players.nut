include("libs/common")

class get_players_cmd {
  // プレイヤーの一覧を返す
  function exec(str) {
    local idx = 1
    local str = "プレイヤーの一覧\n"
    foreach (player in get_player_list()) {
      str += idx.tostring() + " : " + player.get_name() + "\n"
      idx += 1
    }
    local f = file(path_output,"w")
    f.writestr(rstrip(str))
    f.close() 
  }
}
