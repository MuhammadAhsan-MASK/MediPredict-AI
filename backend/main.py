from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import pickle
import numpy as np
import uvicorn
import pandas as pd

app = FastAPI(title="Disease Prediction API", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load Models
try:
    model = pickle.load(open("model.pkl", "rb"))
    le = pickle.load(open("label_encoder.pkl", "rb"))
    symptoms_list = pickle.load(open("symptoms_list.pkl", "rb"))
except Exception as e:
    print(f"Error loading models: {e}")
    model = None
    le = None
    symptoms_list = []

class SymptomRequest(BaseModel):
    symptoms: List[str]

@app.get("/")
def read_root():
    return {"message": "Welcome to AI Disease Prediction API. Use POST /predict"}

@app.get("/symptoms")
def get_symptoms():
    """Return the list of accepted symptoms so the UI can build its selector"""
    return {"symptoms": symptoms_list}

@app.post("/predict")
def predict_disease(req: SymptomRequest):
    if not model:
        raise HTTPException(status_code=500, detail="Model is not loaded.")
    
    # Create input vector matching the exact features used in training
    input_vector = []
    for sym in symptoms_list:
        if sym in req.symptoms:
            input_vector.append(1)
        else:
            input_vector.append(0)

    input_array = np.array(input_vector).reshape(1, -1)
    # Convert to DataFrame with feature names matching symptoms_list to avoid UserWarning
    input_df = pd.DataFrame(input_array, columns=symptoms_list)
    
    # Predict probabilities to give a confidence score
    probabilities = model.predict_proba(input_df)[0]
    best_index = np.argmax(probabilities)
    confidence = probabilities[best_index]
    
    # Predict Label
    pred_encoded = model.predict(input_df)[0]
    prediction = le.inverse_transform([pred_encoded])[0]

    return {
        "disease": prediction,
        "confidence_score": round(float(confidence) * 100, 2),
        "message": f"There is a {round(float(confidence) * 100, 1)}% probability that you have {prediction} based on the symptoms provided."
    }

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
