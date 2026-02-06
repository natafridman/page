import os
import json

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
CATEGORIES_DIR = os.path.join(ROOT_DIR, "Categorias")
OUTPUT_FILE = os.path.join(ROOT_DIR, "manifest.json")

manifest = {}

if not os.path.isdir(CATEGORIES_DIR):
    raise Exception("No existe la carpeta 'Categorias'")

for category in os.listdir(CATEGORIES_DIR):
    category_path = os.path.join(CATEGORIES_DIR, category)

    if not os.path.isdir(category_path):
        continue

    products = []

    for product in os.listdir(category_path):
        product_path = os.path.join(category_path, product)

        if os.path.isdir(product_path):
            products.append(product)

    if products:
        manifest[category] = sorted(products)

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(manifest, f, ensure_ascii=False, indent=2)

print("manifest.json generado correctamente")
