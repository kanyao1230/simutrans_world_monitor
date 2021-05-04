import discord
import asyncio

client = discord.Client()

async def teree(message):
  if message.author.voice is None:
    await message.channel.send("ﾃﾚｰ")
    return
    # ボイスチャンネルに接続する
  await message.author.voice.channel.connect()
  source = discord.PCMVolumeTransformer(discord.FFmpegPCMAudio("01-Simutrans-Main-Theme.mp3"), volume=0.05)
  message.guild.voice_client.play(source)
  await asyncio.sleep(160)
  await message.guild.voice_client.disconnect()
  return