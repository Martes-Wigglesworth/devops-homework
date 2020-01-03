from flask import Flask, request
import requests
application = Flask(__name__)

@application.route('/check', methods=['POST'])
def check():
    token = request.headers['Authorization']
    data = {"token": token}
    result = requests.post('http://0.0.0.0:5001/auth', data=data).text
    if result == "wcf":
        return 'Success'
    else:
        return 'Failure in Web API'


if __name__ == "__main__":
    application.run(host='0.0.0.0', port=5000)