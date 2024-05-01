import os
import subprocess
from telegram.ext import Updater, CommandHandler

# Token bot Telegram Anda
BOT_TOKEN = '6903848119:AAGn9zxgTdDvoo4oj1n4azvWJXzDAP8w1Rs'

# Fungsi yang akan dijalankan saat perintah /ssh diterima
def ssh_command(update, context):
    # Mendapatkan username dan hostname dari argumen perintah
    args = context.args
    if len(args) < 2:
        update.message.reply_text('Penggunaan: /ssh <username> <hostname>')
        return

    username = args[0]
    hostname = args[1]

    # Menjalankan perintah ssh
    try:
        ssh_process = subprocess.Popen(['ssh', f'{username}@{hostname}'])
        ssh_process.wait()
    except Exception as e:
        update.message.reply_text(f'Terjadi kesalahan: {str(e)}')
    else:
        update.message.reply_text('Sesi SSH berhasil')

# Memulai bot Telegram
updater = Updater(token=BOT_TOKEN, use_context=True)
dispatcher = updater.dispatcher

# Mendaftarkan handler perintah /ssh
ssh_handler = CommandHandler('ssh', ssh_command)
dispatcher.add_handler(ssh_handler)

# Memulai polling bot Telegram
updater.start_polling()