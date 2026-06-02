import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
import pickle
import os

def main():
    print("Loading Expanded Dataset...")
    try:
        df = pd.read_csv("Expanded_Dataset.csv")  
    except FileNotFoundError:
        print("❌ ERROR: Dataset file 'Expanded_Dataset.csv' not found. Run expand_dataset.py first.")
        return

    if 'prognosis' not in df.columns:
        print("❌ ERROR: Column 'prognosis' not found in dataset.")
        return

    X = df.drop(columns=['prognosis'])
    y = df['prognosis']

    print("Encoding labels...")
    le = LabelEncoder()
    y_encoded = le.fit_transform(y)

    print("Training improved Random Forest model...")
    # To save time in demo, we'll use a strong base estimator instead of exhaustive GridSearch
    model = RandomForestClassifier(n_estimators=150, max_depth=None, random_state=42)
    model.fit(X, y_encoded)

    # Save model and label encoder
    print("Saving artifacts...")
    pickle.dump(model, open("model.pkl", "wb"))
    pickle.dump(le, open("label_encoder.pkl", "wb"))
    
    # Save the feature names (symptoms list) so the API knows the exact order
    symptoms = list(X.columns)
    pickle.dump(symptoms, open("symptoms_list.pkl", "wb"))

    print("✅ Improved Model, label encoder, and symptoms list saved successfully!")

if __name__ == "__main__":
    main()
