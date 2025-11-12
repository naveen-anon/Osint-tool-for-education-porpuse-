import re
import phonenumbers
from phonenumbers import carrier, geocoder, timezone

# -------------------------------
# Example text (replace with file/webpage content if needed)
# -------------------------------
text = """
Call me at 7840060164 .
Fake number: 12345
"""

# -------------------------------
# Step 1: Extract numbers with regex
# -------------------------------
pattern = r'(\+?\d[\d -]{8,}\d)'   # International-friendly
raw_numbers = re.findall(pattern, text)

print("📋 Extracted numbers:", raw_numbers)

# -------------------------------
# Step 2: Process each number
# -------------------------------
for raw in raw_numbers:
    try:
        # Parse with default region "IN" (India) — change if needed
        parsed = phonenumbers.parse(raw, "IN")

        if phonenumbers.is_valid_number(parsed):
            print("\n✅ Valid number found:", raw)
            print("   Region:", geocoder.description_for_number(parsed, "en"))
            print("   Carrier:", carrier.name_for_number(parsed, "en"))
            print("   Time zones:", timezone.time_zones_for_number(parsed))
        else:
            print(f"\n❌ Invalid/unknown number: {raw}")

    except Exception as e:
        print(f"\n⚠️ Error parsing {raw} → {e}")
        pip install phonenumbers