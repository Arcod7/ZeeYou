import csv
import json

def csv_to_json(csvFilePath, jsonFilePath):
    jsonArray = []
    with open(csvFilePath, encoding='utf-8') as csvf:
        csvReader = csv.DictReader(csvf)
        for row in csvReader:
            print(row.get('lang'))
            with open(jsonFilePath + row.get('locale') + '.arb', 'w', encoding='utf-8') as jsonf:
                jsonString = json.dumps(row, indent=4, ensure_ascii=False)
                jsonf.write(jsonString)

csvFilePath = r'langs.csv'
jsonFilePath = r'app_'
csv_to_json(csvFilePath, jsonFilePath)
