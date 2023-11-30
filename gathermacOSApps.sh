#!/bin/bash
# This script uses the find command to search through /Applications/Utilities and its  
# subdirectories for any .app files, collecting the name, version, and path of each 
# application and outputting them to the a timestamped CSV file in /Users/Shared directory 

# Define the filename with the current vairiable date-time and hostname for naming the csv file
current_date=$(date "+%Y-%m-%d_%H-%M-%S")
hostname=$(hostname -s)
filename="/Users/Shared/${current_date}_macos_apps_${hostname}.csv"

# Add CSV headers to the CSV file
echo "Application Name,Version,Path" > "$filename"

# Function to extract app details from Apps found
extract_app_details() {
    # Find all .app files in the directory and its subdirectories
    find "$1" -name "*.app" -type d | while read app_path; do
        if [ -d "$app_path" ]; then
            local app_name=$(defaults read "$app_path/Contents/Info.plist" CFBundleName 2>/dev/null)
            local app_version=$(defaults read "$app_path/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null)

            # Check if the app name and version are found
            if [ "$app_name" ] && [ "$app_version" ]; then
                echo "\"$app_name\",\"$app_version\",\"$app_path\"" >> "$filename"
            fi
        fi
    done
}

# Process Applications in /Applications, ~/Applications, and /Applications/Utilities
extract_app_details "/Applications"
extract_app_details "$HOME/Applications"
extract_app_details "/Applications/Utilities"

echo "Application details saved to $filename"
