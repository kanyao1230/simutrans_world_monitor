
class get_waiting_cmd {
  this_halt = null
  
  function _min(a,b) {
    return a<b ? a : b
  }
  
  // "待機,XX駅" の形式でコマンドを受け取り，XX駅の現在の待機客数を返す．
  function exec(str) {
    local params = split(str,",")
    local sta_name = strip(params[1])
    local f = file(path_output,"w")
    //与えられた駅名をもつ駅を見つける
    this_halt = null
    foreach (h in halt_list_x()) {
      if(h.get_name()==sta_name) {
        this_halt = h
        break
      }
    }
    if(this_halt==null) {
      f.writestr("停車場 " + sta_name + " ←ないです．")
      f.close() 
      return
    }
    
    //目的地別のリストを作る
    local dest_halts = this_halt.get_connections(good_desc_x.passenger)
    local dests = [] //[[halt, 待機数]]
    //ラムダ式の中でthis_haltが参照できないのでfor文で．
    foreach (d in dest_halts) {
      dests.append([d, this_halt.get_freight_to_halt(good_desc_x.passenger, d)])
    }
    dests = dests.filter(@(i,d) d[1]>0) //待機客0人を除外
    dests.sort(@(a,b) b[1]<=>a[1]) //客の多さでソート．降順
    
    //結果を出力
    local out_str = sta_name + "の待機客は " + this_halt.get_waiting()[0].tostring() + "人/" + this_halt.get_capacity(good_desc_x.passenger).tostring() + "人 やね．\n"
    local num_of_dests = 5 //デフォルトでは5件
    if(params.len()>=3) {
      try{
        num_of_dests = params[2].tointeger()
      }catch(err) {
        // 無視
      }
    }
    for (local i=0; i<_min(num_of_dests, dests.len()); i++) {
      out_str += (dests[i][1].tostring() + "人 ... " + dests[i][0].get_name() + "\n")
    }
    f.writestr(rstrip(out_str))
    f.close()
  }
}


commands["待機"] <- get_waiting_cmd()