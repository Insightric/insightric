from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'healthy',
        'service': 'insightric-ai-service'
    }), 200

@app.route('/readiness', methods=['GET'])
def readiness():
    return jsonify({
        'status': 'ready',
        'service': 'insightric-ai-service'
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
