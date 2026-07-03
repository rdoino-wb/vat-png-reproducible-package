"""Scraper for FoodPro online shop (https://fpr.com.pg/shop/).

Walks the shop categories and product pages and writes a dated CSV to
data/raw/foodpro/products_<YYYY-MM-DD>.csv.

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
import os
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
driver.get("https://fpr.com.pg/shop/")
input("👉 Click I am human if asked, then ENTER here…")

# 4) WebScrapping session --> no actions required

# find the category products on the SHOP page and their links  
category_items = driver.find_elements(By.XPATH, '//a[span[contains(@class, "wc-block-product-categories-list-item__name")]]')
category_links = [item.get_attribute("href") for item in category_items]

# Prepare a list to store results
data = []

for url in category_links:

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
            # Primary: get from product title <a>
                product_link = card.find_element(By.CSS_SELECTOR, "li.title h2 a").get_attribute("href")
                product_links.append(product_link)      
            except NoSuchElementException:
                try:
                    # Fallback: get from <form class="cart" action="...">
                    product_link = card.find_element(By.CSS_SELECTOR, "form.cart").get_attribute("action")
                    print(f"Fallback link: {product_link}")
                    product_links.append(product_link)            
                except NoSuchElementException:
                    print("No product link found")
                    continue
                
        # Now visit each product page to get full details including SKU
        for link in product_links:
            try:
                print(link)
                driver.get(link)
                time.sleep(2)
                
                # Get product details
                try:
                    # Try to get the name from the tp-main-title div
                    name = driver.find_element(By.CSS_SELECTOR, "h2.single-post-title.product_title.entry-title").text
                except NoSuchElementException:
                    name = driver.find_element(By.CSS_SELECTOR, ".woocommerce-product-details_short-description").get_attribute("textContent")
                except NoSuchElementException:
                    name = "Unknown"
                        
                try:
                    price_element = driver.find_element(By.CSS_SELECTOR, ".woocommerce-Price-amount bdi").get_attribute("textContent")
                    # Use regex to extract just the number from the stock text (excluding tex such as currency)
                    price_match = re.search(r'(\d+\.\d+|\d+)', price_element.replace('\xa0', ''))
                    price = price_match.group(1) if price_match else "0"
                except NoSuchElementException:
                    price = "Not available"

                data.append({
                    "product_category": category_name,
                    "product_name": name,
                    "price": price,
                    "extraction_date": extraction_date
                })
                print(f"{name} - {price}")

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

# Save data to CSV in the foodpro subfolder
filename = save_to_csv(data, "foodpro", extraction_date)
