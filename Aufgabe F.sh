#!/bin/bash

exchange_rate_api="https://api.exchangerate-api.com/v4/latest/CHF"
crypto_api="https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=chf"
bored_api="https://www.boredapi.com/api/activity"
joke_api="https://official-joke-api.appspot.com/random_joke"

html_file="/home/lbraendli/APIAbfragenUndDarstellung/index.html"
email="luca@brasie.ch"

get_data() {
    echo "Daten abrufen..."

    # Funktion zum Abrufen der Daten und Extrahieren der Informationen
    exchange_rates=$(curl -s $exchange_rate_api)
    usd_rate=$(echo $exchange_rates | grep -oP '(?<="USD":)[0-9]+\.[0-9]+')
    eur_rate=$(echo $exchange_rates | grep -oP '(?<="EUR":)[0-9]+\.[0-9]+')

    crypto_rates=$(curl -s $crypto_api)
    btc_rate=$(echo $crypto_rates | grep -oP '(?<="bitcoin":\{"chf":)[0-9]+\.[0-9]+')
    eth_rate=$(echo $crypto_rates | grep -oP '(?<="ethereum":\{"chf":)[0-9]+\.[0-9]+')

    activity_data=$(curl -s $bored_api)
    activity=$(echo $activity_data | grep -oP '(?<="activity":")[^"]+')

    joke_data=$(curl -s $joke_api)
    joke_setup=$(echo $joke_data | grep -oP '(?<="setup":")[^"]+')
    joke_punchline=$(echo $joke_data | grep -oP '(?<="punchline":")[^"]+')

    echo "Wechselkurse:"
    echo "1 USD entspricht $usd_rate CHF"
    echo "1 EUR entspricht $eur_rate CHF"
    echo ""
    echo "Kryptowährungskurse:"
    echo "1 Bitcoin entspricht $btc_rate CHF"
    echo "1 Ethereum entspricht $eth_rate CHF"
    echo ""
    echo "Vorschlag für eine Aktivität:"
    echo "$activity"
    echo ""
    echo "Witz:"
    echo "$joke_setup"
    echo "$joke_punchline"

    # Generierung der HTML-Datei
    generate_html
}

generate_html() {
    cat <<EOF > $html_file
<!DOCTYPE html>
<html>
<head>
    <title>Tagesaktuelle Informationen</title>
    <style>
        body {
            background-color: #f8f9fa;
        }
        h1, h2 {
            color: #007bff;
        }
        .section {
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 10px;
        }
    </style>
</head>
<body>
    <h1>Tagesaktuelle Informationen</h1>
    
    <div class="section">
        <h2>Wechselkurse</h2>
        <p>1 USD entspricht $usd_rate CHF</p>
        <p>1 EUR entspricht $eur_rate CHF</p>
    </div>
    
    <div class="section">
        <h2>Kryptowährungskurse</h2>
        <p>1 Bitcoin entspricht $btc_rate CHF</p>
        <p>1 Ethereum entspricht $eth_rate CHF</p>
    </div>
    
    <div class="section">
        <h2>Vorschlag für eine Aktivität</h2>
        <p>$activity</p>
    </div>
    
    <div class="section">
        <h2>Witz</h2>
        <p>$joke_setup</p>
        <p>$joke_punchline</p>
    </div>
    
</body>
</html>
EOF
}

send_email() {
    subject="Tagesaktuelle Informationen"
    body="Siehe angehängte HTML-Datei für tagesaktuelle Informationen."

    echo "$body" | mail -s "$subject" -a "$html_file" "$email"

    echo "E-Mail wurde an $email gesendet."
}

get_data
send_email
