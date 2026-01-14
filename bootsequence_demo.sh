
#!/bin/bash
sleep 15
echo "Starting boot sequence"

wol xx:xx:xx:xx:xx:xx &

# Open Daily Checklist in a new terminal
alacritty -t "Daily Checklist" -e python3 /home/natal/Dev/autostart-prompter/bootPrompt.py &

# Open Reminders in a new terminal
alacritty -t "Reminders" -e ruby /home/natal/Dev/BotReminder/bot_reminder.rb &

# Ping specter before trying Rsync, one wait and retry if silent ping.
if ping -c 3 -W 2 192.168.1.5; then
    echo "Target host is online (First attempt). Starting backup..."
    alacritty -t "Backup" -e python3 /home/natal/Dev/Rsync/backup.py &
else
    echo "Ping failed, giving it a minute to wake up fully."
    sleep 260
    
 
    if ping -c 3 -W 2 192.168.1.5; then
        echo "Target host is online (Second attempt). Starting backup..."
        alacritty -t "Backup" -e python3 /home/natal/Dev/Rsync/backup.py &
    else
        echo "Second ping also failed. Skipping backup."
  
    fi
   
fi
