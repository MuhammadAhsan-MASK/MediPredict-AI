# Use the official Python 3.9 image
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Copy requirement files and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the backend files
COPY . .

# Expose port 7860 which is required by Hugging Face Spaces
EXPOSE 7860

# Command to run the FastAPI app on port 7860
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
