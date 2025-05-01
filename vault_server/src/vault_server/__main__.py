import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

uvicorn.run(
        app,
        host="127.0.0.1",
        port=5000,
        log_level="trace",
    )
