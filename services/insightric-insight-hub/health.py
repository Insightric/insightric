from fastapi import FastAPI

app = FastAPI()

@app.get('/health')
def health():
    return {
        'status': 'healthy',
        'service': 'insightric-insight-hub'
    }

@app.get('/readiness')
def readiness():
    return {
        'status': 'ready',
        'service': 'insightric-insight-hub'
    }
