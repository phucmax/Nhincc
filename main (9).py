import discord
from discord.ext import commands
from discord import app_commands
import random, json, os, datetime
from flask import Flask
from threading import Thread

# ====== ENV ======
TOKEN = os.getenv("TOKEN") or "YOUR_DISCORD_BOT_TOKEN"

money_file = "money.json"
daily_file = "daily.json"

# ====== TẠO FILE NẾU CHƯA CÓ ======
for file in [money_file, daily_file]:
    if not os.path.exists(file):
        with open(file, "w") as f:
            json.dump({}, f)

# ====== HÀM XỬ LÝ TIỀN ======
def get_money(uid):
    with open(money_file, "r") as f:
        data = json.load(f)
    return data.get(str(uid), 1000)

def update_money(uid, amount):
    with open(money_file, "r") as f:
        data = json.load(f)
    data[str(uid)] = data.get(str(uid), 1000) + amount
    with open(money_file, "w") as f:
        json.dump(data, f)

def set_money(uid, amount):
    with open(money_file, "r") as f:
        data = json.load(f)
    data[str(uid)] = amount
    with open(money_file, "w") as f:
        json.dump(data, f)

def get_all_money():
    with open(money_file, "r") as f:
        return json.load(f)

def get_daily(uid):
    with open(daily_file, "r") as f:
        return json.load(f).get(str(uid), "")

def set_daily(uid, date):
    with open(daily_file, "r") as f:
        data = json.load(f)
    data[str(uid)] = date
    with open(daily_file, "w") as f:
        json.dump(data, f)

# ====== KHỞI TẠO BOT ======
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    try:
        synced = await bot.tree.sync()
        print(f"✅ Bot online: {bot.user} | Slash commands: {len(synced)} lệnh")
    except Exception as e:
        print(f"❌ Sync lỗi: {e}")

# ====== LỆNH MINI GAME ======

@bot.tree.command(name="money", description="Xem số tiền bạn đang có")
async def money(interaction: discord.Interaction):
    amount = get_money(interaction.user.id)
    await interaction.response.send_message(f"💰 Bạn có **{amount}** xu.")

@bot.tree.command(name="tai_xiu", description="Chơi tài xỉu (min 100 xu)")
@app_commands.describe(choice="Chọn tài hoặc xỉu", bet="Số tiền cược")
async def tai_xiu(interaction: discord.Interaction, choice: str, bet: int):
    uid = interaction.user.id
    choice = choice.lower()
    if choice not in ["tài", "xỉu"] or bet < 100:
        await interaction.response.send_message("❌ Cú pháp sai hoặc cược ít nhất 100 xu!", ephemeral=True)
        return
    if get_money(uid) < bet:
        await interaction.response.send_message("❌ Không đủ tiền!", ephemeral=True)
        return
    dice = [random.randint(1, 6) for _ in range(3)]
    total = sum(dice)
    result = "tài" if total >= 11 else "xỉu"
    msg = f"🎲 {dice} → **{total}** → **{result.upper()}**\n"
    if result == choice:
        update_money(uid, bet)
        msg += f"✅ Bạn thắng! +{bet} xu."
    else:
        update_money(uid, -bet)
        msg += f"❌ Bạn thua! -{bet} xu."
    await interaction.response.send_message(msg)

@bot.tree.command(name="bau_cua", description="Chơi bầu cua")
@app_commands.describe(chon="Chọn: bầu, cua, tôm, cá, gà, nai", cuoc="Số tiền cược")
async def bau_cua(interaction: discord.Interaction, chon: str, cuoc: int):
    uid = interaction.user.id
    chon = chon.lower()
    ds = ["bầu", "cua", "tôm", "cá", "gà", "nai"]
    if chon not in ds or cuoc < 100:
        await interaction.response.send_message("❌ Sai lựa chọn hoặc cược quá ít!", ephemeral=True)
        return
    if get_money(uid) < cuoc:
        await interaction.response.send_message("❌ Không đủ tiền!", ephemeral=True)
        return
    kq = [random.choice(ds) for _ in range(3)]
    trúng = kq.count(chon)
    update_money(uid, -cuoc)
    if trúng > 0:
        update_money(uid, cuoc * trúng)
    msg = f"🎰 Kết quả: {' | '.join(kq)}\n"
    msg += f"✅ Trúng {trúng} lần! Nhận **{cuoc * trúng}** xu." if trúng else f"❌ Không trúng! Mất {cuoc} xu."
    await interaction.response.send_message(msg)

