import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
import pickle


try:
    df = pd.read_csv("Testing.csv")  
except FileNotFoundError:
    print("❌ ERROR: Dataset file 'Testing.csv' not found.")
    exit()


if 'prognosis' not in df.columns:
    print("❌ ERROR: Column 'prognosis' not found in dataset.")
    exit()

X = df.drop(columns=['prognosis'])
y = df['prognosis']


le = LabelEncoder()
y_encoded = le.fit_transform(y)


model = RandomForestClassifier()
model.fit(X, y_encoded)

# Step 5: Save model and label encoder
pickle.dump(model, open("model.pkl", "wb"))
pickle.dump(le, open("label_encoder.pkl", "wb"))

print("✅ Model and label encoder saved successfully!")
