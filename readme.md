<h1>GadgetPi Readme</h1>

GadgetPi is bash script that unlock your Raspberry Pi Zero/Zero W USB ethernet and USB serial. This script is based on <a href="https://github.com/wismna/HackPi">HackPi</a>. Check <a href="https://github.com/wismna/HackPi">HackPi</a> also for awesome Pi gadget mode!  

<h2>Installation</h2>

<ol>
<li>Clone <a href="https://github.com/mozram/GadgetPi">GadgetPi</a> into your user's home folder (usually /home/pi):
  <br/>
  <code>git clone https://github.com/mozram/GadgetPi</code>
</li>
<li>Execute the installer:
  <br/>
  <code>sudo chmod +x install.sh</code>
  <br/>
  <code>./install.sh</code>
</li>
</li>
<li>Reboot the Pi, it should work!</li>
</ol>

For troubleshooting network issues on Linux or MacOs (not Windows at this time, unfortunately), you should be able to connect to your Raspberry Pi via the serial interface and investigate the problems:

`sudo screen /dev/ttyACM0 115200`
