import smtplib, ssl, string, os, sys, subprocess
from io import StringIO
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from string import Template


hostnamecmd= "/bin/hostname"
active= subprocess.Popen(hostnamecmd, shell=True, stdout=subprocess.PIPE).stdout
actives = active.read()
f = open("/croncheck/tmp/results", "r")
content = f.read()
#port = 587  # For starttls
smtp_server = "example.mail.com"
sender_email = "alerts@sample.com"
receiver_email = "my@email.com"
password = "input pass"

message = MIMEMultipart("alternative")
message["Subject"] = "Daily Cron Report for %s" % actives.decode()


message["From"] = sender_email
message["To"] = receiver_email
html = content.decode()

part1 = MIMEText(html, "text")
message.attach(part1)

context = ssl.create_default_context()
server = smtplib.SMTP_SSL(smtp_server, 465)
#    server.ehlo()  # Can be omitted
#    server.starttls(context=context)
#    server.ehlo()  # Can be omitted
server.login(sender_email, password)
server.sendmail(sender_email, receiver_email, message.as_string())
server.quit()
