
local text_title = "コマンド 「%s」 ←そんなのないよありえない <:heta:701840232290451476>"
local text_desc = "コマンド一覧はこちら"
local text_cmds = [["待機客を取得","`?待機,<駅名>,エントリ数`"],["プレイヤー番号を取得","`?プレイヤー`"],["待機客が溢れている駅を取得","`?赤棒,<プレイヤー番号>`"],["現在の年月を取得","`?時間`"],["各社の残金を取得","`?財務`"],["路線の一覧を取得","`?路線,<プレイヤー番号>,<waytype(option)>`"],["停車駅を取得","`?停車駅,<路線番号>,<停車場数(option)>`"]]
local text_footer = "詳しくはWebで！\n https://github.com/teamhimeh/simutrans_world_monitor#使用方法"

function send_help(cmd_str) {
  embed_error(format(text_title, cmd_str), text_desc, text_cmds, text_footer)
}
