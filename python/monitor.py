# -*- coding: utf-8 -*- 
# pip install discord.py watchdog

import discord
import os
import config
import koyan, tere
from watchdog.observers import Observer
from libs.FileChangeHandler import FileChangeHandler
from libs.vars import *

FILE_CMD = config.DIRECTORY + '/file_io/cmd.txt'
CHANNEL_ID = config.CHANNEL_ID_1

# 起動時に動作する処理
@client.event
async def on_ready():
    # 起動したらターミナルにログイン通知が表示される
    channel = client.get_channel(CHANNEL_ID)
    await channel.send(embed=discord.Embed(title=config.TEXT_HELLO, color=0x00ff00))

# メッセージ受信時に動作する処理
@client.event
async def on_message(message):
    global CHANNEL_ID
    channel = client.get_channel(CHANNEL_ID)
    # 指定チャンネルでの指定フォーマットの人間のメッセージのみ反応
    content = message.content.replace('？','?').replace('，',',').replace('、',',')
    if message.author.bot or message.channel != channel or content[0]!='?' or len(content)<2:
        return
    elif content == '?ﾃﾚｰ' :
        await tere.teree(message)
        return
    elif content == '?有鯖に切替' :
        CHANNEL_ID = config.CHANNEL_ID_1
        await channel.send(config.TEXT_SEEYOU)
        channel = client.get_channel(CHANNEL_ID)
        await channel.send(config.TEXT_CHANGE)
        return
    elif content == '?テスト鯖に切替' :
        if message.author.id == config.KUKYURIN:
            CHANNEL_ID = config.CHANNEL_ID_2
            await channel.send(config.TEXT_SEEYOU)
            channel = client.get_channel(CHANNEL_ID)
            await channel.send(config.TEXT_CHANGE)
            return
        else :
            await channel.send(config.TEXT_REJECT)
            return
    elif content in koyan.koyans :
        await channel.send(koyan.koyans[content])
        return
    with open(FILE_CMD, encoding='utf-8') as f:
        s = f.read()
        if s and not s.startswith('empty'):
            await channel.send(config.TEXT_BUSY)
            return
    with open(FILE_CMD, mode='w', encoding='utf-8') as f:
        f.write(content[1:])
        set_waiting_message(await channel.send(config.TEXT_WAIT))
        set_prev_out_hash(None)
        
def generate_io_files():
    os.makedirs(config.DIRECTORY+'/file_io', exist_ok=True)
    if not os.path.isfile(FILE_CMD):
        with open(FILE_CMD, mode='w', encoding='utf-8') as f:
            f.write('empty')

def start():
    generate_io_files()
    event_handler = FileChangeHandler()
    observer = Observer()
    observer.schedule(event_handler, config.DIRECTORY+'/file_io')
    observer.start()
    client.run(config.TOKEN)

# Botの起動とDiscordサーバーへの接続
start()
