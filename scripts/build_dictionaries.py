import json

# Base existing English and Italian keys from lib/l10n/app_en.arb and lib/l10n/app_it.arb
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_base = json.load(f)
with open('lib/l10n/app_it.arb', 'r', encoding='utf-8') as f:
    it_base = json.load(f)

print(f"Loaded {len(en_base)} keys from app_en.arb and {len(it_base)} from app_it.arb")