@bot.tree.command(name="xi_dach", description="Chơi Xì Dách với bot")
@app_commands.describe(cuoc="Số tiền cược")
async def xi_dach(interaction: discord.Interaction, cuoc: int):
    uid = interaction.user.id
    if cuoc < 100 or get_money(uid) < cuoc:
        await interaction.response.send_message("❌ Không đủ tiền hoặc cược quá ít!", ephemeral=True)
        return
    deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11] * 4
    random.shuffle(deck)
    def rút(): return deck.pop()
    def điểm(bài):
        total = sum(bài)
        while total > 21 and 11 in bài:
            bài[bài.index(11)] = 1
            total = sum(bài)
        return total
    user = [rút(), rút()]
    bot_cards = [rút(), rút()]
    while điểm(bot_cards) < 17: bot_cards.append(rút())
    utotal = điểm(user)
    btotal = điểm(bot_cards)
    msg = f"🃏 Bạn: {user} ({utotal})\n🤖 Bot: {bot_cards} ({btotal})\n"
    if utotal > 21:
        update_money(uid, -cuoc)
        msg += f"❌ Bạn quắc! -{cuoc} xu."
    elif btotal > 21 or utotal > btotal:
        update_money(uid, cuoc)
        msg += f"✅ Bạn thắng! +{cuoc} xu."
    elif utotal < btotal:
        update_money(uid, -cuoc)
        msg += f"❌ Bot thắng! -{cuoc} xu."
    else:
        msg += f"⚖️ Hòa tiền."
    await interaction.response.send_message(msg)

# ====== TIỀN TỆ & ADMIN ======

@bot.tree.command(name="give_money", description="Tặng tiền cho người khác")
@app_commands.describe(user="Người nhận", amount="Số tiền tặng")
async def give_money(interaction: discord.Interaction, user: discord.User, amount: int):
    uid = interaction.user.id
    if amount <= 0 or get_money(uid) < amount:
        await interaction.response.send_message("❌ Không đủ tiền hoặc số âm!", ephemeral=True)
        return
    update_money(uid, -amount)
    update_money(user.id, amount)
    await interaction.response.send_message(f"🎁 {interaction.user.mention} đã tặng **{amount}** xu cho {user.mention}!")

@bot.tree.command(name="top_money", description="Top 5 người nhiều tiền nhất")
async def top_money(interaction: discord.Interaction):
    all_money = get_all_money()
    top = sorted(all_money.items(), key=lambda x: x[1], reverse=True)[:5]
    msg = "💸 **Top 5 giàu nhất:**\n"
    for i, (uid, amount) in enumerate(top, 1):
        try:
            user = await bot.fetch_user(int(uid))
            msg += f"**#{i}** {user.mention} — {amount} xu\n"
        except: continue
    await interaction.response.send_message(msg)

@bot.tree.command(name="nhiem_vu", description="Nhận nhiệm vụ mỗi ngày")
async def nhiem_vu(interaction: discord.Interaction):
    uid = interaction.user.id
    today = datetime.date.today().isoformat()
    if get_daily(uid) == today:
        await interaction.response.send_message("📅 Bạn đã nhận hôm nay rồi!", ephemeral=True)
        return
    update_money(uid, 500)
    set_daily(uid, today)
    await interaction.response.send_message("✅ Nhận **500 xu** nhiệm vụ mỗi ngày!")

@bot.tree.command(name="create_money", description="Admin tạo tiền")
@app_commands.describe(user="Người nhận", amount="Số xu tạo")
async def create_money(interaction: discord.Interaction, user: discord.User, amount: int):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("❌ Chỉ admin!", ephemeral=True)
        return
    update_money(user.id, amount)
    await interaction.response.send_message(f"🪙 Đã tạo {amount} xu cho {user.mention}.")

@bot.tree.command(name="reset_money", description="Reset tiền về 1000")
@app_commands.describe(user="Người được reset")
async def reset_money(interaction: discord.Interaction, user: discord.User):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("❌ Admin mới được dùng!", ephemeral=True)
        return
    set_money(user.id, 1000)
    await interaction.response.send_message(f"🔄 Đã reset tiền của {user.mention} về 1000 xu.")

# ====== KEEP ALIVE (Replit) ======
app = Flask('')
@app.route('/')
def home():
    return "Bot is alive!"
def run(): app.run(host='0.0.0.0', port=8080)
def keep_alive(): Thread(target=run).start()

# ====== CHẠY BOT ======
keep_alive()
bot.run(TOKEN)