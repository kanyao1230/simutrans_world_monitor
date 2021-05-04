// メッセージ定義
// コマンドに対する応答
local textc_no_player = "%s 管内に赤棒はありません！\nキミは　本当に、えらいっ！" //%sはプレイヤー名
local textc_player_title = "%s  管内には 赤棒が %d 本 あります。反省しなさい\n" //%sはプレイヤー名
local textc_halt_info = "%s ... 待機 %d / 定員 %d\n" //赤棒状態の停留所情報． %sは停留所名． %dは待機数，定員．
// 監視によるメッセージ
local textm_oc_exists = "赤棒がたっている駅があります\n"
local textm_player_title = "<%s>\n" //%sはプレイヤー名

include("libs/monitoring_base")
include("libs/common")
include("libs/embed_out")

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
    local params = split(str,",")
    local och = _get_overcrowded_halts(player,1, 0)
    if(och.len()==0) {
      embed_normal(format(textc_no_player, player.get_name()))
    } else {
      local title = format(textc_player_title, player.get_name(), och.len())
      local desc = ""
      foreach (h in och) {
        desc += format(textc_halt_info, h.get_name(), h.get_waiting()[0], h.get_capacity(good_desc_x.passenger))
      }
	    desc += "※貨物駅などは赤棒でない場合があります"
      embed_warn(title, desc)
    }
  }
}


class chk_overcrowded_cmd extends monitoring_base_cmd {
  warning_ratio = 1.0
  akabo_max = 1000
  
  constructor(freq, ratio, akabo) {
    monthly_check_time = freq
    warning_ratio = ratio
	  akabo_max = akabo
    init_states("chk_overcrowded_cmd", [["och", []]])
  }
  
  function do_check() {
    local ms = monitoring_state()
    local och = _get_overcrowded_halts(null, warning_ratio, akabo_max)
    local prev_och = ms.state[task_name]["och"] // nameのstring値が格納されている
    // なぜかhalt_xのinstance比較がいつもfalseになるので，nameで比較する．
    // あたらしくovercrowdedになったhalt
    local new_och = filter(och, (@(h) filter(prev_och, (@(k) k==h.get_name())).len()==0))
    ms.state[task_name]["och"] = map(och, (@(h) h.get_name())) //更新
    ms.save()
    if(new_och.len()==0) {
      // 新しく混雑した駅はないので，終了．
      return
    }
    
    // プレイヤーごとにまとめる
    local new_och_msg = []
    local player_new_och = map(get_player_list(), (@(p) [p, filter(new_och, (@(h) p.get_name()==h.get_owner().get_name()))]))
    foreach (pn in player_new_och) {
      if(pn[1].len()==0) {
        //この会社に混雑してる駅はない．
        continue
      }
      local pl_title = format(textm_player_title, pn[0].get_name())
      local out_str = ""
      foreach (h in pn[1]) {
        out_str += format(textc_halt_info, h.get_name(), h.get_waiting()[0], h.get_capacity(good_desc_x.passenger))
      }
      new_och_msg.append([pl_title, out_str])
    }
    embed_warn(textm_oc_exists, null, new_och_msg)
  }
}
