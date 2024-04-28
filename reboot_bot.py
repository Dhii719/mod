import os
import telegram
from telegram.ext import Updater, CommandHandler

# Token bot Telegram Anda
TOKEN = '6903848119:AAGn9zxgTdDvoo4oj1n4azvWJXzDAP8w1Rs'

# Fungsi untuk melakukan reboot
def reboot(update, context):
    chat_id = update.effective_chat.id
    try:
        # Perintah untuk melakukan reboot
        os.system('sudo reboot')
        context.bot.send_message(chat_id=chat_id, text='Server sedang direboot...')
    except Exception as e:
        context.bot.send_message(chat_id=chat_id, text=f'Terjadi kesalahan: {e}')

def main():
    updater = Updater(TOKEN, use_context=True)
    dp = updater.dispatcher

    # Menambahkan handler untuk perintah /reboot
    dp.add_handler(CommandHandler('reboot', reboot))

    # Memulai bot
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()