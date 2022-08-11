# Save Your Eyes (SYE)

Generates a bash script which will notify you
when you spend too much time working on PC.

Delay between notifications depends on your age
(this feature is commonly for children).

## Install
```bash
git clone https://codeberg.org/DarkCat09/saveyoureyes.git
cd saveyoureyes
chmod +x install.sh
./install.sh
```

### 1. Time
Delay is set to the safe time according to the table below.
|  Age  |Safe|Warning|
|:-----:|:--:|:-----:|
| 5 - 7 | 10 |  30   |
| 8 - 11| 15 |  45   |
|12 - 13| 20 |  60   |
|14 - 15| 25 |  80   |
|16 - 17| 30 |  90   |
|  18+  | 60 |  90   |

### 2. Exclusions
You can add some applications to whitelist/exclusions.  
When they are in processes list, notifications won't appear.

For exmaple, add vlc to disable script while you're watching a film.

### 3. Text and type
Enter notification text, title, and choose how script should send it.  
Here are some exmaples:
|Description|Screenshot|
|:----------|:--------:|
|**GtkDialog:** opens dialog using python module [https://codeberg.org/DarkCat09/showdialog](showdialog).|![Picture 1](https://i.ibb.co/qDPX20K/gtkdialog.png)|
|**libnotify:** executes notify-send command.|![Picture 2](https://i.ibb.co/5syChrV/notifysend.png)|
|**Open browser:** opens [a simple web page](https://codeberg.org/DarkCat09/pages/src/branch/main/text/index.html) using xdg-open.|![Picture 3](https://i.ibb.co/vhRsrFq/browser.png)|

### 4. Build and add to crontab
Then, the script will be generated from `.template.sh` and written to `~/.sye.sh`.  
If you want, it can automatically update crontab to run sye.sh after system boot.

But I recommend to use "Autorun" from KDE Settings if you are using Plasma. It works much better.
