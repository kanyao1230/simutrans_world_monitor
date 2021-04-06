// メッセージ定義
// コマンドに対する応答
local textc_no_player = "%s 管内に赤棒はありません！\nキミは　本当に、えらいっ！" //%sはプレイヤー名
local textc_player_title = "%s  管内には 赤棒が %d 本 あります。反省しなさい\n" //%sはプレイヤー名
local textc_halt_info = "%s ... 待機 %d / 定員 %d\n" //赤棒状態の停留所情報． %sは停留所名． %dは待機数，定員．
// 監視によるメッセージ
local textm_oc_exists = "赤棒立ってる駅あるで．\n"
local textm_player_title = "<%s>\n" //%sはプレイヤー名

include("libs/monitoring_base")
include("libs/common")

// playerがnullのときは全てのplayerを検査対象とする．
function _get_overcrowded_halts(player, ratio, akabo) {
  local och = halt_list_x()
  if(player!=null) {
    local pl = player
    //なぜかinstanceの比較では==が通らない
    och = filter(och, (@(h) h.get_owner().get_name()==pl.get_name()))
  }
  local r = ratio
  local a = akabo
  och = filter(och, (@(h) h.get_waiting()[0]>h.get_capacity(good_desc_x.passenger)*r && h.get_waiting()[0]>a))
  return och
}

class get_overcrowded_cmd {
  function exec(str) {
    local player = get_player_from_num(str, 1)
    if(player==null) {
      return //エラーメッセージは既に吐かれている．
    }
    local f = file(path_output,"w")
    local params = split(str,",")
    local och = _get_overcrowded_halts(player,1, 0)
    local out_str = ""
    if(och.len()==0) {
      out_str = format(textc_no_player, player.get_name())
    } else {
      out_str = format(textc_player_title, player.get_name(), och.len())
      foreach (h in och) {
        out_str += format(textc_halt_info, h.get_name(), h.get_waiting()[0], h.get_capacity(good_desc_x.passenger))
      }
	  out_str += "※貨物駅などは赤棒でない場合があります"
    }
    f.writestr(rstrip(out_str))
    f.close() 
  }
}


class chk_overcrowded_cmd extends monitoring_base_cmd {
  overcrowded_halts = []
  warning_ratio = 1.0
  akabo_max = 1000
  
  constructor(freq, ratio, akabo) {
    monthly_check_time = freq
    warning_ratio = ratio
	akabo_max = akabo
  }
  
  function do_check() {
    local och = _get_overcrowded_halts(null, warning_ratio, akabo_max)
    local prev_och = overcrowded_halts //ラムダ式のために必要
    // なぜかhalt_xのinstance比較がいつもfalseになるので，nameで比較する．
    // あたらしくovercrowdedになったhalt
    local new_och = filter(och, (@(h) filter(prev_och, (@(k) k.get_name()==h.get_name())).len()==0))
    overcrowded_halts = och //更新
    if(new_och.len()==0) {
      // 新しく混雑した駅はないので，終了．
      return
    }
    
    // プレイヤーごとにまとめる
    local player_new_och = map(get_player_list(), (@(p) [p, filter(new_och, (@(h) p.get_name()==h.get_owner().get_name()))]))
    local out_str = textm_oc_exists
    foreach (pn in player_new_och) {
      if(pn[1].len()==0) {
        //この会社に混雑してる駅はない．
        continue
      }
      out_str += format(textm_player_title, pn[0].get_name())
      foreach (h in pn[1]) {
        out_str += format(textc_halt_info, h.get_name(), h.get_waiting()[0], h.get_capacity(good_desc_x.passenger))
      }
    }
    
    local f = file(path_output,"w")
    f.writestr(rstrip(out_str))
    f.close()
  }
}
