"""Scraper for RH Trading online shop (https://www.rhtradingpng.com/shop/).

Walks the shop categories and product pages and writes a dated CSV to
data/raw/rh/products_<YYYY-MM-DD>.csv.

ONE-OFF MANUAL COLLECTION TOOL: requires a manual Cloudflare "I am human"
click at the start of the run, so it is NOT part of the automated
reproducibility pipeline and must be run by hand.
"""

# Install packages if not yet done
# pip install selenium
# pip install time
# pip install pandas
# pip install datetime
# pip install re
# pip install random
# pip install undected_chromdriver

# Load the Packages
import re
import random
from urllib.parse import urlparse
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
from datetime import datetime

# Import utility functions
from utils import get_chrome_options, init_driver, save_to_csv

# Extraction date for filenames and data entries
extraction_date = datetime.now().strftime("%Y-%m-%d")

# 1) Build your stealthy options
options = get_chrome_options()

# 2) Launch undetected-chromedriver
driver = init_driver(options)

# 3) Navigate & (optionally) click your Cloudflare checkbox
driver.get("https://www.rhtradingpng.com/shop/")
input("👉 Click I am human if asked, then ENTER here…")

# 4) WebScrapping session --> no actions required

# find the category products on the SHOP page and their links  
category_items = driver.find_elements(By.XPATH, '//li[contains(@class, "product-category product")]')
category_links = [item.find_element(By.TAG_NAME, "a").get_attribute("href") for item in category_items]

# Prepare a list to store results
data = []

for url in category_links:

    # Get category name from URL
    path = urlparse(url).path
    category_name = path.strip("/").split("/")[-1]
    
    print(f"\n=== Scraping category: {category_name} ===")
    driver.get(url)
    time.sleep(5)

    while True:

        product_cards = driver.find_elements(By.CSS_SELECTOR, "li.product")
        product_links = []

        # First, collect all product links on the current page
        for card in product_cards:
            try:
                product_link = card.find_element(By.CSS_SELECTOR, "a").get_attribute("href")
                product_links.append(product_link)
            except NoSuchElementException:
                continue

        # Now visit each product page to get full details including SKU
        for link in product_links:
            try:
                driver.get(link)
                time.sleep(2)
                
                # Get product details
                try:
                    # Try to get the name from the tp-main-title div
                    name = driver.find_element(By.CSS_SELECTOR, "div.tp-main-title").text.strip()
                except NoSuchElementException:
                    # Fallback to previous method if not found
                    try:
                        name = driver.find_element(By.CSS_SELECTOR, "h1.product_title").text.strip()
                    except NoSuchElementException:
                        name = "Unknown"
                    
                try:
                    price_element = driver.find_element(By.CSS_SELECTOR, ".woocommerce-Price-amount bdi").text.strip()
                    # Use regex to extract just the number from the stock text (excluding tex such as currency)
                    price_match = re.search(r'(\d+\.\d+|\d+)', price_element)
                    price = price_match.group(1) if price_match else "0"
                except NoSuchElementException:
                    price = "Not available"
                
                # Try to get the SKU
                try:
                    product_code = driver.find_element(By.CSS_SELECTOR, "span.sku").text.strip()
                except NoSuchElementException:
                    product_code = "N/A"
                
                # Extract stock quantity (just the number)
                try:
                    stock_element = driver.find_element(By.CSS_SELECTOR, "p.stock.in-stock").text.strip()
                    # Use regex to extract just the number from the stock text
                    stock_match = re.search(r'(\d+)', stock_element)
                    stock_quantity = stock_match.group(1) if stock_match else "0"
                except NoSuchElementException:
                    stock_quantity = "0"
                
                data.append({
                    "product_category": category_name,
                    "product_name": name,
                    "price": price,
                    "product_code": product_code,
                    "stock_quantity": stock_quantity,
                    "extraction_date": extraction_date
                })
                print(f"{name} - {price} - SKU: {product_code} - Stock: {stock_quantity}")

                # Go back to the category page
                driver.back()
                time.sleep(2)
            except Exception as e:
                print(f"Error processing product: {e}")
                driver.get(url)  # Return to the category page if there's an error
                time.sleep(3)

        # After processing all products on this page, try to go to the next page
        try:
            next_button = driver.find_element(By.CSS_SELECTOR, "a.next.page-numbers")
            driver.execute_script("arguments[0].click();", next_button)
            time.sleep(3)
        except NoSuchElementException:
            print("No more pages.")
            break

driver.quit()

# Save data to CSV in the rh subfolder
filename = save_to_csv(data, "rh", extraction_date)
