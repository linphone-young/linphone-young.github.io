import subprocess
import os
import json
import requests

# def commit_urls():
urls = []
for d in ['about','archives','categories','frlink','introduction','posts','tags']:
    for root, dirs, files in os.walk(os.path.join(r'..\..\public',d)):
        for file in files:
            if file.endswith('.html') and 'posts' in root:
                urls.append(os.path.join('https://linphone-young.github.io/', root[13:], file).replace('\\','/'))

print("本次提交的urls:", urls)

# 提交到bing
headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Host": "ssl.bing.com",
}
data = {"siteUrl": "https://linphone-young.github.io/", "urlList": urls}
response = requests.post(
    url="https://www.bing.com/webmaster/api.svc/json/SubmitUrlbatch?apikey=55302f9147294dc2b90389c60f08c80d",
    headers=headers,
    data=json.dumps(data)
)
print("bing的响应: ", response.content)
