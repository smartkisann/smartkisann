import openpyxl
from openpyxl import Workbook

# Helper function to convert month range to numeric list
def convert_month_range_to_numbers(month_range):
    month_map = {
        'January': 1, 'February': 2, 'March': 3, 'April': 4,
        'May': 5, 'June': 6, 'July': 7, 'August': 8,
        'September': 9, 'October': 10, 'November': 11, 'December': 12
    }
    
    if month_range == "All Year":
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    months = month_range.split(" to ")
    start_month = month_map[months[0]]
    end_month = month_map[months[1]]

    # Handle year crossing (e.g., October to March)
    if start_month > end_month:
        return list(range(start_month, 13)) + list(range(1, end_month + 1))
    else:
        return list(range(start_month, end_month + 1))

# Example crop data with updated values
crops_data = [
    {
        "id": 1, "name": "Rice", "min_n": 40, "max_n": 80, "min_p": 30, "max_p": 70,
        "min_k": 20, "max_k": 60, "temp_min": 20, "temp_max": 35, "latitude": "10-30", "longitude": "70-90", "months": "June to September"
    },
    {
        "id": 2, "name": "Wheat", "min_n": 30, "max_n": 70, "min_p": 20, "max_p": 60,
        "min_k": 30, "max_k": 80, "temp_min": 10, "temp_max": 25, "latitude": "20-40", "longitude": "70-80", "months": "October to March"
    },
    {
        "id": 3, "name": "Banana", "min_n": 60, "max_n": 100, "min_p": 40, "max_p": 80,
        "min_k": 50, "max_k": 90, "temp_min": 22, "temp_max": 30, "latitude": "0-20", "longitude": "70-90", "months": "All Year"
    },
    {
        "id": 4, "name": "Coconut", "min_n": 30, "max_n": 60, "min_p": 20, "max_p": 50,
        "min_k": 40, "max_k": 80, "temp_min": 25, "temp_max": 30, "latitude": "5-15", "longitude": "75-85", "months": "All Year"
    },
    {
        "id": 5, "name": "Tomato", "min_n": 40, "max_n": 70, "min_p": 30, "max_p": 60,
        "min_k": 20, "max_k": 50, "temp_min": 18, "temp_max": 30, "latitude": "20-40", "longitude": "70-80", "months": "March to August"
    },
]

# Create a new workbook and set up the sheet
wb = Workbook()
ws = wb.active
ws.title = "Crop Dataset"

# Define headers for the dataset
headers = [
    "Crop ID", "Crop Name", "Min N", "Max N", "Min P", "Max P", "Min K", "Max K", 
    "Temperature Min", "Temperature Max", "Latitude Range", "Longitude Range", "Suitable Months"
]

# Write headers to the sheet
ws.append(headers)

# Populate the sheet with crop data
for crop in crops_data:
    # Convert the months to a numeric range
    suitable_months = convert_month_range_to_numbers(crop["months"])
    
    row = [
        crop["id"], crop["name"], crop["min_n"], crop["max_n"], crop["min_p"], crop["max_p"],
        crop["min_k"], crop["max_k"], crop["temp_min"], crop["temp_max"], crop["latitude"], crop["longitude"], ','.join(map(str, suitable_months))
    ]
    ws.append(row)

# Save the workbook to a file
wb.save("crop_dataset.xlsx")

print("Dataset created successfully!")

