from fastapi import FastAPI, HTTPException, UploadFile, File, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional
import mysql.connector
from datetime import date, datetime
import os
from dotenv import load_dotenv
from PIL import Image
import io
import tensorflow as tf
import numpy as np
from pyzbar.pyzbar import decode
import cloudinary
import cloudinary.uploader
from backend.services.push_notifications import PushNotificationService

# Load environment variables
load_dotenv()

# FastAPI initialization
app = FastAPI(
    title="FitTrack API",
    description="API for the FitTrack fitness application",
    version="2.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Cloudinary setup
cloudinary.config(
    cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"),
    api_key=os.getenv("CLOUDINARY_API_KEY"),
    api_secret=os.getenv("CLOUDINARY_API_SECRET")
)

# Load TensorFlow model - fix typo here
food_model = tf.keras.models.load_model('ml_model/food_recognition.h5')
food_classes = ['apple', 'banana', 'burger', 'chicken', 'pizza', 'salad']

# Push Notification setup
push_service = PushNotificationService(api_key=os.getenv("PUSH_NOTIFICATION_API_KEY"))

# Database connection helper
def get_db_connection():
    try:
        conn = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            database=os.getenv("DB_NAME")
        )
        return conn
    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Database connection error: {err}")

# Pydantic Models
class User(BaseModel):
    id: Optional[int]
    username: str
    email: str
    password: str
    age: int
    weight: float
    height: float
    fitness_goal: str
    profile_picture: Optional[str] = None

class Activity(BaseModel):
    user_id: int
    steps: int
    heart_rate: int
    calories_burned: float
    date: date
    source: Optional[str] = None

class Meal(BaseModel):
    user_id: int
    name: str
    calories: float
    protein: float
    carbs: float
    fats: float
    date: date
    time: str
    image_url: Optional[str] = None
    barcode_data: Optional[str] = None

class WorkoutPlan(BaseModel):
    user_id: int
    name: str
    description: str
    duration: int
    difficulty: str
    exercises: List[str]

class Post(BaseModel):
    user_id: int
    content: str
    image_url: Optional[str] = None
    likes: int = 0
    created_at: datetime = Field(default_factory=datetime.now)

class Comment(BaseModel):
    user_id: int
    post_id: int
    content: str
    created_at: datetime = Field(default_factory=datetime.now)

# ------------------- ENDPOINTS -------------------

@app.post("/meals/scan-barcode")
async def scan_barcode(image: UploadFile = File(...)):
    try:
        image_data = await image.read()
        img = Image.open(io.BytesIO(image_data))
        barcodes = decode(img)
        if not barcodes:
            raise HTTPException(status_code=400, detail="No barcode detected")
        
        barcode_data = barcodes[0].data.decode("utf-8")

        # Mock data - replace with real food DB later
        mock_food_data = {
            "123456789012": {"name": "Protein Bar", "calories": 200, "protein": 20, "carbs": 15, "fats": 5},
            "987654321098": {"name": "Energy Drink", "calories": 150, "protein": 0, "carbs": 38, "fats": 0},
        }
        
        food_info = mock_food_data.get(barcode_data, {
            "name": "Unknown Product",
            "calories": 0,
            "protein": 0,
            "carbs": 0,
            "fats": 0
        })
        
        return {"barcode_data": barcode_data, "food_info": food_info}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/meals/recognize-food")
async def recognize_food(image: UploadFile = File(...)):
    try:
        image_data = await image.read()
        img = Image.open(io.BytesIO(image_data)).resize((224, 224))
        img_array = np.expand_dims(np.array(img) / 255.0, axis=0)

        predictions = food_model.predict(img_array)
        predicted_class = food_classes[np.argmax(predictions)]
        confidence = float(np.max(predictions))

        # Basic nutrition info
        nutritional_info = {
            "apple": {"calories": 95, "protein": 0.5, "carbs": 25, "fats": 0.3},
            "banana": {"calories": 105, "protein": 1.3, "carbs": 27, "fats": 0.4},
            "burger": {"calories": 354, "protein": 16, "carbs": 29, "fats": 19},
            "chicken": {"calories": 335, "protein": 25, "carbs": 0, "fats": 25},
            "pizza": {"calories": 285, "protein": 12, "carbs": 36, "fats": 10},
            "salad": {"calories": 150, "protein": 5, "carbs": 10, "fats": 10},
        }.get(predicted_class, {"calories": 0, "protein": 0, "carbs": 0, "fats": 0})

        upload_result = cloudinary.uploader.upload(image_data)
        image_url = upload_result.get("secure_url")

        return {
            "food_type": predicted_class,
            "confidence": confidence,
            "nutritional_info": nutritional_info,
            "image_url": image_url
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/posts")
async def create_post(post: Post):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO posts (user_id, content, image_url, likes, created_at) VALUES (%s, %s, %s, %s, %s)",
            (post.user_id, post.content, post.image_url, post.likes, post.created_at)
        )
        post_id = cursor.lastrowid
        conn.commit()

        push_service.notify_followers(
            user_id=post.user_id,
            message=f"New post from user {post.user_id}",
            data={"post_id": post_id}
        )

        return {"message": "Post created successfully", "post_id": post_id}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.get("/posts")
async def get_posts(limit: int = 10, offset: int = 0):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT p.*, u.username, u.profile_picture FROM posts p "
            "JOIN users u ON p.user_id = u.id "
            "ORDER BY p.created_at DESC "
            "LIMIT %s OFFSET %s",
            (limit, offset)
        )
        posts = cursor.fetchall()
        return posts
    finally:
        cursor.close()
        conn.close()

@app.post("/posts/{post_id}/like")
async def like_post(post_id: int, user_id: int = Query(..., description="ID of user liking the post")):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT id FROM post_likes WHERE post_id = %s AND user_id = %s",
            (post_id, user_id)
        )
        if cursor.fetchone():
            raise HTTPException(status_code=400, detail="Post already liked")

        cursor.execute("UPDATE posts SET likes = likes + 1 WHERE id = %s", (post_id,))
        cursor.execute("INSERT INTO post_likes (post_id, user_id) VALUES (%s, %s)", (post_id, user_id))
        conn.commit()

        push_service.notify_user(
            user_id=user_id,
            message="Someone liked your post!",
            data={"post_id": post_id}
        )

        return {"message": "Post liked successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.post("/wearable/sync")
async def sync_wearable_data(user_id: int, wearable_type: str, data: dict):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Insert activity data safely parsing dates
        for activity in data.get("activities", []):
            # Parse date string to date object if needed
            activity_date = activity.get('date')
            if isinstance(activity_date, str):
                activity_date = datetime.strptime(activity_date, '%Y-%m-%d').date()
            
            cursor.execute(
                "INSERT INTO activities (user_id, steps, heart_rate, calories_burned, date, source) "
                "VALUES (%s, %s, %s, %s, %s, 'wearable')",
                (user_id, activity['steps'], activity['heart_rate'], activity['calories'], activity_date)
            )
        conn.commit()

        cursor.execute(
            "SELECT SUM(steps) as total_steps FROM activities WHERE user_id = %s AND date = CURDATE()",
            (user_id,)
        )
        result = cursor.fetchone()
        total_steps = result[0] if result and result[0] is not None else 0

        if total_steps >= 10000:
            push_service.notify_user(
                user_id=user_id,
                message="🎉 You've reached your daily step goal!",
                data={"achievement": "daily_steps"}
            )

        return {"message": "Data synced successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()