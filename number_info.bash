#!/data/data/com.termux/files/usr/bin/bash
# -----------------------------------------
# Number Info Tool Setup for Termux
# Educational Purpose Only
# -----------------------------------------

echo "========================================"
echo " 📱 Number Info Tool — Setup Script"
echo "========================================"
sleep 1

echo "[1] Updating packages..."
pkg update -y && pkg upgrade -y

echo "[2] Installing Python and tools..."
pkg install python git nano -y

echo "[3] Installing Python libraries..."
pip install requests python-dotenv

echo "[4] Creating working directory..."
mkdir -p ~/numberinfo
cd ~/numberinfo || exit

# Create main script
cat > number_info.py << 'EOF'
#!/usr/bin/env python3
import os, json, time, requests
from datetime import datetime

try:
    from dotenv import load_dotenv
    load_dotenv()
except Exception:
    pass

HISTORY_FILE = "history.json"
API_KEY = os.getenv("NUMVERIFY_API_KEY")

def get_key():
    if API_KEY:
        return API_KEY
    key = input("Enter your Numverify API key: ").strip()
    if not key:
        print("API key required!")
        exit()
    return key

def lookup(api_key, number):
    url = "http://apilayer.net/api/validate"
    params = {"access_key": api_key, "number": number, "format": 1}
    r = requests.get(url, params=params, timeout=10)
    data = r.json()
    if not data.get("valid"):
        print("Invalid number or API limit reached.")
    return data

def show(data):
    print("\n======== Number Info ========")
    print(f"Number: {data.get('number')}")
    print(f"Valid: {data.get('valid')}")
    print(f"Country: {data.get('country_name')} ({data.get('country_code')})")
    print(f"Location: {data.get('location')}")
    print(f"Carrier: {data.get('carrier')}")
    print(f"Line type: {data.get('line_type')}")
    print("==============================\n")

def save_history(number, result):
    rec = {"time": datetime.utcnow().isoformat(), "number": number, "result": result}
    try:
        hist = json.load(open(HISTORY_FILE)) if os.path.exists(HISTORY_FILE) else []
    except Exception:
        hist = []
    hist.append(rec)
    json.dump(hist, open(HISTORY_FILE, "w"), indent=2)

def main():
    print("📱 Number Info Tool — Educational Only\n")
    api_key = get_key()
    while True:
        num = input("Enter phone number (or type exit): ").strip()
        if num.lower() in ("exit", "quit"):
            print("Bye 👋")
            break
        if not num:
            continue
        try:
            data = lookup(api_key, num)
            show(data)
            save_history(num, data)
            time.sleep(1)
        except Exception as e:
            print("Error:", e)
            time.sleep(1)

if __name__ == "__main__":
    main()
EOF

chmod +x number_info.py

# Create optional .env file
cat > .env << 'EOF'
NUMVERIFY_API_KEY=your_api_key_here
EOF

echo "[5] Setup complete!"
echo "Run your tool anytime using:"
echo "  cd ~/numberinfo && python number_info.py"
echo "-----------------------------------------"
