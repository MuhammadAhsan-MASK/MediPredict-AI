# 🩺 MediPredict-AI

**MediPredict-AI** is an advanced AI-powered disease prediction system that bridge the gap between symptoms and medical insights. It consists of a high-performance **FastAPI backend** running a Machine Learning model and a stunning **Flutter mobile application** for a seamless user experience.

---

## 🚀 Features

- **AI-Powered Predictions**: Uses a trained Random Forest (or similar) model to predict diseases based on user-input symptoms.
- **Dynamic Symptom Selection**: Real-time fetching of supported symptoms from the backend.
- **Confidence Scoring**: Not just a prediction, but a confidence percentage for better insight.
- **Cross-Platform**: Built with Flutter for Android, iOS, and Web.
- **Modern UI**: Sleek, intuitive, and responsive design.

---

## 🛠️ Tech Stack

### Backend
- **Framework**: [FastAPI](https://fastapi.tiangolo.com/)
- **Machine Learning**: [Scikit-learn](https://scikit-learn.org/), [Pandas](https://pandas.pydata.org/), [NumPy](https://numpy.org/)
- **Server**: [Uvicorn](https://www.uvicorn.org/)
- **Containerization**: Docker support included.

### Frontend
- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **Networking**: [HTTP Package](https://pub.dev/packages/http)

---

## 📁 Project Structure

```text
MediPredict-AI/
├── backend/                # Python FastAPI Backend
│   ├── main.py             # API Entry point
│   ├── train_model.py      # Model training script
│   ├── model.pkl           # Trained ML Model
│   └── requirements.txt    # Python dependencies
├── disease_prediction_app/ # Flutter Mobile App
│   ├── lib/                # App logic and UI
│   ├── assets/             # Images and fonts
│   └── pubspec.yaml        # Flutter dependencies
└── web_reference/          # Legacy/Web implementation reference
```

---

## ⚙️ Installation & Setup

### 1. Backend Setup
```bash
cd backend
# Install dependencies
pip install -r requirements.txt
# Run the API server
python main.py
```
*The API will be available at `http://127.0.0.1:8000`*

### 2. Frontend Setup
```bash
cd disease_prediction_app
# Fetch dependencies
flutter pub get
# Run the application
flutter run
```

---

## 📖 Usage
1. Open the **MediPredict-AI** app.
2. Select your symptoms from the dynamic list.
3. Tap on **Predict**.
4. View the predicted disease and the confidence score.

---

## 🤝 Contributing
Contributions are welcome! Feel free to open a Pull Request or report an issue.

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

---

> [!TIP]
> Always consult a medical professional for a formal diagnosis. This tool is for informational purposes only.
