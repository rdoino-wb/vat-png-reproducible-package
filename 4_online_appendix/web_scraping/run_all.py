"""Orchestrator for the online price scrapers (RH Trading and FoodPro).

Runs rh_script.py (https://www.rhtradingpng.com/shop/) and foodpro_script.py
(https://fpr.com.pg/shop/) in turn, each writing a dated CSV under
data/raw/{rh,foodpro}/products_<YYYY-MM-DD>.csv (skipping any that already exist).

ONE-OFF MANUAL COLLECTION TOOL: each scraper requires a manual Cloudflare
"I am human" click during the run, so this is NOT part of the automated
reproducibility pipeline and must be run by hand.
"""

import os
import subprocess
import sys
import ssl
import certifi
from datetime import datetime
import atexit

# Start a background caffeinate process to prevent sleep
caffeinate_proc = subprocess.Popen(['caffeinate', '-dimsu'])
atexit.register(caffeinate_proc.terminate)  # Make sure caffeinate stops

# Setup SSL to use certifi
os.environ['SSL_CERT_FILE'] = certifi.where()
ssl._create_default_https_context = ssl._create_unverified_context

# Set extraction date
extraction_date = datetime.now().strftime("%Y-%m-%d")

# Create directory structure
print("🔄 Setting up directory structure...")
os.makedirs("data/raw/rh", exist_ok=True)
os.makedirs("data/raw/foodpro", exist_ok=True)

# Define expected filenames
rh_file = f"data/raw/rh/products_{extraction_date}.csv"
foodpro_file = f"data/raw/foodpro/products_{extraction_date}.csv"

# RH Trading scraper
if os.path.exists(rh_file):
    print("✅ RH Trading data already exists. Skipping RH Trading scraper.")
else:
    try:
        subprocess.run([sys.executable, "rh_script.py"], check=True)
        print("✅ RH Trading scraping completed successfully!")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running RH Trading scraper: {e}")

# FOODPRO scraper
if os.path.exists(foodpro_file):
    print("✅ FOODPRO Trading data already exists. Skipping FOODPRO Trading scraper.")
else:
    print("❌ FOODPRO Trading data does not exist. Running FOODPRO Trading scraper...")
    try:
        subprocess.run([sys.executable, "foodpro_script.py"], check=True)
        print("✅ FOODPRO Trading scraping completed successfully!")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running FOODPRO Trading scraper: {e}")

print("\n✨ All scraping tasks completed!")
