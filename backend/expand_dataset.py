import pandas as pd
import numpy as np

def main():
    print("Reading original dataset...")
    try:
        df = pd.read_csv("../web_reference/Testing.csv")
    except FileNotFoundError:
        print("Error: Could not find Testing.csv")
        return

    # Check the columns
    columns = list(df.columns)
    
    # Let's add 'loss_of_taste' if it doesn't exist
    new_symptoms = ['loss_of_taste', 'severe_headache']
    
    for sym in new_symptoms:
        if sym not in columns:
            df[sym] = 0
            # Insert before 'prognosis' column
            cols = list(df.columns)
            cols.remove('prognosis')
            cols.append('prognosis')
            df = df[cols]

    columns = list(df.columns)
    
    # Synthetic Data Generations for New Diseases
    synthetic_records = []
    
    # 1. COVID-19
    covid_symptoms = ['high_fever', 'cough', 'fatigue', 'breathlessness', 'loss_of_smell', 'loss_of_taste', 'muscle_pain']
    for _ in range(25): # create 25 variations
        record = {col: 0 for col in columns}
        record['prognosis'] = 'COVID-19'
        for sym in covid_symptoms:
            if sym in record and np.random.rand() > 0.1: # 90% chance to have the symptom
                record[sym] = 1
        synthetic_records.append(record)

    # 2. Zika Virus
    zika_symptoms = ['skin_rash', 'mild_fever', 'muscle_pain', 'redness_of_eyes', 'joint_pain']
    for _ in range(25):
        record = {col: 0 for col in columns}
        record['prognosis'] = 'Zika Virus'
        for sym in zika_symptoms:
            if sym in record and np.random.rand() > 0.1:
                record[sym] = 1
        synthetic_records.append(record)

    # 3. Severe Migraine
    migraine_symptoms = ['severe_headache', 'dizziness', 'nausea', 'visual_disturbances', 'depression']
    for _ in range(25):
        record = {col: 0 for col in columns}
        record['prognosis'] = 'Severe Migraine'
        for sym in migraine_symptoms:
            if sym in record and np.random.rand() > 0.1:
                record[sym] = 1
        synthetic_records.append(record)
        
    df_new = pd.DataFrame(synthetic_records)
    df_combined = pd.concat([df, df_new], ignore_index=True)
    
    # Save the expanded dataset
    df_combined.to_csv("Expanded_Dataset.csv", index=False)
    print(f"Expanded dataset saved! Old shape: {df.shape}, New shape: {df_combined.shape}")
    print(f"Added {len(new_symptoms)} new symptoms and 3 new diseases (COVID-19, Zika Virus, Severe Migraine).")
    
if __name__ == "__main__":
    main()
